graphics = {}

function graphics.Set2DFlags()
	render.SetState(
		bit.bor(
			GS_BLSRC_SRCALPHA,
			GS_BLDST_ONEMINUSSRCALPHA,
			GS_NODEPTHTEST
		)
	)
end

local white

function graphics.DrawFilledRect(rect, color, ...)
	white = white or Texture("defaults/white.dds"):GetId() -- ugh

	color = color or Color(1,1,1,1)
	if color.a <= 0 then return end

	graphics.Set2DFlags()
	
	surface.SetColor(color)
	surface.SetTexture(white)
	surface.DrawTexturedRect(rect.x, rect.y, rect.w, rect.h, ...)
end

local corner

local draw_textured_rect = function(x,y,w,h)
	x = x-0.1
	y = y-0.1
	w = w-0.1
	h = h-0.1
	surface.DrawTexturedRect(x,y,w,h)
end

function graphics.DrawRoundedOutlinedRect(rect, size, color, tl, tr, bl, br)
	corner = corner or Texture("gui/corner.dds"):GetId()
	
	if color.a <= 0 then return end

	tl = tl == nil and true or tp
	tr = tr == nil and true or tr
	bl = bl == nil and true or bl
	br = br == nil and true or br

	graphics.DrawFilledRect(Rect(rect.x + size, rect.y, rect.w - size * 2, size), color)
	graphics.DrawFilledRect(Rect(rect.x + size, rect.y + rect.h, rect.w - size * 2, -size), color)

	graphics.DrawFilledRect(Rect(rect.x, rect.y + size, size, rect.h - size * 2), color)
	graphics.DrawFilledRect(Rect(rect.x + rect.w, rect.y + size, -size, rect.h - size * 2), color)

	rect = rect:Copy():Shrink(size * 0.5)

	surface.SetColor(color)
	surface.SetTexture(tl and corner or white)
	
	draw_textured_rect(
		rect.x - size * 0.5,
		rect.y - size * 0.5,

		size,
		size
	)

	surface.SetTexture(tr and corner or white)
	draw_textured_rect(
		rect.x + rect.w + size * 0.5,
		rect.y + rect.h + size * 0.5,

		-size,
		-size
	)

	surface.SetTexture(bl and corner or white)
	draw_textured_rect(
		rect.x + rect.w + size * 0.5,
		rect.y - size * 0.5,

		-size,
		size
	)

	surface.SetTexture(br and corner or white)
	draw_textured_rect(
		rect.x - size * 0.5,
		rect.y + rect.h + size * 0.5,

		size,
		-size
	)
end

function graphics.DrawOutlinedRect(rect, size, color)
	if color.a <= 0 then return end

	graphics.DrawFilledRect(Rect(rect.x, rect.y, rect.w, size), color)
	graphics.DrawFilledRect(Rect(rect.x, rect.y + rect.h, rect.w, -size), color)

	graphics.DrawFilledRect(Rect(rect.x, rect.y + size, size, rect.h - size * 2), color)
	graphics.DrawFilledRect(Rect(rect.x + rect.w, rect.y + size, -size, rect.h - size * 2), color)
end


function graphics.DrawRoundedRect(rect, size, color, tl, tr, bl, br)
	if color.a <= 0 then return end
	graphics.DrawFilledRect(rect:Copy():Shrink(size), color)
	graphics.DrawRoundedOutlinedRect(rect, size, color, tl, tr, bl, br)
end

function graphics.DrawRect(rect, color, roundness, border_size, border_color, shadow_distance, shadow_color, tl, tr, bl, br)	
	color = color or Color(1,1,1,1)
	roundness = roundness or 0
	border_size = border_size or 0
	border_color = border_color or Color(1,1,1,1)
	shadow_distance = shadow_distance or Vec2(0, 0)
	shadow_color = shadow_color or Color(0,0,0,0.2)

	if roundness > 0 then
		if shadow_distance ~= Vec2(0,0) then
			graphics.DrawRoundedRect(rect + Rect(shadow_distance, Vec2()), roundness, shadow_color, tl, tr, bl, br)
		end
		if border_size > 0 then
			graphics.DrawRoundedRect(rect, roundness, border_color, tl, tr, bl, br)
			graphics.DrawRoundedRect(rect:Shrink(border_size), roundness, color, tl, tr, bl, br)
		else
			graphics.DrawRoundedRect(rect, roundness, color, tl, tr, bl, br)
		end
	else
		if shadow_distance ~= Vec2(0,0) then
			graphics.DrawFilledRect(rect + Rect(shadow_distance, Vec2()), shadow_color)
		end
		if border_size > 0 then
			graphics.DrawOutlinedRect(rect, border_size, border_color)
			graphics.DrawFilledRect(rect:Shrink(border_size), color)
		else
			graphics.DrawFilledRect(rect, color)
		end
	end
