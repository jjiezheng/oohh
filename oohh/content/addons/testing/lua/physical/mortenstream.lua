if SERVER then return end

local html = aahh.Create("html")
html:SetSize(Vec2()+400)
html:LoadURL("http://morten.ae/stream/")

local voldata = Vec3(1,1,1) -- V, L, R
local should_play = true

local function calcsource(eye, rgt, src, dist, fwd)
    local vol = math.clamp(-((eye - src):GetLength() / dist) + 1, 0, 1)
    local dot = rgt:Dot((src - eye):Normalize())

    voldata.x = vol * 2

    voldata.y = math.clamp(-dot, 0, 1) + 0.5
    voldata.z = math.clamp(dot, 0, 1) + 0.5

	should_play = vol ~= 0
end

local source = here
local function CalcVolumeData()
	local ply = entities.GetLocalPlayer()
	if ply:IsValid() then
		local ang = ply:GetViewRotation():GetAng3()
		return calcsource(ply:GetEyePos(), ang:GetRight(), source, 10, ang:GetForward())
	else
		local x,y = mouse.GetPos()
		local w,h = render.GetScreenSize()
		voldata.x = y / h
		
		voldata.y = x / w
		voldata.z = x / w
	end
end


function html:OnThink()	
	CalcVolumeData()
	
	if should_play then
		print(self.webview:ExecuteJavascriptWithResult(("setVolume(%s); setPanning(%s)"):format(voldata.x, voldata.y * voldata.z)))
	end
end