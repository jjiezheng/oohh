local trace = me:GetEyeTrace()
local ent = trace.HitEntity

if os.getenv("USERNAME") ==  "capsadmin" then
	TableTest({
			vertex = Vec3(1,1,1),
			normal = -Vec3(1,1,1),
			indice = 123,
	})
	return
end

local mesh = ent:GetMeshData(0)

--table.print(mesh)

for key, data in pairs(mesh) do
	mesh[key].vertex = Vec3(math.random(), math.random(), math.random())
	mesh[key].indices = math.random(#mesh) - 1
end

--[[for key, data in pairs(mesh) do
	printf("[%s]", key)
	printf("	vertex = %s", tostring(data.vertex))
	printf("	normal = %s", tostring(data.normal))
	printf("	indicie = %s", tostring(data.indicie))
end]]

print(ent:GetClass(), #mesh)

print(ent:SetMeshData(mesh))
