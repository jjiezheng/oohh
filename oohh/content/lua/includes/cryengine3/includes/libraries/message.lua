message = message or {}

message.Hooks = message.Hooks or {}

function message.Hook(tag, callback)
	message.Hooks[tag] = callback
end

do -- filter
	local META = {}
	META.__index = META

	META.players = {}
	META.__metaname = "netmsg_player_filter"

	function META:AddAll()
		for key, ply in pairs(entities.GetAllPlayers()) do
			self.players[ply:GetId()] = ply
		end

		return self
	end

	function META:AddAllExcept(ply)
		self:AddAllExcept()
		self.players[ply:GetId()] = nil

		return self
	end

	function META:Add(ply)
		self.players[ply:GetId()] = ply

		return self
	end

	function META:Remove(ply)
		self.players[ply:GetId()] = nil

		return self
	end

	function META:GetAll()
		return self.players
	end

	function message.PlayerFilter()
		return setmetatable({}, META)
	end
end

local function fix_tbl(tbl)
	local new = {} -- ?????

	for key, value in pairs(tbl) do
		table.insert(new, value)
	end

	return new
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

if CLIENT then
	function message.SendToServer(id, ...)
		local str = encode(id, ...)

		message.RawSendToServer(str)
	end

	function message.NetMsgReceiveFromServer(str)
		local id, args = decode(str)

		if message.Hooks[id] then
			message.Hooks[id](unpack(args))
		end
	end

	hook.Add("NetMsgReceiveFromServer", "message", message.NetMsgReceiveFromServer, print)
end

if SERVER then
	function message.SendToClient(id, ply, ...)
		local str = encode(id, ...)

		if typex(ply) == "player" then
			message.RawSendToClient(ply, str)
		elseif typex(ply) == "netmsg_player_filter" then
			for _, ply in pairs(ply:GetPlayers()) do
				message.RawSendToClient(ply, str)
			end
		else
			for key, ply in pairs(entities.GetAllPlayers()) do
				message.RawSendToClient(ply, str)
			end
		end
	end

	function message.NetMsgReceiveFromClient(ply, str)
		if not ply then return end

		local id, args = decode(str)

		if message.Hooks[id] then
			message.Hooks[id](ply, unpack(args))
		end
	end

	hook.Add("NetMsgReceiveFromClient", "message", message.NetMsgReceiveFromClient, print)
end