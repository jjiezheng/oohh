local META = {}

META.ClassName = "Vec3"

META.NumberType = "float"
META.Args = {"x", "y", "z"}

structs.AddAllOperators(META) 

function META:GetLengthSquared()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

function META:SetLength(num)
	local scale = num * 1/math.sqrt(self:GetLengthSquared())
	
	self.x = self.x * scale
	self.y = self.y * scale
	self.z = self.z * scale
end

function META:GetLength()
	return math.sqrt(self:GetLengthSquared())
end

META.__len = META

function META.__lt(a, b)
	if typex(a) == META.Type and type(b) == "number" then
		return a:GetLength() < b
	elseif typex(b) == META.Type and type(a) == "number" then
		return b < a:GetLength()
	end
end

function META.__le(a, b)
	if typex(a) == META.Type and type(b) == "number" then
		return a:GetLength() <= b
	elseif typex(b) == META.Type and type(a) == "number" then
		return b <= a:GetLength()
	end
end

function META:Max(num)
	local length = self:GetLengthSquared()
	
	if length * length > num then
		local scale = num * 1/math.sqrt(length)
		
		self.x = self.x * scale
		self.y = self.y * scale
		self.z = self.z * scale
	end
end

function META:Abs()
	self.x = math.abs(self.x)
	self.y = math.abs(self.y)
	self.z = math.abs(self.z)
	
	return self
end

structs.AddGetFunc(META, "Abs")

function META.Cross(a, b)
	a = a.y * b.z - a.z * b.y
	a = a.z * b.x - a.x * b.z
	a = a.x * b.y - a.y * b.x
end

structs.AddGetFunc(META, "Cross")

function META.GetDot(a, b)
	return 
		a.x * b.x + 
		a.y * b.y +
		a.z * b.z 
end

function META:GetVolume()
	return self.x * self.y * self.z
end

structs.Register(META)