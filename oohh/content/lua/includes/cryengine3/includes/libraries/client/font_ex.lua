if not CAPSADMIN then return end
do return end

local type_name = "font_ex"

do 
	local META = {}
	META.__index = META
	
	META.Type = type_name
	
	function META:Update(text, x, y, size, color)
		size = size or 12
		color = color or Color(1,1,1,1)
		local cairo = self.cairo
			 
		cairo:SetOperator(CAIRO_OPERATOR_SOURCE)
		cairo:SetSourceRGBA(0,0,0,0)
		cairo:Paint()

		local sw, sh = render.GetScreenSize()
		local w, h = cairo:TextExtents(text)
		cairo:MoveTo((x/sw) * self.res, ((y+h)/sh) * self.res) 
		cairo:SetSourceRGBA(color:Unpack())
		cairo:SetFontSize(self.size / (sw/sh) * self.res)
		cairo:ShowText(text)
		cairo:Stroke()
		
		cairo:Flush()
		cairo:UpdateTexture(self.tex)
		cairo:MarkDirty()
	end
	
	function META:Draw(...)
		self:Update(...)
		graphics.DrawTexture(self.tex, Rect(0, 0, render.GetScreenSize()))
	end

	util.DeclareMetaTable(type_name, META)
end

local function CreateFont(name, face, size, resolution)	
	face = face or "Arial"
			
	local self = {}
	setmetatable(self, util.FindMetaTable(type_name))
		
	local cairo = Cairo(resolution, resolution) 
	self.tex = Texture(resolution, resolution)
	self.cairo = cairo
	self.res = resolution
	self.size = size
		 
	return self 
end 
 
local fnt = CreateFont("test", "Arial", 1, 1024) 

hook.Add("DrawHUD", 1, function() asdsd()
	local w, h = render.GetScreenSize()
	fnt:Draw("hii", mouse.GetPos())
	fnt:Draw("aSDASD",0,120)
	fnt:Draw("aSDASD",0, 150)
end)

util.MonitorFileInclude() 