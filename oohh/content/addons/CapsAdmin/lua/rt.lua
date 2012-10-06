local rt = util.RemoveOldObject(Texture(512, 512, FT_USAGE_RENDERTARGET))

-- this won't really do anything unless it's a normal texture
--[[
local img = rt:GetPixelTable(true)

for i = 0, rt:GetLength() do
	img[i].r = i%255
	img[i].g = (math.sin((i)/10000)*1000)%255
	img[i].b = math.cos(i*255)%255
	img[i].a = 90|
end

rt:SetPixelTable(img)]]

hook.Add("PostGameUpdate", "rt_test", function()
	render.EndFrame()
	render.RenderEnd()
	
		render.RenderBegin()			
			render.BeginFrame()		
			
				render.SetRenderTarget(rt, SRF_USE_ORIG_DEPTHBUF)
					
					-- draw a rect onto the RT texture
					graphics.DrawRect(Rect(0,0,10,10), Color(math.random(), math.random(), math.random(), 1))
					
				render.SetRenderTarget(nil, SRF_USE_ORIG_DEPTHBUF)
			
			render.EndFrame()
		render.RenderEnd()
	
	render.RenderBegin()			
	render.BeginFrame()		
	
	-- draw the results following our mouse pos
	local x,y = mouse.GetPos()
	graphics.DrawTexture(rt, Rect(x,y,256,256), Color(1,1,1,1))
end)

util.MonitorFileInclude()