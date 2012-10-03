local string = string
local table = table
local surface = surface
local ipairs = ipairs
local setmetatable = setmetatable
local math = math
local Color = Color
local SysTime = os.clock
local tostring = tostring
local print = print
local PrintTable = table.print
local pcall = pcall
--
local PANEL = {}

class.GetSet( PANEL, "InputPanel" )

function PANEL:Initialize()
	self.Text = richformat.New(self:GetWide(), self:GetTall(), 50)

	self.LastClick = 0

	--self.ScrollBar = vgui.Create( "SlideBar", self )
	--self.ScrollBar:SetZPos( 0 )

	self:SetFade(false)
end

function PANEL:SetFilter( filter )
	self.Text:SetFilter( filter )
end

function PANEL:GetFilter()
	self.Text:GetFilter()
end

function PANEL:OnMouseWheeled( dlta )
	--self.ScrollBar:AddVelocity( dlta )
end

function PANEL:Add( text, color, font, time, onclick, onclickref, filter, newline )
	self.Text:Add( text, color, font, time, onclick, onclickref, filter, newline )
end

function PANEL:SetFade(val)
	self.Fade = val

	--self.ScrollBar:SetVisible(not val)

	if val then
		self.Text:ClearSelection()
	end
end

function PANEL:GetFilter()
	return self.Text:GetFilter()
end

function PANEL:SetFilter(x)
	self.Text:SetFilter(x)
end

function PANEL:Copy()
	window.SetClipboard(self.Text:GetSelectedText())
	self.Text:ClearSelection()

	self:GetInputPanel():RequestFocus()
end

function PANEL:OnKeyCodePressed(kc)
	if kc == KEY_C and input.IsKeyDown(KEY_LCONTROL) then
		self:Copy()
	end
end
local MOUSE_LEFT=1
function PANEL:OnMousePressed(mc)
	self:MouseCapture(true)
	self:RequestFocus()

	if mc == MOUSE_LEFT then
		local pos = self:GetMousePos()

		if SysTime() < self.LastClick + 0.3 then
			self.Text:ClearSelection()
			self.Text:DoClick(pos)
		else
			self.Text:SetSelectionStart(pos)
		end

		self.LastClick = SysTime()
	elseif mc == 2 then
		self:Copy()
	end
end

function PANEL:OnMouseReleased(mc)
	self:MouseCapture(false)

	local s, e = self.Text:GetSelection()
	if s == 0 or e == 0 then
		self:GetInputPanel():RequestFocus()
	end
end
function PANEL:OnCursorMoved()
	local pos = self:GetMousePos()

	self:SetCursor(self.Text:GetCursor(pos))

	if input.IsKeyDown("mouse1") and SysTime() > self.LastClick then
		self.Text:SetSelectionEnd(pos)
	end
end

function PANEL:OnThink()
	--if self.ScrollBar:Changed() then
	--	self.Text:SetScroll(self.ScrollBar:Value() * (self.Text:GetTotalHeight() - self:GetTall()) )
	--end
end

function PANEL:OnRequestLayout()
	local w,h = self:GetSize()

	--self.ScrollBar:SetPos(w - 16, 0)
	--self.ScrollBar:SetSize(16, h)

	self.Text:SetPos(3,0)
	self.Text:SetSize(w-3,h)

	local height = self.Text:GetTotalHeight()

	--if self.ScrollBar:Value() == 0 then
	--	self.ScrollBar:SetScroll(1)
	--end

	if height > h then
		self.Text:SetSize(w - 18,h)
		height = self.Text:GetTotalHeight()
	end

	--self.ScrollBar:SetBarScale( (height / h) )

	local page = self.Text:GetTotalHeight() - self:GetTall()

	if self.Fade then
	--	self.ScrollBar:SetScroll(1)
		self.Text:SetScroll(page)
	else
		--self.Text:SetScroll(self.ScrollBar:Value() * page)
	end
end

function PANEL:OnDraw()
	self.Text:Draw(self.Fade)
end

aahh.Register( "RichText", PANEL)
--
module("richformat")

local CharWidth = {}
local RichObject = {}

function RichObject:Create(w,h,lc)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.buffer = ""
	o.styles = {}
	o.parsedstyles = {}
	o.lines = nil

	o.width, o.height = w, h
	o.totalheight = 0
	o.maxlines = lc

	o.numlines = 0

	o.X, o.Y = 0, 0
	o.scroll = 0

	o.cfilter = 0

	o.drawbounds = {0, 0}

	o.selection = {}

	return o
