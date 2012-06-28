function math.round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function math.randomf(min, max)
	min = min or -1
	max = max or 1
	return min + (math.random() * (max-min))
end

function math.clamp(number, min, max)
	return math.max(math.min(number,max),min)
end

function math.lerp(m, a, b)
	return a + (b - a) * m
end