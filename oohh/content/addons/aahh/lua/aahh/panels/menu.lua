local PANEL = {}

PANEL.ClassName = "menuitem"
PANEL.Base = "button"

function PANEL:Initialize()
	self.lbl = aahh.Create("label", self)
	self.img = aahh.Create("image", self)
	self.img:SetIgnoreMouse(true)
end

function PANEL:SetText(...)
	self.lbl:SetText(...)
end

function PANEL:SetTexture(...)
	self.img:SetTexture(...)
end

function PANEL:OnDraw()
	self:DrawHook("MenuItemDraw")
end

function PANEL:OnRequestLayout()
	self:LayoutHook("MenuItemLayout")
end
 
aahh.RegisterPanel(PANEL)
 
local PANEL = {}

PANEL.ClassName = "context"
PANEL.Base = "grid"

function PANEL:Initialize()
	self:SetStackRight(false)
	self:SetSizeToWidth(true)
	self:SetItemSize(false)
	self:SetSpacing(false)
end

function PANEL:AddOption(icon, str, callback)
	local itm = aahh.Create("menuitem", self)
	itm:SetText(str)
	itm:SetTexture(icon)
	itm:RequestLayout()
	itm.OnPress = function() callback(self) end
end

function PANEL:AddSpace()
	local itm = aahh.Create("menuitem", self)
end

function PANEL:OnLayoutRequest()
	self:LayoutHook("ContextLayout")
end

aahh.RegisterPanel(PANEL)
 
if CAPSADMIN and false then 
	timer.Simple(0.1, function()
		local ctx = aahh.Create("context")
		ctx:Center()
		ctx:SetSize(Vec2(60, 100))
		
		ctx:AddOption(Texture("gui/corner.dds"), "hello", function() print("asasd") end)
		ctx:AddOption(Texture("gui/corner.dds"), "hello", function() print("asasd") end)
		ctx:AddSpace()
		ctx:AddOption(Texture("gui/corner.dds"), "hello", function() print("asasd") end)
		ctx:AddSpace()
		ctx:AddOption(Texture("gui/corner.dds"), "hello", function() print("asasd") end)
	end)

	util.MonitorFileInclude()
end