for key, ent in pairs(entities.FindByClass("boid")) do
	if ent:GetModel():FindSimple("rooster") then
		local phys = ent:GetPhysics()
		if phys then
			phys:SetVelocity(Vec3(0,0,100))
		end
	end
end