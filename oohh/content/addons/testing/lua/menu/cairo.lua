local W, H = render.GetScreenSize()

g_cairo = g_cairo or Cairo(W, H)
local cairo = g_cairo

cairo:SetSourceRGBA(0,0,0,1)
cairo:Rectangle(0,0,W,H)
cairo:Fill()
cairo:Stroke()
cairo:Flush()
cairo:MarkDirty()
	
cairo.tex = cairo.tex or Texture(W, H)  

local last_pos = Vec2() 
local vel = Vec2()
   
local function draw_brush(pos, size, blur, dir)
	blur = blur or 1
	for i=1, blur do
		local amt = (i/blur)
		cairo:SetLineWidth(size * amt)
		
		cairo:MoveTo(last_pos.x, last_pos.y)
		cairo:LineTo(pos.x, pos.y)
		
		cairo:Stroke()
	end
end 

local color = Color(1,0,0,0.1)
color:SetSaturation(1)

local help = "click and drag your cursor around!"
cairo:SelectFontFace("Arial")
cairo:SetFontSize(100) 
local w, h = cairo:TextExtents(help)
cairo:MoveTo(W/2 - (w*0.5), H/2 - (h*0.5))
cairo:SetSourceRGBA(1,1,1,1)
cairo:ShowText(help)  
cairo:Stroke() 

local function draw()
	local pos = Vec2(mouse.GetPos())
	local _vel = pos - last_pos
	vel = vel + ((_vel - vel) * FrameTime() * 20)
	local len = vel:GetLength()	
	
	cairo:SetLineCap(1)
	
	color:SetHue(os.clock())
	
	if input.IsKeyDown("mouse1") then
		draw_brush(pos, len+5, 30, vel)
		cairo:SetSourceRGBA(color:Unpack())
		cairo:Stroke()
	elseif input.IsKeyDown("mouse2") then
		draw_brush(pos, len, 30, vel)
		cairo:SetSourceRGBA(0,0,0,1)
		cairo:Stroke()
	end

	cairo:Flush()
	cairo:UpdateTexture(cairo.tex)
	cairo:MarkDirty()
	  
	graphics.DrawTexture(cairo.tex, Rect(0, 0, W, H), Color(1,1,1,0.9))
	
	last_pos = pos
end

hook.Add("PostDrawMenu", 1, function()
	draw()
end)

util.MonitorFileInclude()