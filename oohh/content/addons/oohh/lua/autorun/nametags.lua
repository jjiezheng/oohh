local DISTANCE = 15
hook.Add("PostDrawMenu", "3d2dtest", function()
	for key, ent in pairs(entities.GetAll()) do
		if ent.GetNickname then
			local wpos = ent.GetEyePos and ent:GetEyePos() or ent:GetPos()
			wpos = wpos + Vec3(0,0,0.4)
			local dist = -(entities.GetLocalPlayer():GetEyePos() - wpos):GetLength() + DISTANCE
			dist = math.clamp(dist, 0, DISTANCE) / DISTANCE
			dist = dist ^ 2
			local pos, vis = wpos:ToScreen(nil, nil, nil, nil, math.rad(90))
			if vis > 0 and dist > 0 then
				graphics.DrawText(ent:GetNickname(), pos, nil, nil, Color(1,1,1, dist), Vec2(-0.5, 0, 0))
			end
		end
	end
end)