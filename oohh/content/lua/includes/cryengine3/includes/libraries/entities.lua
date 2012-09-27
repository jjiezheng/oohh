entities = entities or {}

function Entity(var, ...)

	if tonumber(var) then
		return entities.GetById(tonumber(var))
	elseif type(var) == "string" then
		entities.Create(var, ...)
	end
	
	return NULL
end

function entities.GetAllPlayers()
	return entities.FindByClass("Player", true)
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

function entities.FindByClass(name, exact)
	local tbl = {}

	if not exact then
		name = name:lower()
	end

	for _, ent in pairs(entities.GetAll()) do
		if exact and ent:GetClass() == name or not exact and ent:GetClass():lower():find(name) then
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
 