hook.Add("PostGameUpdate", "2d3d", function()
	local cam = render.GetCamera()
	
	local mat = cam:GetMatrix()
	render.MakeMatrix(Vec3Rand(), Ang3Rand(), Vec3(1,1,1), Matrix34())
	render.PushMatrix()
	
	
	graphics.Set2DFlags()
		--graphics.DisableFlags(true)
			--render.SetState(bit.bor(GS_BLSRC_SRCALPHA, GS_BLDST_ONEMINUSSRCALPHA, GS_DEPTHWRITE))
			graphics.DrawRect(Rect(0,0,10,10))
		--graphics.DisableFlags(false)
		
	render.PopMatrix()
end)

util.MonitorFileInclude()