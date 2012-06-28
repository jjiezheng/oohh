local function Vertex(pos, norm, i)
	return {pos, norm, i}
end

local function SwapValues(a, b, ind)
	local val = a[ind]
	a[ind] = b[ind]
	b[ind] = val
end

local function SortVectors(low, high)
	if low.x > high.x then SwapValues(low, high, "x") end
	if low.y > high.y then SwapValues(low, high, "y") end
	if low.z > high.z then SwapValues(low, high, "z") end
end

local DIR_XP = 1 -- X Positive
local DIR_XN = 2 -- X Negative
local DIR_YP = 4 -- Y Positive
local DIR_YN = 8 -- Y Negative
local DIR_ZP = 16-- Z Positive
local DIR_ZN = 32-- Z Negative

local function DirectionToVector(dir)
	if dir == DIR_XP then
		return Vec3(1, 0, 0)
	elseif dir == DIR_XN then
		return Vec3(-1, 0, 0)
	elseif dir == DIR_YP then
		return Vec3(0, 1, 0)
	elseif dir == DIR_YN then
		return Vec3(0, -1, 0)
	elseif dir == DIR_ZP then
		return Vec3(0, 0, 1)
	elseif dir == DIR_ZN then
		return Vec3(0, 0, -1)
	else
		return Vec3(0, 0, 0)
	end
end

-- Todo: add text coords, not looking forward to it.

-- param tri is for using triangle faces or square faces. it
--   will depend on if it's even possible to use square faces
--   with cryengine meshes.
--   atm I've left it unimplemented

-- at this point this function only generates faces based on
-- axis directions. I'm not good with vector math so making
-- 360 degree rotational face planes is not my thing.
local function SquareMesh(low, hig, dir, tri)
	SortVectors(low, hig)
	
	-- The pattern here is
	-- 0 0 - Bottom Left
	-- 1 0 - Bottom Right
	-- 1 1 - Top Right
	-- 
	-- 1 1 - Top Right
	-- 0 1 - Top Left
	-- 0 0 - Bottom Left
	-- 0 for low, 1 for high
	-- one value always stays the same
	
	if dir == DIR_XP or dir == DIR_XN then -- X stays the same
		local x = 0
		if dir == DIR_XP then
			x = hig.x
		else
			x = low.x
		end
		return {
			Vertex(Vec3(x, low.y, low.z), DirectionToVector(dir)),
			Vertex(Vec3(x, hig.y, low.z), DirectionToVector(dir)),
			Vertex(Vec3(x, hig.y, hig.z), DirectionToVector(dir)),
			
			Vertex(Vec3(x, hig.y, hig.z), DirectionToVector(dir)),
			Vertex(Vec3(x, low.y, hig.z), DirectionToVector(dir)),
			Vertex(Vec3(x, low.y, low.z), DirectionToVector(dir)),
		}
	end
	if dir == DIR_YP or dir == DIR_YN then -- Y stays the same
		local y = 0
		if dir == DIR_YP then
			y = hig.y
		else
			y = low.y
		end
		return {
			Vertex(Vec3(low.x, y, low.z), DirectionToVector(dir)),
			Vertex(Vec3(hig.x, y, low.z), DirectionToVector(dir)),
			Vertex(Vec3(hig.x, y, hig.z), DirectionToVector(dir)),
			
			Vertex(Vec3(hig.x, y, hig.z), DirectionToVector(dir)),
			Vertex(Vec3(low.x, y, hig.z), DirectionToVector(dir)),
			Vertex(Vec3(low.x, y, low.z), DirectionToVector(dir)),
		}
	end
	if dir == DIR_ZP or dir == DIR_ZN then -- Z stays the same
		local z = 0
		if dir == DIR_ZP then
			z = hig.z
		else
			z = low.z
		end
		return {
			Vertex(Vec3(low.x, low.y, z), DirectionToVector(dir)),
			Vertex(Vec3(hig.x, low.y, z), DirectionToVector(dir)),
			Vertex(Vec3(hig.x, hig.y, z), DirectionToVector(dir)),
			
			Vertex(Vec3(hig.x, hig.y, z), DirectionToVector(dir)),
			Vertex(Vec3(low.x, hig.y, z), DirectionToVector(dir)),
			Vertex(Vec3(low.x, low.y, z), DirectionToVector(dir)),
		}
	end
end

local function MergeMeshes(mesh1, mesh2)
	for i=1, #mesh2 do
		mesh1[#mesh1+1] = mesh2[i]
	end
end

local function BoxMesh(low, hig)
	SortVectors(low, hig)
	
	local mesh = {}
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_XP, true))
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_XN, true))
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_YP, true))
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_YN, true))
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_ZP, true))
	MergeMeshes(mesh, SquareMesh(low, hig, DIR_ZN, true))
	
	return mesh
end

local center = here + Vec3(0, 0, 1)
local size = 1
local high = Vec3(0.5, 0.5, 0.5)*size
local low = Vec3(0.5, 0.5, 0.5)*size

local mesh = SquareMesh(low, high, DIR_XP, true)

TABLE_MESH = TABLE_MESH or assert(this:GetMeshTable())
print(this, #TABLE_MESH)
assert(this:SetMeshTable(mesh))