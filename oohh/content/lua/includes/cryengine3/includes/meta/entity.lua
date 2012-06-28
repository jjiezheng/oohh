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
if SERVER then
	function META:CallOnClient(func, ...)
		message.SendToClient("e", nil, self, func, ...)
	end

	function META:SetModel(mdl)
		if SERVER then 
			self:CallOnClient("SetModelNoNetwork", mdl) 
		end
		self:SetModelNoNetwork(mdl)
	end
end

if CLIENT then
	message.Hook("e", function(self, func, ...)
		print(self, func, ...)
		if self[func] then
			self[func](self, ...)
		end
	end)
end

hook.Add("PostGameUpdate", "entity_update", function()
	for key, ent in pairs(entities.GetAll()) do
		if ent.OnUpdate then
			ent:OnUpdate()
		end
	end
end, print)