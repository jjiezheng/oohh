fungus_world_health = {}

local ENT = {}
ENT.IsFungus = true

local function CreateEntity(pos)
	local ent = entities.Create("animobject")
	ent:SetModel("objects/default/primitive_sphere.cgf")
	ent:SetPos(pos)
	ent:Spawn()

	local phys = ent:Physicialize(PE_RIGID)

	return ent
end

ENT.Model = "objects/default/primitive_sphere.cgf"
ENT.Radius =  3
ENT.MaxSize = 50

function ENT:Initialize()
	self.FungusChildren = {}

	self:SetModel(self.Model)
	print(self:GetModel())

	self.size = self.MaxSize
end

function ENT:RemoveChildren()
	for key, ent in ipairs(self.FungusChildren) do
		SafeRemoveEntity(ent)
	end
end

function ENT:Think()
	self.size = self.size - 0.1

	self:SetScale(Vec3() + (self.size / 40))

	if self.size < 0.1 then
		self:Remove()
	end

	--if math.random() > 0.5 then
		self:Spread()
	--end
end

function ENT:GetHashFromPos(pos)
	local x = math.round(pos.x/16) * 16
	local y = math.round(pos.y/16) * 16
	local z = math.round(pos.z/16) * 16

	local hash = x+y+z

	return pos.x + pos.y + pos.z
end

function ENT:EatPos(pos)
	local data = fungus_world_health[self:GetHashFromPos(pos)]

	if not data then
		data = {}
		fungus_world_health[self:GetHashFromPos(pos)] = data
	end

	local amt = math.randomf(10, 30)

	data.health = (data.health or 100) - amt

	if data.health > 0 then
		self.size = self.size + (amt / 1000)
	end
end

function ENT:Shrink(size)
	self.size = (size or self.size) * 0.9
	self:SetScale(Vec3()+self.size)
	--local val = math.Clamp(math.round((self.size / self.MaxSize) * 255), 1, 255)
	--self:SetColor((val*3)%255, val, (val*2)%255, 255)
end

function ENT:GetFungusInSphere(origin, siz)
	siz = siz or self.size
	local tbl = {}

	for key, ent in pairs(entities.GetAll()) do
		if not ent.IsFungus then
			if #(ent:GetPos() - origin) < self.size then
				table.insert(tbl, ent)
			end
		end
	end

	return tbl
end

function ENT:CreateFungus(pos, ang, hit_ent)
	if self.size > 0.2 then --and #entities.FindByClass("fungus") < 500 then
		hit_ent = hit_ent or NULL

		local ent = CreateEntity(pos)

			ent:SetTable(table.copy(ENT))
			ent:Shrink(self.size)
			ent:Initialize()

		self:EatPos(pos)

		table.insert(self.FungusChildren, ent)

		return ent
	end
end

function ENT:Spread()
	local data = physics.TraceDir(self:GetPos(), Vec3Rand() * self.size, self)

	if not data.Hit then
		local data = physics.TraceDir(data.HitPos, Vec3Rand() * self.size * 2, self)

		if data.Hit and #self:GetFungusInSphere(data.HitPos) == 0 then
			return self:CreateFungus(data.HitPos, data.HitNormal:GetAng3(), data.HitPhysics)
		end
	end
end

function CreateFungus(pos)
	local ent = CreateEntity(pos or there)

	ent:SetTable(table.copy(ENT))
	ent:Initialize()

	print(ent)

	return ent
end

hook.Add("PostGameUpdate",1,function()
	for key, ent in pairs(entities.GetAll()) do
		if ent.IsFungus then
			ent:Think()
		end
	end
end)