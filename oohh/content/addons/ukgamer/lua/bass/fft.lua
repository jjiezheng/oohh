local BUCKETS = 50

--------------------------

local songs = {}

for name, data in pairs(file.Find("addons/ukgamer/sounds/*", true)) do
    table.insert(songs, name)
end

local cursong = 1

local scrw, scrh = render.GetScreenSize()
local x = scrw / 2

if testplayer and testplayer:IsValid() then testplayer:Stop() end
testplayer = NULL

local tempsize = 1

local function nextsong()
    if cursong == #songs then
        cursong = 1
    else
        cursong = cursong + 1
    end
    
    testplayer:Stop()
    testplayer = Channel(BASS_MUSIC, Path((("sounds/" .. songs[cursong]):gsub("!/../", ""))), 0, BASS_DEFAULT)
    testplayer:Play()
end

local function prevsong()
    if cursong == 1 then
        cursong = #songs
    else
        cursong = cursong - 1
    end
    
    testplayer:Stop()
    testplayer = Channel(BASS_MUSIC, Path((("sounds/" .. songs[cursong]):gsub("!/../", ""))), 0, BASS_DEFAULT)
    testplayer:Play()
end

local function updatehud()
    if testplayer == NULL or not testplayer then return end
    
    if testplayer:GetPosition() >= testplayer:GetLength() then nextsong() end --in seconds
    
    scrw, scrh = render.GetScreenSize()
    
    local fft = testplayer:GetFFT() --fft size 1024
    
    local text = "Now playing " .. songs[cursong]
    
    local bassavg = (fft[3] + fft[4] + fft[5] + fft[6]) / 4
	tempsize = tempsize + ((10 + (bassavg ^ 0.7) * 5) - tempsize) * math.min(FrameTime() * 30, 1)
    
    local w = graphics.GetTextSize("segoeui.ttf", text).w * tempsize
    
    if x < 0 - w then
        x = scrw + w
    else
        x = x - 2
    end
    
    graphics.DrawText(text, Vec2(x, scrh - tempsize), "segoeui.ttf", Vec2() + tempsize, Color(1, 1, 1, 0.7), Vec2(-0.5, -0.5), Vec2() + 1)
    
    local barx = scrw / 2 - (25 * BUCKETS) / 2
    
    for i = 1, BUCKETS do
        local val = (fft[i] ^ 0.7) * 200
        local col = Color(1, 0, 0, 0.3)
        col:SetHue(math.clamp(-val + 100, 0, 100))
        graphics.DrawRect(Rect(barx, scrh - val, 20, val), col)
        barx = barx + 25
    end
    
    --for k, v in pairs(entities.FindInSphere(Vec3(1169.4953613281, 1229.1627197266, 23.350603103638), 256)) do
        --if typex(v) ~= "player" then
            --v:SetScale(1 + Vec3() + (fft[3] ^ 0.7) * 5)
        --end
    --end
end

local function start()
    if testplayer ~= NULL and testplayer:IsValid() then testplayer:Stop() end
    testplayer = Channel(BASS_MUSIC, Path((("sounds/" .. songs[cursong]):gsub("!/../", ""))), 0, BASS_DEFAULT)
    print(bass.GetLastError())
    testplayer:Play()
    
    hook.Add("DrawHUD", "ffttest", updatehud)
end

local function stop()
    if testplayer ~= NULL and testplayer:IsValid() then
        hook.Remove("DrawHUD", "ffttest")
        testplayer:Stop()
    end
end

console.AddCommand("nextsong", nextsong)
console.AddCommand("prevsong", prevsong)
console.AddCommand("startsong", start)
console.AddCommand("stopsong", stop)

util.MonitorFileInclude()