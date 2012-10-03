local PANEL = {}

PANEL.ClassName = "menuitem"
PANEL.Base = "button"

function PANEL:Initialize()
	self.lbl = aahh.Create("label", self)
	self.img = aahh.Create("image", self)
	-- self.img:SetIgnoreMouse(true)
	self.button_down = {}
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
	self:SetItemSize(Vec2()+16)
	self:SetPos( Vec2(mouse.GetPos()) )
end

function PANEL:AddOption(icon, str, callback)
	local itm = aahh.Create("menuitem", self)
	itm:SetText(str)
	itm:SetTexture(icon)
	itm:RequestLayout()
	itm.OnPress = function() callback(self) end
	
	self:RequestLayout()
end

function PANEL:AddSpace()
	local itm = aahh.Create("menuitem", self)
	
	self:RequestLayout()
end

function PANEL:OnLayoutRequest()
	self:LayoutHook("ContextLayout")
end

function PANEL:OnDraw()
	self:DrawHook("ContextDraw")
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