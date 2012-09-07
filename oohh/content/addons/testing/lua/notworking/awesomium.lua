awesomium.Open()

local frame = aahh.Create("frame")
frame:SetTitle("awesome! (ium)")
frame:SetSize(Vec2(512, 512))
frame:Center()

local tex = Texture(1024, 1024)

local view = WebView(1024, 1024)
view:LoadURL("http://www.google.com/")
view:SetTransparent(true)

function frame:OnPostDraw()
	view:UpdateTexture(tex)
	surface.SetTexture(tex:GetId())
	
	surface.SetColor(Color(1,1,1,1))
	surface.DrawTexturedRectEx(
		0,0, 
		1024,1024
	)
	
	awesomium.Update()
end
