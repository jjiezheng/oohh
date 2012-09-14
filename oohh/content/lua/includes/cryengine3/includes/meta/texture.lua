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
	return w*h
end

function META:Clear(color)
	local length = self:GetLength()
	local r,g,b,a = (color*255):Unpack()
	
	local img = ffi.new("rgba_pixel[?]", length)
	for i = 0, length-1 do
		img[i].r = r or 0
		img[i].g = g or 0
		img[i].b = b or 0
		img[i].a = a or 0
	end
end