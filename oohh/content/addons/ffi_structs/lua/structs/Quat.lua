local META = {}

META.ClassName = "META"

META.NumberType = "float"
META.Args = {"x", "y", "z", "r"}

structs.AddAllOperators(META)

if CAPSADMIN then

local cos = math.cos
local sin = math.sin
local acos = math.acos

local sqrt = math.sqrt
local exp = math.exp
local abs = math.abs
local Round = math.Round

local deg2rad = math.pi/180
local rad2deg = 180/math.pi

local validEntity = _R.Entity.IsValid
local Vector = Vector
local setmetatable = setmetatable

local quatmeta = {}

quat = setmetatable({}, quatmeta)
local quat = quat

function quat:__index(index)
	if index == "real" then return self[1] end
	if index == "imag" then return self[2] end

	if index == "i" then return self[2].x end
	if index == "j" then return self[2].y end
	if index == "k" then return self[2].z end

	return quat[index]
end

function quat:__setindex(index, value)
	if index == "real" then self[1] = value end
	if index == "imag" then self[2] = value end

	if index == "i" then self[2].x = value end
	if index == "j" then self[2].y = value end
	if index == "k" then self[2].z = value end
end

function quat:__tostring()
	local imag = self[2]

	local r = ""
	local i = ""
	local j = ""
	local k = ""

	if abs(self[1]) > 0.0005 then
		r = Round(self[1]*1000)/1000
	end
	local dbginfo = r
	--print("foo",next(imag,next(imag)))
	if abs(imag.x) > 0.0005 then
		i = tostring(Round(imag.x*1000)/1000)
		if string.sub(i,1,1)~="-" and dbginfo ~= "" then i = "+"..i end
		i = i .. "i"
	end
	dbginfo = dbginfo .. i
	if abs(imag.y) > 0.0005 then
		j = tostring(Round(imag.y*1000)/1000)
		if string.sub(j,1,1)~="-" and dbginfo ~= "" then j = "+"..j end
		j = j .. "j"
	end
	dbginfo = dbginfo .. j
	if abs(imag.z) > 0.0005 then
		k = tostring(Round(imag.z*1000)/1000)
		if string.sub(k,1,1)~="-" and dbginfo ~= "" then k = "+"..k end
		k = k .. "k"
	end
	dbginfo = dbginfo .. k
	if dbginfo == "" then dbginfo = "0" end
	return dbginfo
end


local function makequat(real, i, j, k)
	return setmetatable({ real, Vector(i, j, k) }, quat)
end

function quatmeta:__index(index)
	if index == "zero" then return setmetatable({ 0, Vector(0, 0, 0) }, quat) end

	if index == "i" then return setmetatable({ 0, Vector(1, 0, 0) }, quat) end
	if index == "j" then return setmetatable({ 0, Vector(0, 1, 0) }, quat) end
	if index == "k" then return setmetatable({ 0, Vector(0, 0, 1) }, quat) end
end

--[[************************************************************************]]--
-- helper functions

function quat:exp()
	local imag = self[2]
	local imaglen = imag:Length()
	return exp(self[1])*quaternion(cos(imaglen), imag*(sin(imaglen)/imaglen))
end
local qexp = quat.exp

function quat:log()
	local real, imag = self[1], self[2]
	local l = sqrt(real*real + imag.x*imag.x + imag.y*imag.y + imag.z*imag.z)
	if l == 0 then return makequat(-math.huge, 0, 0, 0) end
	local ureal, uimag = real/l, imag/l
	local a = acos(ureal)
	local m = uimag:Length()
	if abs(m) > delta then
		return setmetatable({ log(l), uimag * (a/m) }, quat)
	else
		return setmetatable({ log(l), Vector(0, 0, 0) }, quat)
	end
end
local qlog = quat.log

local function qmul(lhs, rhs)
	local real1, imag1 = lhs[1], lhs[2]
	local real2, imag2 = rhs[1], rhs[2]

	return setmetatable({
		real1*real2 - imag1:Dot(imag2),
		imag2*real1 + imag1*real2 + imag1:Cross(imag2)
	}, quat)
end

--[[************************************************************************]]--
-- constructors

local function quat_ang(ang)
	local p = ang.p*deg2rad*0.5
	local y = ang.y*deg2rad*0.5
	local r = ang.r*deg2rad*0.5

	local qr = { cos(r), Vector(sin(r), 0, 0) }
	local qp = { cos(p), Vector(0, sin(p), 0) }
	local qy = { cos(y), Vector(0, 0, sin(y)) }
	return qmul(qy,qmul(qp,qr))
end

local function quat_forward_up(forward, up)
	local x = forward[1]
	local z = up[1]
	local y = z:Cross(x):GetNormalized() --up x forward = left

	local ang = x:Angle()
	if ang.p > 180 then ang.p = ang.p - 360 end
	if ang.y > 180 then ang.y = ang.y - 360 end

	local yyaw = Vector(0, 1, 0)
	yyaw:Rotate(Angle(0, ang.y, 0)) -- TODO: replace by +/-yyaw:Right()

	local roll = acos(y:Dot(yyaw))*rad2deg

	local dot = y.z
	if dot < 0 then roll = -roll end

	local p, y, r = ang.p, ang.y, roll
	p = p*deg2rad*0.5
	y = y*deg2rad*0.5
	r = r*deg2rad*0.5
	local qr = { cos(r), Vector(sin(r), 0, 0) }
	local qp = { cos(p), Vector(0, sin(p), 0) }
	local qy = { cos(y), Vector(0, 0, sin(y)) }
	return qmul(qy, qmul(qp, qr))
end

