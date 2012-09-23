local PANEL = {}

PANEL.ClassName = "button"

function PANEL:Initialize()
	self:SetCursor(IDC_HAND)
end

function PANEL:OnMouseInput(key, press)
	if key == "mouse1" then
		if press and not self.is_down then 
			self.is_down = true
		return end
			
		if not press then
			self:OnRelease(key)
		end
		
		if not press and self.is_down then
			return self:OnPress(key)
		end
	end
end

function PANEL:IsDown()
	if self.is_down and not input.IsKeyDown("mouse1") then
		self.is_down = false
	end
	
	return self.is_down
end

function PANEL:IsMouseOver()
	return self.MouseOver
end

function PANEL:OnPress(key) end
function PANEL:OnRelease(key) end

function PANEL:OnDraw()
	self:DrawHook("ButtonDraw")
end

function PANEL:OnRequestLayout()
	self:LayoutHook("ButtonLayout")
end

aahh.RegisterPanel(PANEL)