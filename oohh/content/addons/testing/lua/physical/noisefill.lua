util.MonitorFileInclude()

local tex = FindTexture("beach")
local img = tex:GetPixelTable(true)
for i = 0, tex:GetLength() do
	img[i].r = i%255
	img[i].g = math.sin(i/10000)*1000%255
	img[i].b = math.cos(i*255)%255
	img[i].a = 255
end
tex:SetPixelTable(img)	

do return end

local i = 0
timer.Create("noise_tot", 0, 0, function() 
	for _i=1, 10 do
	
		i = i + 1
		print(i)
		local tex = Texture(i)
		if tex:GetFormat() == ETF_A8R8G8B8 or tex:GetFormat() == ETF_R8G8B8 then
			print("noising " .. tex:GetName()) 
			local img = tex:GetPixelTable(true)
			for i = 0, tex:GetLength() do
				img[i].r = math.random(255)
				img[i].g = math.random(255)
				img[i].b = math.random(255)
				img[i].a = math.random(255)
			end
			tex:SetPixelTable(img)		
		end
		
	end
end)
