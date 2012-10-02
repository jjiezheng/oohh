if threedplayer and threedplayer:IsValid() then threedplayer:Stop() threedplayer:Remove() end

threedplayer = Channel(BASS_MUSIC, Path((("sounds/UT1999 - Foregone Destruction.it"):gsub("!/../", ""))), 0, BASS_MUSIC_3D)

print(bass.GetLastError())
threedplayer:Play()

bars = bars or {}

for k,v in pairs(bars) do
	if v:IsValid() then
		v:Remove()
	end 
end

bars = {}

local rad = 2
local pos = Vec3(986.31372070313, 761.19567871094, 21.717937469482)
local n = 1024
 
local inc = math.pi * (3.0 - math.sqrt(5))
local off = 2/n

for i = 0, n do
	local y = i * off - 1 + (off/2)
	local r = math.sqrt(1 - y*y)
	local phi = i * inc

	local e = entities.Create("BasicEntity")
	e:SetPos(pos + Vec3(
		math.cos(phi)*r,
		y,
		math.sin(phi)*r
	) * rad)
	e:SetAngles((e:GetPos() - pos):GetAng3())
	e:Spawn()
	e:SetModelNoNetwork("objects/default/sphere.cgf")
	e:SetMaterial(materials.CreateFromFile("Objects/natural/water/Waterfall/waterfall.mtl"))
	e:EnablePhysics(false)		
	e.i = i
	bars[i] = e
end

print("Go")


print(i)

hook.Add("PostGameUpdate", "3dpos", function() 
	local cam = engine3d.GetCurrentCamera()
	local ply = entities.GetLocalPlayer()
	local ang = cam:GetAngles()
	
	bass.SetPosition(cam:GetPos()*20, ply:GetPhysics():GetVelocity(), ang:GetForward(), -ang:GetRight())
	threedplayer:set3dposition(pos*20, Vec3(0,0,1), Vec3(0,0,0))
    
    local fft = threedplayer:GetFFT()
    
    for k,v in pairs(bars) do
        local val = ((fft[v.i] or 0) ^ 0.7) * 100
        v:SetScale(Vec3(1, 1, val))
    end
end)

util.MonitorFileInclude()