end

local fonts = {}

TEXT_ALIGN_CENTER = Vec2(0.5,0.5)

local function DrawText(text, pos, font, size, color, align_normal)
	fonts = fonts or {default = Font("tahoma.ttf")} -- ugh

	font = font or "default"
	size = size or Vec2() + 12
	color = color or Color(1,1,1,1)
	align_normal = align_normal or Vec2(0,0)
	
	fonts[font] = fonts[font] or Font(font)

	surface.SetFont(fonts[font])
	surface.SetColor(color)

	if type(size) == "number" then
		size = Vec2() + size
	end
	
	local scale = graphics.GetTextSize(font, text) * size
	local w, h = surface.GetTextSize(fonts[font], text)
	
	pos = pos:Copy()
	
	pos.y = pos.y - h*size.h*0.25
	
	pos = pos + (align_normal * scale)
			
	surface.DrawText(text, pos.x, pos.y, size / Vec2(render.GetScreenScale()) * 1.75, nil, nil, 2)
end

function graphics.GetTextSize(font, text)
	font = font or "default"
	text = text or "W"

	fonts[font] = fonts[font] or Font(font)
	local fnt = fonts[font]

	if not fnt then
		return Vec2(1,1)
	end

	if not fnt.scale or not fnt.scale[text] then
		fnt.scale = fnt.scale or {}
		fnt.scale[text] = Vec2(surface.GetTextSize(fonts[font], text, 0)) * Vec2(1, 0.75)
	end

	return fonts[font].scale[text] / Vec2(render.GetScreenScale()) * 1.75
end

function graphics.DrawText(text, pos, font, scale, color, align_normal, shadow_dir, shadow_color, shadow_blur, shadow_size)
	graphics.Set2DFlags()

	if shadow_dir then
		if shadow_blur and shadow_blur ~= 0 then
			shadow_size = shadow_size or Vec2(1,1) 
			
			for i = 1, shadow_blur do
				 
				local alpha_0_1 = (i/shadow_blur)
				local alpha_1_0 = -(i/shadow_blur)+1
				
				local col = shadow_color:Copy()
				col.a = math.clamp(col.a * alpha_1_0 ^ 2.5, 0.004, 1) -- when the alpha is below 0.004 the text becomes white. fix this!
						
				local scale = ((Vec2() + scale) * shadow_size) / graphics.GetTextSize(font, text).h * (alpha_0_1 + 1) ^ 2
						
				DrawText(
					text, 
					pos, 
					font, 
					scale,
					col, 
					align_normal + ((shadow_dir / scale) * alpha_0_1)
				)
			end
		else
			DrawText(text, pos + shadow_dir, font, scale, shadow_color, align_normal)
		end
	end
	
	DrawText(text, pos, font, scale, color, align_normal)
end

function graphics.CreateTexture(path, rect)

	-- since textures are cached internally we
	-- get the same pointer and texture id if
	-- we try to create a new texture with the
	-- same path.

	-- this is a problem if we want to store
	-- uv coordinates in the texture's table

	local tex = util.UserDataToTable(Texture(path))

	tex.uv = {(rect or Rect(0,0,1,1)):GetUV8(Vec2(tex:GetSize()))}

	return tex
end

function graphics.DrawTexture(tex, rect, color, uv, nofilter)
	graphics.Set2DFlags()

	if type(tex) ~= "number" then
		uv = tex.uv
		tex = tex:GetId()
	end

	if not uv then
		uv = {Rect(0,0,1,1):GetUV8(Vec2(1,1))}
	end
	
	surface.SetColor(color or Color(1,1,1,1))
	surface.SetTexture(tex)

	surface.DrawTexturedRectEx(
		rect.x,
		rect.y,
		rect.w,
		rect.h,

		nofilter,

		unpack(uv)
	)
end

function graphics.DrawLine(a,b, color)
	surface.SetColor(color or Color(1,1,1,1))	
	surface.DrawLine(a.x, a.y, b.x, b.y)
end

function graphics.GetScreenSize()
	return Vec2(render.GetScreenSize())
end

util.MonitorFileInclude()