local time = 0

local function getpitch(offset)
	return 440 * 2 ^ ((offset - 48) / 12)
end

local function saw(offset)
    return (time * getpitch(offset))%1
end

local function pwm(offset, w)
    w = w or 0.5

    return (time * getpitch(offset))%1 > w and 1 or 0
end

local function sin(offset)
    return math.sin(time * math.pi * 2 * getpitch(offset))
end

local v
local function tri(offset)
    v = (time * getpitch(offset))%1

    return v > 0.5 and (-v + 1) or v
end

local function super(func, offset, detune, amount)
    local v = 0
    for i = -amount, amount do
        v = v + func(offset + (i / detune))
    end

    return v
end

local voldata = Vec3(1,1,1) -- V, L, R
local should_play

local function calcsource(eye, rgt, src, dist, fwd)
    local vol = math.clamp(-((eye - src):GetLength() / dist) + 1, 0, 1)
    local dot = rgt:Dot((src - eye):Normalize())

    voldata.x = vol * 2

    voldata.y = math.clamp(-dot, 0, 1) + 0.5
    voldata.z = math.clamp(dot, 0, 1) + 0.5

	should_play = vol ~= 0
end

local source = Vec3(1465, 1032, 101)
local function GetVolumeData()
	local ply = entities.GetLocalPlayer()
	if ply:IsValid() then
		local ang = ply:GetViewRotation():GetAng3()
		return calcsource(ply:GetEyePos(), ang:GetRight(), source, 10, ang:GetForward())
	end
end

local fft = 0

local function waveform()
    local t = (time*8)
    local w = 0 --pwm(30, math.tan(t))

    if t%1 > 0.9 and t%1 < 0.95 then
        w = w + (math.random() * math.sin(t))
    end

    if t%8 < 0.5 then
        w = w + math.random()
    end

    if (t%4 > 2 and t%4 < 2.6) then
        w = w + pwm(12)
    end

    if (t%4 > 2.6 and t%4 < 3) then
        w = w + pwm(0) 
    end

	fft = w
	
	if MULTIPLAYER and should_play then
		w = w * voldata.x

		return w * voldata.y, w * voldata.z
	else
		return w, w
	end
end

rawaudio.Open(0.1)

hook.Add("PostGameUpdate", 1, function()
	GetVolumeData()
end)

hook.Add("AudioSample", 1, function(pos)
	time = pos
	return waveform()
end)