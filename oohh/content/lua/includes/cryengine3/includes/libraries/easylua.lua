easylua = {}
local s = easylua

local function compare(a, b)

	if not a or not b then return false end
	if a == b then return true end
	if a:find(b, nil, true) then return true end
	if a:lower() == b:lower() then return true end
	if a:lower():find(b:lower(), nil, true) then return true end

	return false
end

local function compareentity(ent, str)
	if ent.GetName and compare(ent:GetName(), str) then
		return true
	end

	if ent:GetModel() and compare(ent:GetModel(), str) then
		return true
	end

	return false
end

if CLIENT then
	function easylua.PrintOnServer(...)

	end
end

function easylua.Print(...)
	if CLIENT then
		easylua.PrintOnServer(...)
	end
	if SERVER then
		local args = {...}
		local str = ""

		printf("[EasyLua %s] ", me and me:GetNickname() or "Sv")

		for key, value in pairs(args) do
			str = str .. type(value) == "string" and value or luadata.ToString(value) or tostring(value)

			if key ~= #args then
				str = str .. ","
			end
		end

		print(str)
	end
end

function easylua.FindEntity(str)
	if not str then return end

	str = tostring(str)

	if str == "#this" and typex(this) == "entity" then
		return this
	end

	if str == "#me" and typex(me) == "player" then
		return me
	end

	if str == "#all" then
		return all
	end

	if str:sub(1,1) == "_" and tonumber(str:sub(2)) then
		str = str:sub(2)
	end

	if tonumber(str) then
		ply = entities.GetById(tonumber(str))
		if ply:IsValid() then
			return ply
		end
	end

	for key, ply in pairs(entities.GetAllPlayers()) do
		if compare(ply:GetNickname(), str) then
			return ply
		end
	end

	for key, ent in pairs(entities.GetAll()) do
		if compareentity(ent, str) then
			return ent
		end
	end

	do -- class

		local _str, idx = str:match("(.-)(%d+)")
		if idx then
			idx = tonumber(idx)
			str = _str
		else
			str = str
			idx = (me and me.easylua_iterator) or 0
		end

		local found = {}

		for key, ent in pairs(entities.GetAll()) do
			if compare(ent:GetClass(), str) then
				table.insert(found, ent)
			end
		end

		return found[math.clamp(idx%#found, 1, #found)] or NULL
	end
end

function easylua.CreateEntity(class)
	if class:lower():find("cgf") then
		local ent = entities.Create("BasicEntity")
		ent:Spawn()
		ent:BindToNetwork()
		ent:SetPos(there)
		ent:SetModel(class)
		return ent
	end

	local ent = entities.Create(class)
	ent:Spawn()
	ent:SetPos(there)
	
	return ent
end

function easylua.CopyToClipboard(var)
	me:SendLua([[window.SetClipboard("]]..tostring(var)..[[")]])
end

function easylua.Start(ply)
	ply = ply or CLIENT and entities.GetLocalPlayer() or NULL

	if not ply:IsValid() then return end

	local vars = {}
		local trace = ply:GetEyeTrace()

		vars.me = ply
		vars.phys = trace.HitPhysics
		vars.wep = ply:GetActiveWeapon()

		vars.there = trace.HitPos
		vars.here = trace.StartPos
		vars.dir = ply:GetEyeDir()

		vars.trace = trace
		vars.length = trace.Length

		vars.copy = s.CopyToClipboard
		vars.create = s.CreateEntity
		vars.prints = s.PrintOnServer

		if vars.phys then
			vars.this = vars.phys:GetEntity()
			--vars.model = vars.this:GetModel()
		end

		vars.E = s.FindEntity
		vars.last = ply.easylua_lastvars

		s.vars = vars
	for k,v in pairs(vars) do _G[k] = v end

	ply.easylua_lastvars = vars
	ply.easylua_iterator = (ply.easylua_iterator or 0) + 1
end

function easylua.End()
	if s.vars then
		for key, value in pairs(s.vars) do
			_G[key] = nil
		end
		me = entities.GetLocalPlayer()
	end
end

do -- env meta
	local META = {}

	local _G = _G
	local easylua = easylua
	local tonumber = tonumber

	function META:__index(key)
		local var = _G[key]

		if var then
			return var
		end

		if key ~= "CLIENT" or key ~= "SERVER" then -- uh oh
			var = easylua.FindEntity(key)
			if var:IsValid() then
				return var
			end
		end

		return nil
	end

	function META:__newindex(key, value)
		_G[key] = value
	end

	easylua.EnvMeta = setmetatable({}, META)
end

function easylua.RunLua(ply, code, env_name, print_error)
	local data =
	{
		error = false,
		args = {},
	}

	easylua.Start(ply)
		if s.vars then
			local header = ""

			for key, value in pairs(s.vars) do
				header = header .. string.format("local %s = %s ", key, key)
			end

			code = header .. "; " .. code
		end

		data.env_name = env_name or ply:IsValid() and ply:GetNickname() or "huh"

		local func, err = loadstring(code, env_name)

		if type(func) == "function" then
			setfenv(func, easylua.EnvMeta)

			local args = {pcall(func)}

			if args[1] == false then
				data.error = args[2]
			end

			table.remove(args, 1)
			data.args = args
		else
			data.error = err
		end
	easylua.End()

	if print_error and data.error then
		print(data.error)
	end

	return data
end

function easylua.StartWeapon(classname)

end

function easylua.EndWeapon(spawn, reinit)

end

function easylua.StartEntity(classname)

end

function easylua.EndEntity(spawn, reinit)

end

do -- all
	local META = {}

	function META:__index(key)
		return function(_, ...)
			local args = {}

			for _, ent in pairs(entities.GetAll()) do
				if (not self.func or self.func(ent)) then
					if type(ent[key]) == "function" or ent[key] == "table" and type(ent[key].__call) == "function" and getmetatable(ent[key]) then
						table.insert(args, {ent = ent, args = (ent[key](ent, ...))})
					else
						print("attempt to call field '" .. key .. "' on ".. tostring(ent) .." a " .. type(ent[key]) .. " value\n")
					end
				end
			end

			return args
		end
	end

	function META:__newindex(key, value)
		for _, ent in pairs(entities.GetAll()) do
			if not self.func or self.func(ent) then
				ent[key] = value
			end
		end
	end

	function CreateAllFuncton(func)
		return setmetatable({func = func}, META)
	end

	all = CreateAllFuncton(function(v) return typex(v) == "player" end)
end