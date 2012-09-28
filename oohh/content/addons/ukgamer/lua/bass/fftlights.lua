local BUCKETS = 30

fftlights = fftlights or {}

for i = 1, BUCKETS do
    if fftlights[i] and fftlights[i]:IsValid() then fftlights[i]:Remove() end
    fftlights[i] = entities.Create("light")
    fftlights[i]:SetPos(Vec3(1048.2399902344, 1184.9357910156, 31.048616409302) + Vec3(i * 5, 0, 2))
    fftlights[i]:SetKeyValue("Radius", 5)
    fftlights[i]:Spawn()
end

fftlightsplayer = Channel(BASS_URL, "http://pub2.di.fm/di_techhouse", 0, BASS_STREAM_STATUS)
fftlightsplayer:Play()

local function update()
    if not fftlights or fftlightsplayer == NULL then
        if fftlights then
            for k, v in pairs(fftlights) do v:Remove() end
        end
        hook.Remove("PostGameUpdate", "update")
    end
    
    if not fftlightsplayer:IsPlaying() then return end
    
    local fft = fftlightsplayer:GetFFT()
    
    for i = 1, #fftlights do
        if fftlights[i]:IsValid() then
            local val = (fft[i] ^ 0.7) * 200
            local r, g, b = HSVToColor(-val + 100, 1, 1):Unpack()
           
            fftlights[i]:SetKeyValue("Color.clrDiffuse", Vec3(r, g, b) * val / 10)
        end
    end
end

hook.Add("PostGameUpdate", "update", update)

util.MonitorFileInclude()