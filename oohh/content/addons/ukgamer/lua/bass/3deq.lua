local pos = Vec3(1140.5548095703, 1180.0670166016, 31.5)
local n = 50

local spacing = 1.25

threedeq = threedeq or {}

threedeq.player = util.RemoveOldObject(Channel(BASS_URL, "http://pub2.di.fm/di_techhouse", 0, BASS_STREAM_STATUS))
threedeq.player:Play()
--threedeq.player:SetVolume(0)

threedeq.bars = threedeq.bars or {}

for k, v in pairs(threedeq.bars) do
    if v:IsValid() then
        v:Remove()
    end
end

for i = 1, n do
    threedeq.bars[i] = entities.Create("BasicEntity")
    threedeq.bars[i]:SetPos(pos + Vec3(math.cos(math.rad(i * 7.2)) * spacing, math.sin(math.rad(i * 7.2)) * spacing, 0))
    threedeq.bars[i]:SetAngles(Ang3(0, 0, -math.atan2(math.cos(math.rad(i * 7.2)) * spacing, math.sin(math.rad(i * 7.2)) * spacing)))
    threedeq.bars[i]:Spawn()
    threedeq.bars[i]:SetModel("objects/default/box.cgf")
    threedeq.bars[i]:SetMaterial(materials.CreateFromFile("materials/presets/surfacetypes/white.mtl"))
    threedeq.bars[i]:EnablePhysics(false)
end

if threedeq.light and threedeq.light:IsValid() then threedeq.light:Remove() end
threedeq.light = entities.Create("light")
threedeq.light:SetPos(pos + Vec3(0, 0, 1))
threedeq.light:Spawn()
threedeq.light:SetKeyValue("Options.CastShadows", 2)

hook.Add("PostGameUpdate", "3deq", function()
    local fft = threedeq.player:GetFFT()
    
    local val = (fft[3] ^ 0.7) * 200
    local r, g, b = HSVToColor(math.clamp(-val + 100, 0, 100), 1, 1):Unpack()
    threedeq.light:SetKeyValue("Color.clrDiffuse", Vec3(r, g, b) * val / 100)
    
    for i = 1, n do
        local val = (fft[i] ^ 0.7) * 5
        threedeq.bars[i]:SetScale(Vec3(0.0625, 0.0625, val))
        
        --local r, g, b = HSVToColor(math.clamp(-val + 100, 0, 100), 1, 1):Unpack()
        --threedeq.bars[i]:GetMaterial():SetParam("Diffuse", Vec3(r, g, b))
    end
end)

util.MonitorFileInclude()