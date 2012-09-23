nvars = {}

nvars.current = {}
nvars.current.g = {}

function nvars.Set(key, value, env, ply)
	env = env or "g"

	-- userdata!!!!

	local hack
	if getmetatable(env) and getmetatable(env).GetUniqueID then
		hack = env:GetUniqueID()
	end
	
	nvars.current[hack or env] = nvars.current[hack or env] or {}
	nvars.current[hack or env][key] = value

	if SERVER then
		message.SendToClient("nv", ply, env, key, value)
	end
end

function nvars.Get(key, def, env)
	env = env or "g"

	local hack
	if getmetatable(env) and getmetatable(env).GetUniqueID then
		hack = env:GetUniqueID()
	end

	return nvars.current[hack or env] and nvars.current[hack or env][key] or def
end

function nvars.Initialize()
	console.AddCommand("fullupdate", function(ply, line, ...)
		for env, vars in pairs(nvars.current) do
			for key, value in pairs(vars) do
				nvars.Set(key, value, env, ply)
			end
		end
	end, true)

	if CLIENT then
		message.Hook("nv", function(env, key, value)
			nvars.Set(key, value, env)
		end)
	end

	for key, ent in pairs(entities.GetAll()) do
		nvars.AttachObject(ent)
	end

	hook.Add("EntitySpawned", "nvars", function(ent)
		timer.Simple(0.5, function()
			if ent:IsValid() then
				nvars.AttachObject(ent)
			end
		end)
	end)
end

function nvars.FullUpdate()
	console.RunCommand("fullupdate")
end

do
	local META = {}

	META.Env = "g"

	function META:__index(key)
		return nvars.Get(key, nil, self.Env)
	end

	function META:__newindex(key, value)
		nvars.Set(key, value, self.Env)
	end

	nvars.ObjectMeta = META
end

function nvars.CreateObject(env)
	return setmetatable({Env = env}, nvars.ObjectMeta)
end

function nvars.AttachObject(ent)
	ent.nv = nvars.CreateObject(ent)
end

hook.Add("LocalPlayerEntered", "nvars", function()
	nvars.Initialize()
	nvars.FullUpdate()
end)

local META = util.FindMetaTable("player")

META.nv = {}