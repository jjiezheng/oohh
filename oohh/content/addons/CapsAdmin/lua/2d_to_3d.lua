-- x = right
-- -y = forward
-- -z = up

-- angles are relative to view origin

local target_ang = Ang3(0.5, 0, 0)
local target_pos = Vec3(0, -10, -5)
hook.Add("PostHUDUpdate", "2d3d", function()
	--entities.GetLocalPlayer():SetEyeAngles(Ang3(0,0,0))
	
	local cam = render.GetCamera()
	
	local cam_ang = cam:GetAngles()
	local cam_pos = cam:GetPos()
	
	local pos = Vec3()
	pos = pos + target_ang:GetRight() * target_pos.x
	pos = pos + target_ang:GetForward() * target_pos.y
	pos = pos + target_ang:GetUp() * target_pos.z
	
	local ang = Ang3()
	ang = target_ang
	
	ang.p = ang.p + 0.01
	
	cam:SetAngles(ang)
	cam:SetPos(pos)
	
	graphics.Set2DFlags()
	render.SetCamera(cam)
	--graphics.DisableFlags(true)
		--render.SetState(bit.bor(GS_BLSRC_SRCALPHA, GS_BLDST_ONEMINUSSRCALPHA, GS_DEPTHWRITE))
		--graphics.DrawRect(Rect(-5,-5,10,10), Color(0,0,0,1))
		graphics.DrawText("hahdUAHSudhASHDas", Vec2(-5,-5), nil, 100)
	--graphics.DisableFlags(false)
end)

util.MonitorFileInclude()