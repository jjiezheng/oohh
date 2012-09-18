local META = {}

META.ClassName = "Vec3"

META.NumberType = "float"
META.Args = {"x", "y", "z"}

structs.AddAllOperators(META) 

-- length stuff
do 
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

	META.__len = META.GetLength

	function META.__lt(a, b)
		if typex(a) == META.Type and type(b) == "number" then
			return a:GetLength() < b
		elseif typex(b) == META.Type and type(a) == "number" then
			return b:GetLength() < a
		end
	end

	function META.__le(a, b)
		if typex(a) == META.Type and type(b) == "number" then
			return a:GetLength() <= b
		elseif typex(b) == META.Type and type(a) == "number" then
			return b:GetLength() <= a
		end
	end

	function META:SetMaxLength(num)
		local length = self:GetLengthSquared()
		
		if length * length > num then
			local scale = num * 1/math.sqrt(length)
			
			self.x = self.x * scale
			self.y = self.y * scale
			self.z = self.z * scale
		end
	end
	
	function META.Distane(a, b)
		return (a - b):GetLength()
	end
end

function META:Normalize()
	local inverted_length = 1/math.sqrt(self:GetLengthSquared())
	
	self.x = self.x * inverted_length
	self.y = self.y * inverted_length
	self.z = self.z * inverted_length
	
	return self
end

structs.AddGetFunc(META, "Normalize", "Normalized")

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

function META:GetAng3()
	local n = self:GetNormalized()
	
	local p = math.atan2(math.sqrt((n.x ^ 2) + (n.y ^ 2)), n.z)
	local y = math.atan2(self.y, self.x)
	
	return structs.Ang3(p,y,0)
end

structs.Register(META)