function quatmeta:__call(a, b, c, d)
	local typea = type(a)

	if typea == "number" then
		if type(b) == "Vector" then
			return setmetatable({ a or 0, b }, quat)
		end

		return setmetatable({ a or 0, Vector(b or 0, c or 0, d or 0) }, quat)
	end

	if typea == "Vector" then
		if type(b) == "Vector" then
			return quat_forward_up(a, b)
		end
		return setmetatable({ 0, a }, quat)
	end

	if typea == "Angle" then
		return quat_ang(a)
	end

	if validEntity(a) then
		return quat_ang(a:GetAngles())
	end

	return zero
end

function rotation_quaternion(degrees, axis)
	local radians = degrees * deg2rad
	return setmetatable({
		cos(radians/2),
		axis:GetNormalized()*sin(radians/2)
	}, quat)
end

function META.__sub(a, b)
	if type(a) == "number" then
		return Quat(
			-b.x, 
			-b.y, 
			-b.z, 
			
			a.r - b.r
		)
	end

	if type(b) == "number" then		
		return Quat(
			a.x,
			a.y,
			a.z,
			
			a.r - b
		)
	end

	return Quat(
		a.x - b.x,
		a.y - b.y,
		a.z - b.z,
		a.r - b.r,
	)
end

function META.__mul(a, b)
	if type(a) == "number" then
		return Quat(
			a * b.x,
			a * b.y,
			a * b.z,
			
			a * b.r,
		)
	end

	if type(b) == "number" then
		return Quat(
			a.x * b,
			a.y * b,
			a.z * b,
			
			a.r * b,	
		)
	end
	
	local vec_a = Vec3(a.x, a.y, a.z)
	local vec_b = Vec3(b.x, b.y, b.z)
	local res = (vec_b * a.r) + (vec_a * b.r) + vec_a:Cross(vec_b)
	
	return Quat(
		res.x,
		res.y,
		res.z,
		
		(a.r * b.r) - vec_a:Dot(vec_b)
	)
end

function META.__div(a, b)
	if type(b) == "number" then
		return Quat(
			a.x / b,
			a.y / b,
			a.z / b,
			
			a.r / b,
		)
	end
	
	local real1, imag1 = a.r, Vec3(a.x, a.y, a.z)
	local real2, imag2 = b.r, Vec3(b.x, b.y, b.z)

	local l = real2*real2 + imag2.x*imag2.x + imag2.y*imag2.y + imag2.z*imag2.z
	real2 = real2 / l
	imag2 = imag2 / (-l)
	
	local res = imag2*real1 + imag1*real2 + imag1:Cross(imag2)
	
	return Quat(
		res.x,
		res.y,
		res.z,
		
		real1*real2 - imag1:Dot(imag2)
	)
end

-- CONTINUE HERE

function META.__pow(a, b)
	local l = qlog(a)
	return qexp({ l.r*b, l.vec*b })
end

function META:__len()
	local real, imag = self.r, self.vec
	return sqrt(real*real + imag.x*imag.x + imag.y*imag.y + imag.z*imag.z)
end
META.abs = META.__len
META.Length = META.__len

--[[************************************************************************]]--
-- functions

function META:conj()
	return setmetatable({ self.r, self.vec * (-1) }, META)
end

function META:inv()
	local real, imag = self.r, self.vec
	local l = real*real + imag.x*imag.x + imag.y*imag.y + imag.z*imag.z
	return setmetatable({ real / l, imag / (-l) }, META)
end

function META.slerp(q1, q2, t)
	return q1*(q1:inv()*q2)^t
end

function META:toAngle()
	local real, imag = self.r, self.vec

	local l = sqrt(real*real+imag.x*imag.x+imag.y*imag.y+imag.z*imag.z)
	local q1, q2, q3, q4 = real/l, imag.x/l, imag.y/l, imag.z/l

	local x = Vector(q1*q1 + q2*q2 - q3*q3 - q4*q4,
		2*q3*q2 + 2*q4*q1,
		2*q4*q2 - 2*q3*q1)

	local y = Vector(2*q2*q3 - 2*q4*q1,
		q1*q1 - q2*q2 + q3*q3 - q4*q4,
		2*q2*q1 + 2*q3*q4)

	local ang = x:Angle()
	if ang.p > 180 then ang.p = ang.p - 360 end
	if ang.y > 180 then ang.y = ang.y - 360 end

	local yyaw = Vector(0,1,0)
	yyaw:Rotate(Angle(0,ang.y,0)) -- TODO: replace by +/-yyaw:Right()

	local roll = acos(y:Dot(yyaw))*rad2deg

	local dot = q2*q1 + q3*q4
	if dot < 0 then roll = -roll end

	ang.r = roll

	return ang
end

function META:rotationAngleAndAxis()
	local real, imag = self.r, self.vec

	local m2 = imag.x * imag.x + imag.y * imag.y + imag.z * imag.z
	local l2 = real*real + m2

	local ang = 0
	if l2 ~= 0 then
		local l = sqrt(l2)
		ang = 2*acos(real/l)*rad2deg  --this returns angle from 0 to 360
		if ang > 180 then ang = ang - 360 end  --make it -180 - 180
	end

	if m2 == 0 then return ang, Vector(0, 0, 1) end -- TODO: check default
	local m = sqrt(m2)

	return ang, imag / m
end

function META:rotationVector()
	local m2 = imag.x * imag.x + imag.y * imag.y + imag.z * imag.z
	local l2 = real*real + m2

	if l2 == 0 or m2 == 0 then return Vector(0, 0, 0) end
	local s = 2 * acos(real/sqrt(l2)) * rad2deg
	if s > 180 then s = s - 360 end
	s = s / sqrt(m2)
	return imag * s
end

end

structs.Register(META) 
