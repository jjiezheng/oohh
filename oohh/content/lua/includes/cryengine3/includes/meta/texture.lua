local META = util.FindMetaTable("texture")

ffi.cdef("typedef struct { uint8_t r, g, b, a; } rgba_pixel;")

function META:GetPixelTable(new)
	return new and ffi.new("rgba_pixel[?]", self:GetLength()) or ffi.cast("rgba_pixel *", self:GetData())
end

function META:SetPixelTable(data)
	self:SetData(data)
end

function META:GetLength()
	local w,h = self:GetSize()
	return (w*h) * 4
end

function META:Clear(color)
	color = color or Color(0,0,0,0)
	local r,g,b,a = (color*255):Unpack()
		
	local img = self:GetPixelTable(true)
	
	for i = 0, self:GetLength()-1 do
		img[i].r = r or 0
		img[i].g = g or 0
		img[i].b = b or 0
		img[i].a = a or 0
	end
	
	self:SetPixelTable(img)
end

textures = textures or {}

local cache = {}

function textures.FindByName(name)
	local out = {}
	
	for i = 1, 10000 do
		local tex = Texture(i)
		if tex:IsValid() then
			local name = tex:GetName()
			if name ~= "EngineAssets/TextureMsg/ReplaceMe.tif" and name:find(name, nil, true) then
				table.insert(out, tex)
			end
		else
			print(i)
			break
		end
	end
		
	return out
end

util.MonitorFileInclude()