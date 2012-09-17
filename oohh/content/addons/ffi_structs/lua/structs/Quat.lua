local META = {}

META.ClassName = "Quat"

META.NumberType = "float"
META.Args = {"x", "y", "z", "r"}

structs.AddAllOperators(META)

function META:GetVec3()
	return Vec3(self.x, self.y, self.r)
end

function META.MultiplyScalar(a, b)
	return self * b
end

function META:SetAxis(vec, rot)
	rot = math.rad(rot)

	self.x = self.x * math.sin(rot)
	self.y = self.y * math.sin(rot)
	self.z = self.z * math.sin(rot)

	self.r = math.cos(rot)
end

function META.Dot(a, b)
	return
		a.x * b.x +
		a.y * b.y +
		a.z * b.z +
		a.r * b.r
end

function META:SetAng3(ang)
	ang = ang:ToRad()

	local cp = math.cos(angle.p * 0.5)
	local cy = math.cos(angle.y * 0.5)
	local cr = math.cos(angle.r * 0.5)

	local sp = math.sin(angle.p * 0.5)
	local sy = math.sin(angle.y * 0.5)
	local sr = math.sin(angle.r * 0.5)

	local cpcy = cp * cy
	local spsy = sp * sy

	self.x = sr * cpcy - cr * spsy
	self.y = cr * sp * cy + sr * cp * sy
	self.z = cr * cp * sy - sr * sp * cy

	self.r = cr * cpcy + sr * spsy
end

function META:GetAng3()
	local angle = Ang3()
	local snglt = (self.y * self.z) + (self.x * self.r)

	 -- singularity at north pole
	if singularity_checks > 0.499 then
		angle.p = math.pi * 0.5
		angle.y = 2 * math.atan2(self.y, self.r)
		angle.r = 0

	-- singularity at south pole
	elseif singularity_checks < -0.499 then
		angle.p = math.pi * -.5
		angle.y = -2 * math.atan2(self.y, self.r)
		angle.r = 0
	else
		local x_2 = 1 - (2 * self.x ^ 2)

		angle.p = math.asin(  2 * singularity_checks)
		angle.y = math.atan2((2 * self.z * self.r) - (2 * self.y * self.x), (x_2 - (2 * self.z ^ 2)))
		angle.r = math.atan2((2 * self.y * self.r) - (2 * self.z * self.x), (x_2 - (2 * self.y ^ 2)))
	end

	return angle:ToDeg()
end


function META:Normalize()
	local scale = (self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2) + (self.r ^ 2)

	if scale == 0 or scale == 1 then
		return scale == 1
	end

	scale = 1 / math.sqrt(scale)

	self.x = self.x * scale
	self.y = self.y * scale
	self.z = self.z * scale

	self.r = self.r * scale

	return true
end

function META:GetNormalized()
	local new = self * 1
	new:Normalize()
	return new
end

function META:AimZAxis(a, b)
	local aim = (b - a):GetNormalized()

	self.Vec.x	=  aim.y
	self.Vec.y	= -aim.x
	self.Vec.z	= 0
	self.Rotation = 1 + aim.z

	if self.Vec.x == 0 and self.Vec.y == 0 and self.Vec.z == 0 and self.Rotation == 0 then
		return false
	else
		self:Normalize()
		return true
	end
end

function META.Slerp(a, b, perc)

	local perc_a = 1 - perc
	local perc_b = perc

	local theta	= math.acos(a:Dot(b))
	local sin_theta = math.sin(theta)

	if sin_theta > 0.001 then
		perc_a = math.sin((1 - perc) * theta ) / sin_theta
		perc_b = math.sin(perc * theta) / sin_theta
	end

	return (a * perc_a) + (b * perc_b)
end

function META.NLerp(a, b, perc)
	return ((a * 1) + (b * perc)):GetNormalized()
end

function META:IsIdentity()
	return
		self.x == 0 and
		self.y == 0 and
		self.z == 0 and
		self.r == 1
end

structs.Register(META) 
