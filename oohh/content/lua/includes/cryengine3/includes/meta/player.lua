local META = util.FindMetaTable("player")

function META:GetEyeTrace()
	local startpos = self:GetEyePos()
	local phys = self:GetPhysics()

	return physics.RayWorldIntersection(startpos, startpos + (self:GetEyeDir() * 100000), ENT_ALL, RWI_STOP_AT_PIERCEABLE, phys)
end

function META:LoadOptions()
	self.LuaDataOptions = luadata.ReadFile("luadata_options/" .. self:ProfileId() .. ".txt")
end

function META:SaveOptions()
	luadata.WriteFile("luadata_options/" .. self:ProfileId() .. ".txt", self.LuaDataOptions)
end

function META:SetOption(key, value)
	if not self.LuaDataOptions then self:LoadOptions() end
	self.LuaDataOptions[key] = value
	self:SaveOptions()
end

function META:GetOption(key, def)
	if not self.LuaDataOptions then self:LoadOptions() end
	return self.LuaDataOptions[key] or def
end

if CLIENT then
	message.Hook("sendlua", function(code, env)
		local data = easylua.RunLua(me, code, env or "server")
		if data.error then
			print(data.error)
		end
	end)
end

if SERVER then
	function META:SendLua(code)
		message.SendToClient("sendlua", self, code, env)
	end
	
	function META:Cexec(str)
		self:SendLua("console.RunString('"..str.."')")
	end
end