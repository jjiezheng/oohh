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

hook.Add("PostGameUpdate", "entity_update", function()
	for key, ent in pairs(entities.GetAll()) do
		if not getmetatable(ent).Type then
			_R.ptrtable = {}
			print(key)
			goto asdf
		end
		--if type(ent) then print("SADASDASDASD", ent, ent.Type) end
		if ent.OnUpdate then
			ent:OnUpdate()
		end
		
		::asdf::
	end
end, print)

if CLIENT then
	local buffer = {}
	
	message.Hook("e", function(id, func, ...)
		local ent = entities.GetById(id)
		if ent:IsValid() then
			if self[func] then
				print(func, ...)
				self[func](self, ...)
			end	
		else
			buffer[id] = buffer[id] or {}
			buffer[id][func] = {...}
		end
	end)
	
	hook.Add("EntitySpawned", "call_on_client", function(ent)
		timer.Simple(0.5, function()
			if ent:IsValid() then
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
			end
		end)
	end)
	
	hook.Add("EntityRemoved", "call_on_client", function(ent)
		buffer[ent:GetId()] = nil
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
