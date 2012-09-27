local BUCKETS = 30

testplayer = testplayer or Channel(BASS_URL, "http://epic-empires.co.uk:8000/ukgamer.ogg", 0, BASS_STREAM_STATUS)
testplayer:Play()
testplayer:SetVolume(0.5)

hook.Add("DrawHUD", "ffttest", function()
    local scrw, scrh = render.GetScreenSize()
    
    local fft = testplayer:GetFFT() --fft size 1024
    local x = scrw / 2 - (35 * BUCKETS) / 2
    
    for i = 1, BUCKETS do
        local val = (fft[i] ^ 0.7) * 200
        local col = Color(1, 0, 0, 0.5)
        col:SetHue(-val + 100)
        graphics.DrawRect(Rect(x, scrh - val, 30, val), col)
        graphics.DrawText(math.floor((44100 / #fft) * i) .. "Hz", Vec2(x, scrh - 12 - 3), "segoeui.ttf", Vec2() + 7, Color(1, 1, 1, 1))
        x = x + 35
    end
end)

util.MonitorFileInclude()