end

function RichObject:BuildWidthCache(font)
	if not CharWidth[font] then
		CharWidth[font] = {}
		surface.SetFont(font)
		for i=1,127 do
			local c = string.char(i)
			CharWidth[font][c] = surface.GetTextSize(c)
		end
		CharWidth[font]["&"] = CharWidth[font]["^"] -- & is 0 width
	end
end

function RichObject:CalcTextSizeEx(buffer)
	local buff = string.gsub(buffer, "&", "^")
	return surface.GetTextSize(buff)
end

function RichObject:CalcCharWidthExtended(font, str, pos, maxpos)
		local c = string.sub(str, pos, pos)

		if CharWidth[font][c] then
			return CharWidth[font][c], c, pos
		end

		local byte = string.byte(c)
		if byte < 194 or byte > 244 or pos == maxpos then
			return 0, c, pos
		end

		pos = pos + 1
		local c2 = string.sub(str, pos, pos)
		byte = string.byte(c2)

		while byte >= 128 and byte <= 191 do
			c = c .. c2
			pos = pos + 1
			if pos > maxpos then break end

			c2 = string.sub(str, pos, pos)
			byte = string.byte(c2)
		end

		if CharWidth[font][c] then
			return CharWidth[font][c], c, pos-1
		end

		surface.SetFont(font)
		CharWidth[font][c] = surface.GetTextSize(c)
		return CharWidth[font][c], c, pos-1
end

function RichObject:BuildStyle(pos, length, color, font, time, onclick, onclickref, filter, newline)
	local style = {}

	style.pos = pos
	style.length = length

	style.color = color
	style.font = font
	style.time = time
	style.newline = newline

	style.onclick = onclick
	style.onclickref = onclickref

	style.filter = filter
	surface.SetFont(font)

	local buffer = string.sub(self.buffer, pos, pos + length - 1)
	buffer = string.gsub(buffer, "\n", "") -- this was Replace but gsubbing \n should work

	style.xwidth, style.yheight = self:CalcTextSizeEx(buffer)

	return style
end

