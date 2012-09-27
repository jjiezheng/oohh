-- health...

timer.Create("health_fix", 0.25, 0, function()
	for key, ply in pairs(entities.GetAllPlayers()) do
		if ply:GetHealth() == 0 then
			ply:SetHealth(-1)
		end
	end
end)