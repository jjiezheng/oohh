local PANEL = {}

PANEL.ClassName = "grid"

aahh.GetSet(PANEL, "ItemSize")
aahh.GetSet(PANEL, "Spacing", Vec2(1, 1))

aahh.GetSet(PANEL, "StackRight", false)
aahh.GetSet(PANEL, "StackDown", true)

aahh.GetSet(PANEL, "SizeToWidth", true)

function PANEL:Stack()
	local w = 0
	local h
	
	for key, pnl in ipairs(self.CustomList or self:GetChildren()) do
		if not pnl:IsVisible() then goto NEXT end
	
		pnl:SetTrapInsideParent(false)
		
		local siz = self.ItemSize or pnl:GetSize()
		
		if self.Spacing then
			siz = siz + self.Spacing
		end

		if self.StackRight then
			h = h or siz.h
			w = w + siz.w

			if self.StackDown and w > self:GetWidth() then
				h = h + siz.h
				w = siz.w
			end
		else
			h = h or 0
			h = h + siz.h
			w = siz.w
		end

		pnl:SetPos(Vec2(w+2, h+2)-siz)
		
		if self.ItemSize then
			local siz = self.ItemSize
			
			if self.SizeToWidth then
				siz.w = self:GetWidth()
			end

			pnl:SetSize(Vec2(siz.w-self:GetSkinVar("Padding", 1), siz.h))
		elseif self.SizeToWidth then
			pnl:SetWidth(self:GetWidth()-self:GetSkinVar("Padding", 1))
		end
		
		::NEXT::
	end
	
	if self.SizeToWidth then
		w = self:GetWidth()
	end

	return Vec2(w, h)
end

function PANEL:OnRequestLayout()
	self:LayoutHook("GridLayout")
	self:Stack()
end

function PANEL:OnDraw()
	self:DrawHook("GridDraw")
end

aahh.RegisterPanel(PANEL)