if not awesomium then return end

local PANEL = {}

PANEL.ClassName = "html"

local scrw, scrh = render.GetScreenSize()

function PANEL:Initialize()
	self.webview = WebView(scrw, scrh)
	self.webview:SetTransparent(true)
	self.texture = Texture(scrw, scrh, ETF_A8R8G8B8)
end

function PANEL:OnRemove()
	self.webview:Remove()
end

local function DELEGATE(name)
	PANEL[name] = function(s, ...)
		return s.webview[name](s.webview, ...)
	end
end

DELEGATE("LoadURL")

function PANEL:OnRequestLayout()	
	local siz = self:GetSize()
	self.webview:SetSize(siz.w, siz.h)
end

function PANEL:OnDraw()
	self.webview:UpdateTexture(self.texture)
	graphics.DrawTexture(self.texture, Rect(0, 0, scrw, scrh), nil, nil, true)
end

function PANEL:OnCharInput(char)
	self.webview:InjectKeyboardEvent(char:byte(), kTypeChar, input.GetModifiers())
end

function PANEL:OnKeyInput(key, press)
	if press then
		self.webview:InjectKeyboardEvent(input.GetSymbolByName(key), press and kTypeKeyDown or kTypeKeyUp, input.GetModifiers())
	end
end

function PANEL:OnMouseMove(pos)
	awesomium.Update()
	self.webview:InjectMouseMove(pos.x, pos.y)
end

local mouse = 
{
	mouse1 = 0,
	mouse3 = 1,
	mouse2 = 2,
}

function PANEL:OnMouseInput(button, press, pos)
	if mouse[button] then 
		self.webview:InjectMouseButton(mouse[button], press)
		self:MakeActivePanel()
	end
end


aahh.RegisterPanel(PANEL)
