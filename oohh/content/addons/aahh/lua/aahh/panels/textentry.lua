
--if os.getenv("USERNAME") ~= "capsadmin" then return end

local PANEL = {}

PANEL.ClassName = "textentry"

aahh.GetSet(PANEL, "ChokeTime", 0.5)
aahh.GetSet(PANEL, "CaretPos", 0)
aahh.GetSet(PANEL, "MultiLine", false)
aahh.GetSet(PANEL, "DrawBackground", true)
aahh.GetSet(PANEL, "TextSize", 8)
aahh.GetSet(PANEL, "BorderWidth", 1)
aahh.GetSet(PANEL, "Text")
aahh.GetSet(PANEL, "Font", "tahoma.ttf")

function PANEL:Initialize()
	self:Clear()
end

function PANEL:Clear()
	self.Text = ""
	self.Lines = 1
	self.CaretPos = 1
end

function PANEL:SuppressNextChar()
	self.suppress_char = true
end

function PANEL:SuppressNextKey()
	self.suppress_key = true
end

function PANEL:GetChar(pos)
	return self.Text:sub(pos, pos)
end

function PANEL:Append(char)
	self.Text = self.Text:sub(1, self.CaretPos) .. char .. self.Text:sub(self.CaretPos+1)
end

function PANEL:DoChoke(time)
	self.Choke = CurTime() + (time or self.ChokeTime)
end

function PANEL:OnMouseInput(key, press, pos)
	if press then	
		self.CaretPos = math.ceil(((pos.x / self:GetWide()) * #self.Text)) -- wrong
		self:MakeActivePanel()
	end
end

function PANEL:HandleKey(key)

	if key == "v" and input.IsKeyDown("lctrl") then
		local str = window.GetClipboard()
		if #str > 0 then
			self.Text = self.Text:sub(1, self.CaretPos+1) .. str .. self.Text:sub(self.CaretPos+2)
			self.CaretPos = self.CaretPos + #str
			self:SuppressNextChar()
		end
		return
	end

	if key == "right" then
		local pos = self.CaretPos + 1

		--if input.IsKeyDown("lctrl") then
		--	pos = (select(2, self.Text:find("[%s%p].-[%P%S]", self.CaretPos+1)) or 1) - 1
		--	if pos < self.CaretPos then
		--		pos = #self.Text
		--	end
		--end
		
		self.CaretPos = math.clamp(pos, 0, #self.Text)
		return
	elseif key == "left" then
		local pos = self.CaretPos - 1
		
		--if input.IsKeyDown("lctrl") then
		--	pos = (select(2, self.Text:sub(1, self.CaretPos):find(".*[%s%p].-[%P%S]")) or 1) - 1
		--end
		
		self.CaretPos = math.clamp(pos, 0, #self.Text)
		return
	elseif key == "end" then
		self.CaretPos = #self.Text
		return
	elseif key == "home" then
		self.CaretPos = 0
		return
	end

	if key == "delete" then
		--if input.IsKeyDown("lctrl") then
		--	local min, max = self.Text:find("[%S%P]-[%s%p]", self.CaretPos+1)
		--	if min and max then
		--		self.Text = self.Text:sub(1, min+1)
		--	end
		--else
			self.Text = self.Text:sub(1, self.CaretPos) .. self.Text:sub(self.CaretPos+2)
		--end
	elseif key == "backspace" then
		if self.CaretPos == 0 then return end
		self.Text = self.Text:sub(1, self.CaretPos-1) .. self.Text:sub(self.CaretPos+1)
		self:HandleKey("left")
	elseif key == "space" then
		self.Text = self.Text:sub(1, self.CaretPos+1) .. " " .. self.Text:sub(self.CaretPos+2)
		self:HandleKey("right")
	--elseif key == "tab" then
	--	self.Text = self.Text .. "\t"
	--	self:HandleKey("right")
	elseif key == "enter" or key == "np_enter" then
		if self.MultiLine then
			self:Append("\n")
		else
			self:OnEnter(self.Text)
		end
	else
		self:OnUnhandledKey(key)
	end

	self.Lines = #self.Text:Explode("\n")
end

function PANEL:HandleChar(char)
	if char and char ~= "" and char:byte() > 32 then
		self:Append(char)
		self:HandleKey("right")
	else
		self:OnUnhandledChar(char)
	end
end

function PANEL:OnKeyInput(key, press)
	
	if self.suppress_key then
		self.suppress_key = false
		return
	end
	
	if press then
		self.Key = key
		self:HandleKey(key)
		self:DoChoke()
	else
		self.Key = nil
	end
end

function PANEL:OnCharInput(char, press)
	
	if self.suppress_char then
		self.suppress_char = false
		return
	end
		
	if press then
		self.Char = char
		self:HandleChar(char)
		self:DoChoke()
	else
		self.Char = nil
	end
end

local blink_rate = 0.6

function PANEL:GetTextSize(from_caret)
	return graphics.GetTextSize(self.Font, from_caret and self.Text:sub(1, self.CaretPos) or self.Text) * self.TextSize
end

function PANEL:OnDraw()
	self:DrawHook("TextEntryDraw")
end

function PANEL:OnThink()
	if self.Visible and self.Key and (not self.Choke or self.Choke < CurTime()) then
		self:HandleKey(self.Key)
		self:HandleChar(self.Char)
	end
end

function PANEL:OnEnter(str)
	self:Clear()
end

function PANEL:OnUnhandledKey(key)
	
end

function PANEL:OnUnhandledChar(char)

end

aahh.RegisterPanel(PANEL)
--print("loaded")
--util.MonitorFileInclude(nil, "aahh/init.lua")

