local META = {}

META.ClassName = "Vec2" -- temp

META.FFIDef = "double x, y"
META.LuaDef = function(x,y) return {x=x or 0 ,y=y or 0} end

do -- standard
	function META:__tostring()
		return self.ClassName .. string.format("(%f, %f)", self.x, self.y)
	end

	function META:Unpack()
		return self.x, self.y
	end

	function META:Copy()
		return self * 1
	end

	function META.__eq(a,b)
		return
			a.x == b.x and
			a.y == b.y
	end

	function META.__add(a, b)
		if type(b) == "number" then
			return Vec2(
				a.x + b,
				a.y + b
			)
		elseif type(a) == "number" then
			return Vec2(
				a + b.x,
				a + b.y
			)
		else
			return Vec2(
				a.x + b.x,
				a.y + b.y
			)
		end
	end

	function META.__sub(a, b)
		if type(b) == "number" then
			return Vec2(
				a.x - b,
				a.y - b
			)
		elseif type(a) == "number" then
			return Vec2(
				a - b.x,
				a - b.y
			)
		else
			return Vec2(
				a.x - b.x,
				a.y - b.y
			)
		end
	end

	function META.__mul(a, b)
		if type(b) == "number" then
			return Vec2(
				a.x * b,
				a.y * b
			)
		elseif type(a) == "number" then
			return Vec2(
				a * b.x,
				a * b.y
			)
		else
			return Vec2(
				a.x * b.x,
				a.y * b.y
			)
		end
	end

	function META.__div(a, b)
		if type(b) == "number" then
			return Vec2(
				a.x / b,
				a.y / b
			)
		elseif type(a) == "number" then
			return Vec2(
				a / b.x,
				a / b.y
			)
		else
			return Vec2(
				a.x / b.x,
				a.y / b.y
			)
		end
	end

	function META.__pow(a, b)
		if type(b) == "number" then
			return Vec2(
				a.x ^ b,
				a.y ^ b
			)
		elseif type(a) == "number" then
			return Vec2(
				a ^ b.x,
				a ^ b.y
			)
		else
			return Vec2(
				a.x ^ b.x,
				a.y ^ b.y
			)
		end
	end

	function META.__unm(a)
		return Vec2(
			-a.x,
			-a.y
		)
	end
end

function META.GetLength(a)
	return math.sqrt(
		a.x * a.x +
		a.y * a.y
	)
end

function META.Distane(a, b)
	return (a - b):GetLength()
end

function META.GetDot(a, b)
	return
		a.x * b.x +
		a.y * b.y
	end

function META:GetNormalized()
	return self / self:GetLength()
end

structs.Register(META, true) -- change true to nil for ffi

