if CLIENT then
	message.Hook("networked_props", function(ent, px,py,pz, ax,ay,az)--, vx,vy,vz)
		if not ent:IsValid() then return end
		local phys = ent:GetPhysics()
		if phys:IsValid() then
			
			local pos = Vec3(px, py, pz)
			local ang = Ang3(ax, ay, az)
			--local vel = Vec3(vx, vy, vz)
			
			if ent:GetClass() == "Player" then
				ent:SetPos(pos)
				ent:SetAngles(ang)
				ent:SetVelocity(vel)
			else
				
				phys:Wake()
				
				ent.net_pos = pos
				ent.net_ang = ang
				
				ent.net_spos = ent.net_spos or Vec3()
				ent.net_sang = ent.net_sang or Ang3()
				--ent.net_vel = vel
			end
		end 
	end)
	
	hook.Add("PostGameUpdate", "prop_networked", function()
		for key, ent in pairs(entities.GetAll()) do
			if ent:GetClass() == "PropNetworked" then-- or ent:GetClass() == "Player" then
				local phys = ent:GetPhysics()
				
				if ent.net_pos and phys:IsValid() then
					local delta = FrameTime() * 25
					local vel = (ent.net_pos - ent.net_spos) * delta
					ent.net_spos = ent.net_spos + (vel)
					ent.net_sang = ent.net_sang + ((ent.net_ang - ent.net_sang):GetNormalized() * delta)
				
					ent:SetPos(ent.net_spos)
					ent:SetAngles(ent.net_sang)
					phys:AddVelocity(vel*100)
				end
			end
		end
	end)
end

if SERVER then
	local S = function(num)
		return math.round(num, 5)
	end

	hook.Add("PostGameUpdate", "prop_networked", function()
		for key, ent in pairs(entities.GetAll()) do
		
			if ent:GetClass() == "PropNetworked" then-- or ent:GetClass() == "Player" then
				
				local phys = ent:GetPhysics() or NULL
				
				if phys:IsValid() and (true or not ent.last_pos or ent.last_pos:Distance(phys:GetPos()) > 0.1) then
					local pos = ent:GetPos()
					local ang = ent:GetAngles()
					local vel = phys:GetVelocity()
					
					phys:Wake()
					
					message.UDP = true
					
					message.Send("networked_props", nil, ent, 
						S(pos.x), S(pos.y), S(pos.z), 
						S(ang.x), S(ang.y), S(ang.z)--,
						--S(vel.x), S(vel.y), S(vel.z)
					)
					
					message.UDP = false
					
					ent.last_pos = phys:GetPos()
				end
			end
			
		end
	end)
	
	function NOW(pos)
		for i=1, 10 do
			for key, ent in pairs(entities.FindByClass("PropNetworked")) do
				ent:Remove()
			end
			
			timer.Simple(0.1, function()
				local ent = entities.Create("PropNetworked")
				ent:Spawn()
				ent:SetPos(pos + Vec3(0,0,i*5))
				ent:SetModel("objects/props/storage/crates/palette_box.cgf")
				local phys = ent:PhysicalizeEx(PE_RIGID)
				phys:Wake()
			end)
		end
	end
end

util.MonitorFileInclude()