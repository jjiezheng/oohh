local W,H = render.GetScreenSize()
local length = W*H

ffi.cdef("typedef struct { uint8_t r, g, b, a; } rgba_pixel;")

local r = math.random
local rect = Rect(0, 0, W, H)
local tex = Texture(W, H, ETF_A8R8G8B8)
local img

if WEBTEX then
	img = ffi.cast("rgba_pixel *", WEBTEX:GetData())
else
	img = ffi.new("rgba_pixel[?]", length)
	for i = 0, length do
		img[i].r = r(255)
		img[i].g = r(255)
		img[i].b = r(255)
		img[i].a = r(255)
	end
end

tex:SetData(img)

hook.Add("PostDrawMenu", "draw_texture_noise", function()	
	graphics.Set2DFlags()
	graphics.DrawTexture(tex, rect, nil, nil, true)
end)

