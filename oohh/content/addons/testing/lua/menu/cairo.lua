local SIZE = 512

local cairo = Cairo(SIZE, SIZE)

do -- cairo arc sample http://cairographics.org/samples/
	local xc = SIZE/2
	local yc = SIZE/2
	local radius = SIZE/4
	local angle1 = 45 * (math.pi / 180)  -- angles are specified
	local angle2 = 180 * (math.pi / 180)  -- in radians

	cairo:SetLineWidth(10)
	cairo:Arc(xc, yc, radius, angle1, angle2);
	cairo:Stroke()

	-- draw helping lines
	cairo:SetSourceRGBA(1, 0.2, 0.2, 0.6)
	cairo:SetLineWidth(6)

	cairo:Arc(xc, yc, 10, 0, 2 * math.pi)
	cairo:Fill(cr)

	cairo:Arc(xc, yc, radius, angle1, angle1)
	cairo:LineTo(xc, yc)
	cairo:Arc(xc, yc, radius, angle2, angle2)
	cairo:LineTo(xc, yc)
	cairo:Stroke()
end
 
local tex = Texture(SIZE, SIZE)
 
cairo:Flush()
cairo:UpdateTexture(tex)
cairo:MarkDirty()

local frame = aahh.Create("frame")
frame:SetTitle("cairo!")
frame:SetSize(Vec2(500, 500))
frame:Center()

local frame = aahh.Create("panel", frame)
frame:Dock("fill")

function frame:OnPostDraw()
	graphics.DrawTexture(tex, Rect(0,0,self:GetWidth(),self:GetHeight()))
end

util.MonitorFileInclude()