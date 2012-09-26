console = console or {}

__OLDMSG = __OLDMSG or Msg
__OLDMSGN = __OLDMSGN or MsgN

local result = ""

function console.StartCapture()
	result = ""

	Msg = function(str)
		result = result .. str
	end

	MsgN = function(str)
		result = result .. str .. "\n"
	end

end

function console.EndCapture()
	Msg = __OLDMSG
	MsgN = __OLDMSGN
	return result
end

function console.Capture(func)
	console.StartCapture()
		func()
	return console.EndCapture()
end

function console.Exec(cfg)
	check(cfg, "string")

	local content = file.Read("cfg/"  .. cfg .. ".cfg", true)

	if content then
		console.RunString(content)
		return true
	end

	return false
end

do -- commands
	console.Prefix = "o "
	
	console.AddedCommands = {}

	function console.AddCommand(cmd, callback, server)
		cmd = cmd:lower()
		
		if console.AddInternalConsoleCommand then
			console.AddInternalConsoleCommand(cmd)
		end
		
		console.AddedCommands[cmd] = {callback = callback, server = server}
	end

	function console.RemoveCommand(cmd, callback)
		cmd = cmd:lower()
		
		if console.RemoveInternalConsoleCommand and console.AddedCommands[cmd] then
			console.RemoveInternalConsoleCommand(cmd)
		end
		
		console.AddedCommands[cmd] = nil
	end

	function console.GetCommands()
		return console.AddedCommands
	end
	
	function console.RunCommand(cmd, ...)
		console.CallCommand(cmd, table.concat({...}, " "), nil, ...)
	end

	local function call(data, ply, line, ...)
		local status, message = pcall(data.callback, ply, line, ...)
		if not status then
			print(message)
		end
	end

	function console.CallCommand(cmd, line, ply, ...)
		cmd = cmd:lower()

		local data = console.AddedCommands[cmd]

		if data then
			ply = ply or entities.GetLocalPlayer()

			if CLIENT then
				if data.server == true or data.server == "server" then
					message.SendToServer("cmd", cmd, ...)
				elseif data.server == "shared" then
					call(data, ply, line, ...)
					message.SendToServer("cmd", cmd, ...)
				elseif not data.server or data.server == "client" then
					call(data, ply, line, ...)
				end
			end

			if SERVER then
				call(data, ply, line, ...)
			end
		else
			printf("the command %q does not exist", cmd)
		end
	end

	if SERVER then
		message.Hook("cmd", function(ply, cmd, ...)
			console.CallCommand(cmd, table.concat({...}, " "), ply, ...)
		end)
	end

	-- thanks lexi!
	-- http://www.facepunch.com/showthread.php?t=827179

	function console.ParseCommandArgs(line)
		local quote = line:sub(1,1) ~= '"'
		local ret = {}
		for chunk in string.gmatch(line, '[^"]+') do
			quote = not quote
			if quote then
				table.insert(ret,chunk)
			else
				for chunk in string.gmatch(chunk, "%S+") do -- changed %w to %S to allow all characters except space
					table.insert(ret, chunk)
				end
			end
		end

		return ret
	end

	function console.InternalCommandHook(line)
	
		local prefix = line:sub(0, #console.Prefix) == console.Prefix and console.Prefix or ""
		local cmd = line:match(prefix.."(.-) ") or line:match(prefix.."(.+)") or ""
		local arg_line = line:match(prefix..".- (.+)") or ""		

		cmd = cmd:lower()
		
		if not console.AddedCommands[cmd] then
			cmd, arg_line = line:match("(.-)%s-(.+)")
			
			if not cmd or cmd == "" then
				cmd = arg_line
				arg_line = ""
			end
			
			cmd = cmd:lower()
		end

		if console.AddedCommands[cmd] then
			console.CallCommand(cmd, arg_line, nil, unpack(console.ParseCommandArgs(arg_line)))
		end
	end

	hook.Add("LuaCommand", "concommand", console.InternalCommandHook, print)

	--[[local cvar = console.CreateVariable("con_filter", "string", "normal")

	function console.IsLineAllowed(line)
		if console.GetVariableString("con_filter") == "normal" then
			for _, value in pairs(blacklist) do
				if line:FindSimple(value) then
					return false
				end
			end
		elseif console.GetVariableString("con_filter") == "pattern" then
			for _, value in pairs(blacklist) do
				if line:find(value) then
					return false
				end
			end
		end

		return true
	end


	hook.Add("ConsolePrint", "console_filter", function(_, line)
		if not console.IsLineAllowed(line) then
			return false
		else
			hook.Call("ConsoleOutput", GAMEMODE, line)
		end
	end)]]
end

do -- console vars
	console.cvar_file_name = "cvars.txt"
	console.vars = nil
	
	function console.ReloadVariables()
		console.vars = luadata.ReadFile(console.cvar_file_name)
	end

	function console.CreateVariable(name, def, callback)
		if not console.vars then
			console.ReloadVariables()
		end

		console.vars[name] = console.vars[name] or def

		local func = function(ply, line, value)
			if not value then
				printf("%s = %s", name, luadata.ToString(console.vars[name]))
			else
				console.SetVariable(name, value)
				if callback then
					callback(value)
				end
			end

		end

		console.AddCommand(name, func)
	end

	function console.GetVariable(var, def)
		return console.vars[var] or def
	end

	function console.SetVariable(name, value)
		console.vars[name] = value
		luadata.SetKeyValueInFile(console.cvar_file_name, name, value)
	end
	
	hook.Add("MenuInitialized", "cvars", function()
		console.ReloadVariables()
	end, 10)
end

do -- filtering

	local blacklist = {}

	function console.AddToBlackList(str)
		check(str, "string")

		return table.insert(blacklist, str)
	end

	function console.RemoveFromBlackList(id)
		check(id, "number")

		blacklist[id] = nil
	end

	function console.GetBlackList()
		return blacklist
	end

	function console.ClearBlackList()
		blacklist = {}
	end
	
	console.CreateVariable("con_filter", "normal")

	function console.IsLineAllowed(line)
		local mode = console.GetVariable("con_filter")
		
		if mode == "normal" then
			for _, value in pairs(blacklist) do
				if line:FindSimple(value) then
					return false
				end
			end
		elseif mode == "pattern" then
			for _, value in pairs(blacklist) do
				if line:find(value) then
					return false
				end
			end
		end

		return true
	end

	local in_it=false
	hook.Add("ConsolePrint", "console_filter", function(line)
		if in_it then return end 
		in_it = true
		if not console.IsLineAllowed(line) then
			in_it=false
			return false
		else
			hook.Call("ConsoleOutput", GAMEMODE, line)
		end
		in_it=false
	end)

end

do -- funsong
	cmd = setmetatable(
		{}, 
		{
			__index = function(self, key)				
				key = key:lower()
				
				-- lua commands
				if console.AddedCommands[key] then
					return function(...)
						console.RunCommand(key, ...)
					end
				end
				
				-- lua cvars
				local tbl = console.vars
				if tbl[key] then
					return tbl[var]
				end
				
				-- engine cvars
				local val = console.GetCVarString(key)
				if val then
					return val
				end
			end,
			
			__newindex = function(self, key, val)
				key = key:lower()
			
				-- lua cvars
				local tbl = console.vars
				if tbl[key] then
					console.SetVariable(key, val)
				end
				
				-- engine cvars (same as commands really)
				local val = console.GetCVarString(key)
				if val then
					console.SetCVarValue(key, val)
				end
			end
		}
	)
end