function RichObject:Add(text, color, font, time, onclick, onclickref, filter, newline)
	if not color then color = color_white end
	if not font then font = "default" end
	if not time then time = SysTime() end
	if not filter then filter = 0 end

	self:BuildWidthCache(font)

	local p = 1

	if not newline then
		for i = 1, #text do
			if string.sub(text, i, i) == "\n" then
				self:Add(string.sub(text, p, i), color, font, time, onclick, onclickref, filter, true)
				p = i + 1
			end
		end
	else
		self.numlines = self.numlines + 1
	end

	if self.numlines > self.maxlines then

		local blk
		repeat
			blk = table.remove(self.styles, 1)
		until blk.newline == true

		local pos = blk.pos + blk.length - 1
		self.buffer = string.sub(self.buffer, pos + 1)

		for k, v in ipairs(self.styles) do
			v.pos = v.pos - pos
		end
	
		local s, e = self:GetSelection()
		if s > 0 and e > 0 then
			self.selection[1], self.selection[2] = s-pos, e-pos
		end

		self.numlines = self.numlines - 1
	end

	text = string.sub(text, p)

	if #text == 0 then return end

	local pos = #self.buffer + 1
	self.buffer = self.buffer .. text

	local style = self:BuildStyle(pos, #text, color, font, time, onclick, onclickref, filter, newline)

	table.insert(self.styles, style)

	self:Parse()
end

function RichObject:NewLine(ypos)
	local nl = {firstsyle=nil, ypos=ypos, xwidth=0, yheight=0}
	table.insert(self.lines, nl)

	return nl
end

function RichObject:AssociateStyleWithLine(style, line)
	style.line = line
	style.xpos = line.xwidth

	local index = table.insert(self.parsedstyles, style)

	if not line.firststyle then
		line.firststyle = index
	end

	line.yheight = math.max(line.yheight, style.yheight)
	line.xwidth = line.xwidth + style.xwidth

	if style.newline then
		return self:NewLine(line.ypos + line.yheight + 2)
	end
	return line
end

function RichObject:Parse()

	self.parsedstyles = {}
	self.lines = {}

	local currentline = self:NewLine(0)

	for k, v in ipairs(self.styles) do

		if not bit.band(v.filter, self.cfilter) > 0 then

		if currentline.xwidth + v.xwidth <= self.width then

			if currentline.xwidth + v.xwidth == self.width then
				v = table.Copy(v)
				v.newline = true
			end

			currentline = self:AssociateStyleWithLine(v, currentline)

		else

			local cw = currentline.xwidth
			local pos = v.pos

			local i, lte = 0, v.length - 1
			while i <= lte do
				local cpos = v.pos + i
				local c, ch, cpos = self:CalcCharWidthExtended(v.font, self.buffer, cpos, v.pos + lte)
				i = cpos - v.pos

				local chc = cw + c

				local wordwrap = false

				if ch == " " then
					local wpos = string.find(self.buffer, " ", cpos + 1)
					if not wpos then
						wpos = v.pos + lte
					end

					local width = self:GetPixelOffsetPos(v, wpos, true, i)

					if cw + width > self.width then
						cpos = cpos + 1
						wordwrap = true
					end
				end

				if chc <= self.width and not wordwrap then
					cw = chc
				else
					local style = self:BuildStyle(pos, cpos - pos, v.color, v.font, v.time, v.onclick, v.onclickref, v.filter, true)

					currentline = self:AssociateStyleWithLine(style, currentline)

					pos = cpos
					cw = c
				end

				i = i + 1
			end

			if pos < v.pos + v.length then
				local style = self:BuildStyle(pos, (v.pos + v.length) - pos, v.color, v.font, v.time, v.onclick, v.onclickref, v.filter, v.newline)

				currentline = self:AssociateStyleWithLine(style, currentline)
			end

		end

		end
	end

	if not currentline.firststyle then
		local l = table.remove(self.lines, table.maxn(self.lines))
		self.totalheight = l.ypos
	else
		self.totalheight = currentline.ypos + currentline.yheight
	end

	self:CalcDraw()
end

function RichObject:CalcDraw()
	self.drawbounds[1], self.drawbounds[2] = 0, 0

	if not self.lines or #self.lines == 0 then return end

	for k,l in ipairs(self.lines) do
		if self.drawbounds[1] == 0 and l.ypos + l.yheight > self.scroll then
			self.drawbounds[1] = l.firststyle
		elseif l.ypos > (self.height + self.scroll) then
			self.drawbounds[2] = l.firststyle - 1
			break
		end
	end

	if self.drawbounds[2] <= 0 then
		self.drawbounds[2] = #self.parsedstyles
	end
end

function RichObject:SetFilter(x)
	self.cfilter = x
	self:Parse()
end

function RichObject:GetFilter()
	return self.cfilter
end

function RichObject:SetSize(w, h)
	if w == self.width and h == self.height then return end
	self.width, self.height = w, h
	self:Parse()
end

function RichObject:SetPos(x, y)
	self.X, self.Y = x,y
end

function RichObject:SetScroll(scroll)
	if scroll < 0 then scroll = 0 end
	self.scroll = scroll

	self:CalcDraw()
end

function RichObject:GetTotalHeight()
	return self.totalheight
end

function RichObject:GetPixelOffsetPos(block, pos, endof, start)
	local w = 0
	if not start then start = 0 end

	local i, lte = start, block.length - 1
	while i <= lte do
		local p = block.pos + i

		if not endof and p == pos then break end

		local c, ch, n = self:CalcCharWidthExtended(block.font, self.buffer, p, block.pos + lte)
		i = n - block.pos

		w = w + c

		if endof and p == pos then break end
		i = i + 1
	end
	return w
end

function RichObject:DrawSelection(block)
	local s, e = self:GetSelection()
	if s > block.pos + block.length - 1 or e < block.pos then
		return
	end

	local start = 0
	local endpx = block.xwidth

	if s >= block.pos and s <= block.pos + block.length - 1 then
		start = self:GetPixelOffsetPos(block, s)
	end
	if e >= block.pos and e <= block.pos + block.length - 1 then
		endpx = self:GetPixelOffsetPos(block, e, true)
	end

	surface.SetDrawColor( 155, 155, 155, 200 )
	surface.DrawRect(self.X + block.xpos + start, self.Y + block.line.ypos - self.scroll, endpx - start, block.yheight)
end

function RichObject:Draw(fade)
	local stay = 10
	local curtime = SysTime()

	if self.drawbounds[1] == 0 or self.drawbounds[2] == 0 then return end
 
	for i=self.drawbounds[1], self.drawbounds[2] do
		local block = self.parsedstyles[i]

		if not block then
			PrintTable(self.drawbounds)
			PrintTable(self.parsedstyles)
			Error("tried to draw")
		end

		local buffer = string.sub(self.buffer, block.pos, block.pos + block.length - 1)

		local s, e = self:GetSelection()

		if s > 0 and e > 0 then
			self:DrawSelection(block)
		end

		local a = block.color.a

		if fade and curtime > block.time + stay then
			local delta = (curtime - (block.time + stay))
			if delta <= 1 then
				a = 255 * (1 - delta)
			else
				a = 0
			end
		end

		if a > 0 then
			surface.SetFont(block.font)

			local x, y = self.X + block.xpos, self.Y + block.line.ypos - self.scroll
			surface.SetColor(Color( 0, 0, 0, math.Clamp(a - 50, 0, 255)/255) )
			surface.DrawText(buffer, x+1, y+1, Vec2()+12, nil, nil, 2)

			surface.SetColor( Color(block.color.r, block.color.g, block.color.b, a/255) )
			surface.DrawText(buffer, x, y, Vec2()+12, nil, nil, 2)
		end
	end
end

function RichObject:GetStyleForPosition(pos, exact)
	local bestblock = 0

	if self.drawbounds[1] == 0 or self.drawbounds[2] == 0 then return nil, 0 end

	if pos.y < self.Y then pos.y = self.Y end
	if pos.x < self.X then pos.x = self.X end

	for i=self.drawbounds[1], self.drawbounds[2] do
		local block = self.parsedstyles[i]

		local bypos = self.Y + block.line.ypos - self.scroll
		local bxpos = self.X + block.xpos

		if pos.y >= bypos and pos.x >= bxpos and (not exact or pos.y <= bypos + block.yheight) then
			bestblock = i
		end
	end

	if bestblock == 0 then return nil, 0 end

	local bblock = self.parsedstyles[bestblock]
	local cw = self.X + bblock.xpos

	local i, lte = 0, bblock.length-1
	while i <= lte do
		local p = bblock.pos + i

		local c, ch, n = self:CalcCharWidthExtended(bblock.font, self.buffer, p, bblock.pos + lte)
		i = n - bblock.pos

		if pos.x >= cw and pos.x <= cw + c then
			return bblock, p
		end

		cw = cw + c
		i = i + 1
	end

	return bblock, bblock.pos + bblock.length - 1
end

function RichObject:DoClick(pos)
	local block, pos = self:GetStyleForPosition(pos, true)

	if block and block.onclick then
		pcall(block.onclick, string.sub(self.buffer, block.pos, block.pos + block.length - 1), block.onclickref)
	end
end

function RichObject:GetCursor(pos)
	local block, pos = self:GetStyleForPosition(pos, true)

	if block and block.onclick then
		return IDC_HAND
	end
	return IDC_BEAM
end

function RichObject:ClearSelection()
	self.selection[1], self.selection[2] = 0, 0
end

function RichObject:SetSelectionStart(pos)
	local block, pos = self:GetStyleForPosition(pos)
	self.selection[1] = pos
	self.selection[2] = 0
end

function RichObject:SetSelectionEnd(pos)
	local block, pos = self:GetStyleForPosition(pos)
	self.selection[2] = pos
end

function RichObject:GetSelection()
	if not self.selection[1] or not self.selection[2] then return 0,0 end

	if self.selection[1] > self.selection[2] then
		return self.selection[2], self.selection[1]
	end
	return self.selection[1], self.selection[2]
end

function RichObject:GetSelectedText()
	local s, e = self:GetSelection()
	if s == 0 or e == 0 then return "" end

	local buffer = ""

	for i=self.drawbounds[1], self.drawbounds[2] do
		local block = self.parsedstyles[i]
		
		if s <= block.pos + block.length - 1 and e >= block.pos then
			local start = block.pos
			local endpos = start + block.length - 1

			if s >= block.pos and s <= block.pos + block.length - 1 then
				start = s
			end

			if e >= block.pos and e <= block.pos + block.length - 1 then
				local c, ch, p = self:CalcCharWidthExtended(block.font, self.buffer, e, block.pos + block.length - 1)
				endpos = p
			end

			buffer = buffer .. string.sub(self.buffer, start, endpos)
		end
	end

	return buffer
end

function New(w,h, lc)
	return RichObject:Create(w,h,lc)
end