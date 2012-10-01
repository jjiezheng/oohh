util.MonitorFileInclude()

local texture

for k, tex in pairs(textures.FindByName("grass")) do
	if tex:GetName():find("grass_mix") then
		texture = tex
	end
end

print(texture:GetName())

local img = texture:GetPixelTable(true)
for i = 0, texture:GetLength() do
	img[i].r = CurTime()*i%255
	img[i].g = (math.sin((i*CurTime())/10000)*1000)%255
	img[i].b = math.cos(i*255)%255
	img[i].a = 90
end
texture:SetPixelTable(img)	
