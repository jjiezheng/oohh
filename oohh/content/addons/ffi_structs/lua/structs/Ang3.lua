local META = {}

META.ClassName = "Ang3"

META.NumberType = "float"
META.Args = {{"p", "x", "pitch"}, {"y", "yaw"}, {"r", "z", "roll"}}

structs.AddAllOperators(META)

local sin = math.sin
local cos = math.cos

function META.GetRight(a)
	return Vec3(
		cos(a.z) * cos(a.y),
		sin(a.z) * cos(a.y),
	   -sin(a.y)
	)
end

function META.GetUp(a)
	return Vec3(
		sin(a.z) * sin(a.x) + cos(a.z) * sin(a.y) * cos(a.x),
	   -cos(a.z) * sin(a.x) + sin(a.z) * sin(a.y) * cos(a.x),
		cos(a.y) * cos(a.x)
	)
end

function META.GetForward(a)
	return Vec3(
	   -sin(a.z) * cos(a.x) + cos(a.z) * sin(a.y) * sin(a.x),
		cos(a.z) * cos(a.x) + sin(a.z) * sin(a.y) * sin(a.x),
		cos(a.y) * sin(a.x)
	)
end

local PI1 = math.pi
local PI2 = math.pi * 2
function META:Normalize()
	self.p = (self.p + PI1) % PI2 - PI1
	self.y = (self.y + PI1) % PI2 - PI1
	self.r = (self.r + PI1) % PI2 - PI1
	
	return self
end

structs.AddGetFunc(META, "Normalize", "Normalized")

function META.AngleDifference(a, b)
	a:Normalize(b)
	
	a.p = a.p < PI2 and a.p or a.p - PI2
	a.y = a.y < PI2 and a.y or a.y - PI2
	a.r = a.r < PI2 and a.r or a.r - PI2
	
	return a
end

structs.AddGetFunc(META, "AngleDifference")

function META:Rad()
	self.p = math.rad(self.p)
	self.y = math.rad(self.y)
	self.r = math.rad(self.r)
	
	return self
end

structs.AddGetFunc(META, "Rad")

function META:Deg()
	self.p = math.deg(self.p)
	self.y = math.deg(self.y)
	self.r = math.deg(self.r)
	
	return self
end

structs.AddGetFunc(META, "Deg")

structs.Register(META)