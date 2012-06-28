local PANEL = {}

PANEL.ClassName = "image"

aahh.GetSet(PANEL, "Texture", Texture("aahh/c.dds"))
aahh.GetSet(PANEL, "UV")
aahh.GetSet(PANEL, "Color")
aahh.GetSet(PANEL, "Scale", Vec2(1,1))

function PANEL:SizeToContent()
	local siz = Vec2(self.Texture:GetSize()) * self.Scale
	self:SetMinSize(siz)
	self:SetSize(siz)
end

function PANEL:OnDraw()
	self:DrawHook("ImageDraw")
end

function PANEL:OnRequestLayout()
	self:LayoutHook("ImageLayout")
end

aahh.RegisterPanel(PANEL)