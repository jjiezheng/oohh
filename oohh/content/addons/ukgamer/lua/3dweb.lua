local WIDTH = 1280
local HEIGHT = 720

threedbrowsers = threedbrowsers or {}

local urls = { "http://google.com", "http://youtube.com", "http://html5rocks.com", "http://yahoo.com", "http://microsoft.com" }

if threedbrowsers then
    for i = 1, #threedbrowsers do
        if threedbrowsers[i]:IsValid() then threedbrowsers[i]:Remove() end
    end
end

for i = 1, 3 do
    threedbrowsers[i] = WebView(WIDTH, HEIGHT)
    threedbrowsers[i]:SetTransparent(true)
    threedbrowsers[i]:LoadURL(urls[math.random(#urls)])
    
    threedbrowsers[i].OnDocumentReady = function()
        MsgN(i .. " finished loading")
        threedbrowsers[i]:ExecuteJavascriptWithResult("document.documentElement.style.overflow = 'hidden';")
    end
    
    threedbrowsers[i].texture = Texture(WIDTH, HEIGHT, ETF_A8R8G8B8)
end

local origin = Vec3(1257, 825, 38)
local angles = Ang3(30, 10, -26):GetRad()
local scale = Vec3()+1

hook.Add("PostGameUpdate", "3dweb", function()
	local cam = render.GetCamera()
	cam:SetPos(cam:GetPos() - origin)
	render.SetCamera(cam) 
	
	graphics.DisableFlags(true)
    for i = 1, #threedbrowsers do
        threedbrowsers[i]:UpdateTexture(threedbrowsers[i].texture)
			
		render.SetState(
			bit.bor(
				GS_BLSRC_SRCALPHA,
				GS_BLDST_ONEMINUSSRCALPHA,
				GS_DEPTHWRITE
			)
		)
        graphics.DrawTexture(threedbrowsers[i].texture, Rect(i * ((WIDTH / 16) + 3), 0, -WIDTH / 16, HEIGHT / 16), nil, nil, false)
		
    end
	graphics.DisableFlags(false)
end)

util.MonitorFileInclude()