entities = entities or {}

function entities.GetAllPlayers()
	return entities.GetAllByClass("Player")
end

function entities.GetAllPhysics()
	local new = {}
	for _, ent in pairs(entities.GetAll()) do
		local phys = ent:GetPhysics()
		if phys:IsValid() then
			table.insert(new, phys)
		end
	end
	return new
end

function entities.FindByClass(name)
	local tbl = {}

	name = name:lower()

	for _, ent in pairs(entities.GetAll()) do
		if ent:GetClass():lower():find(name) then
			table.insert(tbl, ent)
		end
	end

	return tbl
end

function entities.FindClosest(pos, filter, ignore)
	local closest, dist = {dist = math.huge}

	for key, ent in pairs(filter and entities.FindByClass(filter) or entities.GetAll()) do
		if ent ~= ignore then
			dist = (ent:GetPos() - pos):GetLength()
			if dist < closest.dist then
				closest.dist = dist
				closest.ent = ent
			end
		end
	end

	return closest.ent
end

function entities.FindInSphere(pos, rad)
	local tbl = {}
	for key, ent in pairs(entities.GetAll()) do
		if (ent:GetPos() - pos):GetLength() < rad then
			table.insert(tbl, ent)
		end
	end
	return tbl
end
 