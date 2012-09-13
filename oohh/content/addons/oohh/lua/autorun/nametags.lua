hook.Add("PostDrawMenu", "3d2dtest", function()
	for key, ent in pairs(entities.GetAll()) do
		local wpos = ent.GetEyePos and ent:GetEyePos() or ent:GetPos()
		local pos, vis = wpos:ToScreen(nil, nil, nil, nil, math.rad(90))
		if vis > 0 then
			if ent.GetNickname then
				graphics.DrawText(ent:GetNickname(), pos)
			else
				--graphics.DrawText(ent:GetName(), pos)
			end
		end
	end
end)