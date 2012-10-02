local PANEL = {}

PANEL.ClassName = "textbutton"
PANEL.Base = "button"

function PANEL:Initialize()
	self.BaseClass.Initialize(self)
	
	self.lbl = aahh.Create("label", self)
	self.lbl:SetIgnoreMouse(true)
	
	self:AlignLabel(ALIGN_CENTERLEFT)
	
	self:SetCursor(IDC_HAND)
end

function PANEL:GetLabel()
	return self.lbl or NULL
end

function PANEL:AlignLabel(vec)
	self.lbl:Align(vec)
	self.label_align = vec
end

function PANEL:SetText(str)
	self.lbl:SetText(str)
	self.lbl:SizeToText()
	self:RequestLayout()
end

function PANEL:SetFont(name)
	self.lbl:SetFont(name)
end

function PANEL:SetTextSize(siz)
	self.lbl:SetTextSize(siz)
end

function PANEL:OnDraw()
	self:DrawHook("ButtonTextDraw")
end


function PANEL:OnRequestLayout()
	self:LayoutHook("ButtonTextLayout")
end

aahh.RegisterPanel(PANEL)