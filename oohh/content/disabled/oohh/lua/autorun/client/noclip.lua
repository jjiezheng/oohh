concommand.Add("noclip", function(ply, line)
	if ply.last_fly_mode then
		ply:SetFlyMode(0)
		ply.last_fly_mode = false
	else
		ply:SetFlyMode(2)
		ply.last_fly_mode = true
	end
end)