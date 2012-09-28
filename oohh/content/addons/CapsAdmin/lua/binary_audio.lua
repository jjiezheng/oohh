local voldata = Vec3(1,1,1) -- V, L, R
local should_play

local function calcsource(eye, rgt, src, dist, fwd)
    local vol = math.clamp(-((eye - src):GetLength() / dist) + 1, 0, 1)
    local dot = rgt:Dot((src - eye):Normalize())

    voldata.x = vol ^ 10

    voldata.y = math.clamp(-dot, 0, 1) + 0.5
    voldata.z = math.clamp(dot, 0, 1) + 0.5

	should_play = vol ~= 0
end

local function UpdateVolumeData(pos)
	local ply = entities.GetLocalPlayer()
	if ply:IsValid() then
		local ang = ply:GetViewRotation():GetAng3()
		calcsource(ply:GetEyePos(), ang:GetRight(), pos, 100, ang:GetForward())
	end
end

function PlayBinaryFile(path, rate, pos)
	pos = pos or Vec3(1273, 1269, 22)
	rate = rate or 10000

	local T = 0
	local W = 0
	local POS = 0
		
	local data = file.Read(path, "b")
	
	print(#data)
		
	binary_ent = binary_ent or NULL
	
		if binary_ent:IsValid() then
			binary_ent:Remove()
		end
		 
		local ent = entities.Create("BasicEntity")
		ent:SetPos(pos)
		ent:Spawn()
				
		local tex = Texture(1, 2048)
		local img = tex:GetPixelTable(true)
		for i = 0, tex:GetLength() do
			local byte = data:getbyte(i) + 1
			img[i].r = byte
			img[i].g = byte
			img[i].b = byte
			img[i].a = 255
		end
		tex:SetPixelTable(img)
		
		local size = 128
				
		ent.OnUpdate = function(self)
			UpdateVolumeData(pos)
			
			math.randomseed(W)
			local x = math.random()
			math.randomseed(W+1)
			local y = math.random()
			math.randomseed(W+2)
			local z = math.random()
			
			self:SetPos(pos + Vec3(x,y,z))
			self:SetScale(Vec3(1,1,1)*W*4) 
			
			local cam = engine3d.GetCurrentCamera()
			cam:SetMatrix(ent:GetMatrix()) 
			render.MakeMatrix(Vec3(), Vec3(), Vec3(), ent:GetMatrix())
--			render.PushMatrix()
			local pos = pos:Copy()
			pos.y = pos.y + size
			render.DrawImage(pos, 10, -size, tex, Color(1,1,1,1), false)
			pos.y = pos.y - POS / #data * size
			render.DrawImage(pos, size, 0.1, tex, Color(W,size*W,-W,1), false)
	--		render.PopMatrix()
		end
	
	binary_ent = ent
	
	rawaudio.Open(0.1)

	hook.Add("AudioSample", "binary_audio", function(pos)
		if should_play then
			T = pos
			POS = math.ceil(T*rate%#data)
			W = 0
			W = W + ((data:getbyte(POS) - 128) / 128)
			
			if MULTIPLAYER and should_play then
				W = W * voldata.x

				return W * voldata.y, W * voldata.z
			else
				return W, W
			end
		end
	end)
end

PlayBinaryFile("../bin32/editor.exe")
util.MonitorFileInclude()
