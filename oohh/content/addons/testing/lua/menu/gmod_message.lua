if CLIENT then return end

gmod = gmod or {}

gmod.Ip = "88.191.111.120"
gmod.ClientPort = 27011
gmod.ServerPort = 27010

gmod.Hooks = gmod.Hooks or {}

function gmod.Hook(tag, callback)
	gmod.Hooks[tag] = callback
end

local function decode(str)
	local args = sigh.Decode(str)

	local id = args[1]
	table.remove(args, 1)

	return id, args
end

local function encode(id, ...)
	return sigh.Encode(id, ...)
end

function gmod.Send(id, ...)
	local str = encode(id, ...)

	gmod.RawSend(str)
end

function gmod.ReceiveFromGmod(str)
	local id, args = decode(str)

	if gmod.Hooks[id] then
		gmod.Hooks[id](unpack(args))
	end
end
hook.Add("GmodMessage", "gmod", gmod.ReceiveFromGmod, print)

-- socket specific code

function gmod.RawSend(str)
	if gmod_client then
		gmod_client:send(str)
	else
		gmod.Connect()
	end
end

function gmod.Connect(ip, port)
	ip = ip or gmod.Ip
	port = port or gmod.ClientPort

	if gmod_client then
		gmod_client:close()
	end

	local ok, msg = pcall(function()
		gmod_client = assert(socket.tcp())
		gmod_client:settimeout(0)
		gmod_client:connect(gmod.Ip, gmod.ClientPort)
	end)

	if not ok then
		printf("[gmod client] could not connect: %s", msg)
	end
end

gmod.Connect()

gmod.Clients = gmod.Clients or {}

function gmod.CloseClient(client, ip)
	ip = ip or client:getpeername()
	print("[oohh server] closing client: ", ip)
	client:close()
	gmod.Clients[ip] = nil
	timer.Remove("gmod_client_"..ip)
end

function gmod.AddClient(client)
	client:settimeout(0)

	local ip, port = client:getpeername()

	if gmod.Clients[ip] then
		print("[oohh server] closing existing client: ", ip)
		gmod.CloseClient(gmod.Clients[ip], ip)
	end

	gmod.Clients[ip] = client

	timer.Create("gmod_client_"..ip, 0, 0, function()
		local str, err = client:receive()

		if str then
			--print("[oohh server] client message: ", ip, port)
			hook.Call("GmodMessage", str)
		elseif err == "closed" then
			gmod.CloseClient(client)
		elseif err ~= "timeout" then
			print("[oohh server] client error '", err, "'", ip, port)
			gmod.CloseClient(client)
		end
	end)

	print("[oohh server] new client: ", ip, port)
end

function gmod.StartServer(port)
	port = port or gmod.ServerPort

	print("[oohh server] starting server at port", port)

	for ip, client in ipairs(gmod.Clients) do
		gmod.CloseClient(client, ip)
	end

	gmod.Clients = {}

	if gmod_server then
		gmod_server:close()
	end

	local ok, msg = pcall(function()
		gmod_server = assert(socket.tcp())
		gmod_server:settimeout(0)
		gmod_server:setoption("reuseaddr", true)
		gmod_server:bind("*", port)
		gmod_server:listen()

		hook.Add("PostGameUpdate", "gmod_server", function()
			if gmod_server then
				local client, msg = gmod_server:accept()

				if client then
					gmod.AddClient(client)
				end
			end
		end)
	end)

	if not ok then
		printf("[oohh server] could not start server [%s]: %s", port, msg)
	end
end

function gmod.StopServer()
	if tostring(gmod_server):find("tcp") then -- how do i tell if it's a socket?
		gmod_server:close()
		print("[oohh server] closed server")
	end
end

hook.Add("LuaClose", "gmod_server", gmod.StopServer)

gmod.StartServer()

gmod.Hook("hello", function(...)
	print(...)
end)

gmod.Send("hello", "hello from oohh!")

--|

gmod.Hook("connect", function(ip, port)
	gmod.Connect(ip, port)
end)

hook.Add("ConsolePrint", "gmod", function(str)
	gmod.Send("console", str)
end)

gmod.Hook("l", function(str)
	local data = easylua.RunLua(entities.GetLocalPlayer(), str)
	if data.error then
		print(data.error)
	end
end)

hook.Add("PlayerSay", "oohh", function(ply, str)
	gmod.Send("l", ('all:SendLua([[local tbl = chat.AddTimeStamp({}) table.insert(tbl, Color(90, 145, 68, 255)) table.insert(tbl, %q) table.insert(tbl, Color(255, 255, 255)) table.insert(tbl, ": " .. %q) chat.AddText(unpack(tbl))]])'):format(ply:GetNickname(), str))
end)