local META = {}

META.ClassName = "Vec2"

META.NumberType = "float"
META.Args = {{"x", "w", "p"}, {"y", "h", "y"}}

structs.AddAllOperators(META) 

-- length stuff
do 
	function META:GetLengthSquared()
		return self.x * self.x + self.y * self.y
	end

	function META:SetLength(num)
		local scale = num * 1/math.sqrt(self:GetLengthSquared())
		
		self.x = self.x * scale
		self.y = self.y * scale
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
		end
	end
	
	function META.Distane(a, b)
		return (a - b):GetLength()
	end
end

function META.GetDot(a, b)
	return
		a.x * b.x +
		a.y * b.y
	end

function META:Normalize()
	local inverted_length = 1/math.sqrt(self:GetLengthSquared())
	
	self.x = self.x * inverted_length
	self.y = self.y * inverted_length
	
	return self
end

function META.GetCrossed(a, b)
	return a.x * b.y - a.y * b.x
end

function META:Rotate90CCW()
	local x, y = self:Unpack()

	self.x = -y
	self.y = x
	
	return self
end

function META:Rotate90CW()
	local x, y = self:Unpack()

	self.x = y
	self.y = -x
	
	return self
end

structs.AddGetFunc(META, "Normalize", "Normalized")

structs.Register(META)

