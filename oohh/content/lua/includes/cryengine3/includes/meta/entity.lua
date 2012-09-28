local META = util.FindMetaTable("entity")

function META:SetClassName(class)
	self.ClassName = class
end

function META:FindClosest(check)
	local closest, dist = {dist = math.huge}
	local pos = self:GetPos()
	for key, ent in pairs(entities.GetAll()) do
		if ent:GetPos() ~=  pos and check(ent) then
			dist = (pos - ent:GetPos()):Length()
			if closest.dist > dist then
				closest.dist = dist
				closest.ent = ent
			end
		end
	end

	return closest.ent or NULL
end

function META:GetRight()
	return self:GetAngles():GetRight()
end

function META:GetUp()
	return self:GetAngles():GetRight()
end

function META:GetForward()
	return self:GetAngles():GetRight()
end


entities.CachedEntities = {}

hook.Add("PostGameUpdate", "entity_update", function()
	for key, ent in pairs(entities.GetAll()) do
		local id = ent:GetId()
		
		if not entities.CachedEntities[id] then
			entities.CachedEntities[id] = ent
			hook.Call("EntitySpawned", ent)
			
			if not GAME_INIT and ent == entities.GetLocalPlayer() then
				hook.Call("MenuInitialized")
				hook.Call("GameInitialized")
			end
			
			if ent.Initialize then
				ent:Initialize()
			end
		end
		
		if ent.OnUpdate then
			ent:OnUpdate()
		end
	end
end)

if CLIENT then
	local buffer = {}
	
	message.Hook("e", function(id, func, ...)
		local ent = entities.GetById(id)
		if ent:IsValid() then
			if ent[func] then
				ent[func](ent, ...)
			end	
		else
			buffer[id] = buffer[id] or {}
			buffer[id][func] = {...}
		end
	end)
	
	hook.Add("EntitySpawned", "call_on_client", function(ent)
		local id = ent:GetId()
		local data = buffer[id]
		
		if data then
			local data = buffer[id]
			for func, args in pairs(data) do
				print(func, unpack(args))
				ent[func](ent, unpack(args))
				data[func] = nil
			end
			
		end
	end)
	
	hook.Add("EntityRemoved", "call_on_client", function(ent)
		buffer[ent:GetId()] = nil
		entities.CachedEntities[ent:GetId()] = nil
	end)
	
	function META:PhysicalizeEx(...)
		local phys = self:Physicalize(...)
		phys:SetNetworkAuthority(true)
		return phys
	end
end

if SERVER then
	function META:CallOnClient(func, ...)
		message.SendToClient("e", nil, self:GetId(), func, ...)
	end

	function META:SetModel(mdl)
		if SERVER then 
			self:CallOnClient("SetModelNoNetwork", mdl) 
		end
		self:SetModelNoNetwork(mdl)
	end
	
	function META:PhysicalizeEx(...)
		if SERVER then
			self:CallOnClient("PhysicalizeEx", ...)
		end
		local phys = self:Physicalize(...)
		phys:SetNetworkAuthority(true)
		return phys
	end
end

local utils = 
[[
	_G.Vec3 = function(x,y,z) return {x=x,y=y,z=z} end
	_G.Ang3 = function(x,y,z) return {x=x,y=y,z=z} end
	_G.Color = function(x,y,z,a) return {r=x,g=y,b=z,a=a} end
	typex = type
]] 
.. 
file.Read("../lua/includes/standard/libraries/luadata.lua")

local lua = "System.GetEntity(%i):%s(unpack(luadata.Decode(%q)))"

function META:CallCryScript(key, ...)
	if utils then
		system.RunCryScriptString(utils)
		utils = nil
	end
	system.RunCryScriptString(lua:format(self:GetId(), key, luadata.Encode({...})))
end


local lua = "System.GetEntity(%i).Properties.%s = %s"

function META:SetKeyValue(key, val)
	if utils then
		system.RunCryScriptString(utils)
		utils = nil
	end
	system.RunCryScriptString(lua:format(self:GetId(), key, luadata.ToString(val)))
	self:CallCryScript("OnPropertyChange")
end

local lua = "Log(tostring(System.GetEntity(%i).Properties.%s))"

function META:GetKeyValue(key)
	if utils then
		system.RunCryScriptString(utils)
		utils = nil
	end
	system.RunCryScriptString(lua:format(self:GetId(), key, luadata.ToString(val)))
end

local lua = "Log(luadata.Encode(System.GetEntity(%i).Properties))"
local last_line = ""

function META:ASDF()
	if utils then
		system.RunCryScriptString(utils)
		utils = nil
	end
	console.RunString("log_verbosity 5", true)
	system.RunCryScriptString(lua:format(self:GetId()))
	if last_line:find("Lua") then
		local data = luadata.Decode(last_line:match("<Lua> (.+)")) 
		print(data)
	end
	console.RunString("log_verbosity 0", true)
	
	if data then
		return data
	end
end

hook.Add("ConsolePrint",1,function(line) last_line = line end)

util.MonitorFileInclude()