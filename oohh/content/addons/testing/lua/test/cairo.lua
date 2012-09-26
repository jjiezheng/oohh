local tex = Texture(64,64)
local cairo = Cairo(1280,768)
cairo:SetImage("image.png", x, y)
cairo:UpdateTexture(tex)