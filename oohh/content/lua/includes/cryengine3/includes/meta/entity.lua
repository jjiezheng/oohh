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
		if ent.OnUpdate then
			ent:OnUpdate()
		end
	end
end, print)

if CLIENT then
	local buffer = {}
	
	message.Hook("e", function(id, func, ...)
		local ent = entities.GetById(id)
		if ent:IsValid() then
			if self[func] then
				self[func](self, ...)
			end	
		else
			print("model set on " .. id)
			buffer[id] = {func = func, args = {...}}
		end
	end)
	
	hook.Add("EntitySpawned", "call_on_client", function(ent)
		timer.Simple(0.5, function()
			printf("entity %s with id %s spawned", ent:GetClass(), ent:GetId())
			local id = ent:GetId()
			local data = buffer[id]
			
			if data then
				ent[data.func](ent, unpack(data.args))
				buffer[id] = nil
			end
		end)
	end)
	
	hook.Add("EntityRemoved", "call_on_client", function(ent)
		buffer[ent:GetId()] = nil
	end)
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
end
