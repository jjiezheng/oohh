hook.Add("PostGameUpdate", 1, function()
	for key, phys in pairs(entities.GetAllPhysics()) do
		phys:AddVelocity((me:GetPos() - phys:GetPos()) * 100)
	end
end)