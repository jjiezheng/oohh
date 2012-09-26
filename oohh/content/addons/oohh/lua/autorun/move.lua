local function calc_wall(ply, velocity)
	local normalized = velocity:GetNormalized()
	local res = physics.TraceDir(ply:GetPos() + Vec3(0,0,0.5), (normalized*math.max(velocity:GetLength()/2, 5)), ply)

	if not ply:IsOnGround() and res.Hit and math.isvalid(res.HitNormal.z) and math.abs(res.HitNormal.z) < 0.7 then
		local direction = velocity - 2 * (res.HitNormal:GetDot(velocity) * res.HitNormal)

		local fraction = math.min(velocity:GetLength() / 1000, 1)

		return direction * 1.25
	end
end

local function calc_bhop(ply, vel)
	vel.x = vel.x * 1.25
	vel.y = vel.y * 1.25

	local eye = math.clamp(-math.deg(ply:GetViewRotation():GetAng3().p)/90, 0, 1) ^ 3

	if eye > 0.3 then
		vel:Lerp(eye, Vec3(0.5, 0.5, 1) * vel + Vec3(0, 0, vel:GetLength() * 0.4))
	end
	
	return vel
end

local slope = math.rad(45)

local function calc_sliding(phys)
	local z = physics.TraceDir(phys:GetPos(), Vec3(0,0,-1), phys).HitNormal.z
			
	if math.isvalid(z) then
		local ang = math.abs(z) 
		if ang < slope then
			return phys:GetVelocity() + (physics.GetGravity() * 0.1)
		end
	end		
end

local params = 
{
	kAirControl = 1,
	kAirResistance = 0,
}

hook.Add("ProcessPlayerGroundMove", "move", function(ply)
    if typex(ply) ~= "player" or not ply:IsAlive() then
	return end
	
	local phys = ply:GetPhysics()
	
	if SERVER and ply == entities.GetLocalPlayer() then
		return Vec3(), 1
	end
	
	--ply:SetPlayerDynamics(params)
	
	local vel = calc_sliding(phys)
	if vel then return vel end
	local ground = ply:IsOnGround()
	if ground then
			
		local dir = Vec3(0,0,0)
		local ang = Ang3(ply:GetEyeAngles():Unpack())
		
		ply.move_vel = ply.move_vel or Vec3(0,0,0)

		ang.p = 0

		if ply:IsActionDown("moveforward") then
			dir = dir + ang:GetForward()
		elseif ply:IsActionDown("moveback") then
			dir = dir - ang:GetForward()
		end

		if ply:IsActionDown("moveright") then
			dir = dir + ang:GetRight()
		elseif ply:IsActionDown("moveleft") then
			dir = dir - ang:GetRight()
		end
		
		dir = dir:Normalize()
		if dir:GetLength() > 0 then
			ply.move_vel = dir * 6			
						
			if ply:IsActionDown("sprint") then
				ply.move_vel = dir * 10
			end 
		end
		
		if ply.jumped then
			calc_bhop(ply, ply.move_vel)
			ply.jumped = false
			return ply.move_vel + ang:GetUp() * 4, 6
		end
		 
		ply.move_vel = ply.move_vel * math.clamp(FrameTime() * 100, 0.5, 0.925)
	
		return ply.move_vel
	end
end)

hook.Add("PlayerActionEvent", "gmod_move", function(ply, key, press)
    if ply == entities.GetLocalPlayer() and SERVER then return end

	if press and key == "jump" and ply:IsOnGround() then
		ply.jumped = true
    end
end)

hook.Add("PlayerPreViewProcess", "view", function(ply, pos, rot, fov)
    if ply == entities.GetLocalPlayer() and SERVER then return end
	
	if ply:IsThirdPerson() or ply:GetParent():IsValid() then
		return
	end
	
	return ply:GetEyePos(), ply:GetViewRotation(), fov + math.rad(15)
end)


util.MonitorFileInclude()











do return end

local function calc(ply)
    if typex(ply) ~= "player" or ply == entities.GetLocalPlayer() and SERVER then return end
	
	do 
		local phys = ply:GetPhysics()
		
		local z = physics.TraceDir(phys:GetPos(), Vec3(0,0,-1), phys).HitNormal.z
				
		if math.isvalid(z) then
			local ang = math.abs(z) 

			if ang < 0.7 then
				return phys:GetVelocity() + (physics.GetGravity() * 0.1)
			end
		end
		
	end
	
	ply.move_vel = ply.move_vel or Vec3(0,0,0)

    local dir = Vec3(0,0,0)
	local ang = Ang3(ply:GetEyeAngles():Unpack())
	ang.p = 0

    if ply:IsActionDown("moveforward") then
		dir = dir + ang:GetForward()
	elseif ply:IsActionDown("moveback") then
		dir = dir - ang:GetForward()
	end

	if ply:IsActionDown("moveright") then
		dir = dir + ang:GetRight()
	elseif ply:IsActionDown("moveleft") then
		dir = dir - ang:GetRight()
	end

	local phys = ply:GetPhysics()

	dir = dir:Normalize()
	if dir:GetLength() > 0 then
		ply.move_vel = dir * 5
	end

	if ply:IsOnGround() then
		if ply:IsActionDown("sprint") then
			ply.move_vel = dir * 10
		end
		ply.move_vel = ply.move_vel * 0.7
	end

	if ply.jumped then
		local vel = Vec3(phys:GetVelocity():Unpack())
		vel.z = 4.4
		vel = calc_bhop(ply, vel)
		ply.jumped = false
		return vel, 6
	end
			
    return ply.move_vel, 1
end

hook.Add("ProcessPlayerGroundMove", "gmod_move", function(...)
	local vel, num = calc(...)
	if vel then
		if math.isvalid(vel.x) and math.isvalid(vel.y) and math.isvalid(vel.z) then
			local delta = FrameTime() * 150
			return vel, num
		else
			print(vel, num)
		end
	end
end)

