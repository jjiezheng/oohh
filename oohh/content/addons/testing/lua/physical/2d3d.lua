local tex = Texture("aahh/c.dds"):GetId()
local origin = entities.GetLocalPlayer():GetEyeTrace().HitPos

hook.Add("DrawHUD", 1, function()
	
	local pos, z = render.WorldToScreen(origin)
	
	print(pos, z)
	
	graphics.Set2DFlags()
	surface.SetTexture(tex)
	surface.SetColor(Color(1,1,1,1))
	
	surface.DrawTexturedRectEx(
		pos.x, pos.y, 
		100, 100
	)

end)