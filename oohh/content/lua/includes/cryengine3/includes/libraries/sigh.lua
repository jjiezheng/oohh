sigh.AddType(
	"vec3",
	function(var)
		return
			"\6" ..	var.x ..
			"\6" ..	var.y ..
			"\6" ..	var.z ..
			sigh.END
	end,
	function(var)
		local x, y, z = var:match("\6(.-)\6(.-)\6(.+)")
		return Vec3(tonumber(x), tonumber(y), tonumber(z))

	end
)

sigh.AddType(
	"ang3",
	function(var)
		return
			"\7" ..	var.p ..
			"\7" ..	var.y ..
			"\7" ..	var.r ..
			sigh.END
	end,
	function(var)
		local p, y, r = var:match("\7(.-)\7(.-)\7(.+)")
		return Ang3(tonumber(p), tonumber(y), tonumber(r))
	end
)

sigh.AddType(
	"entity",
	function(var)
		return "\8" .. var:GetId() .. sigh.END
	end,
	function(var)
		return entities.GetById(tonumber(var))
	end
)

sigh.AddType(
	"vec2",
	function(var)
		return
			"\9" ..	var.x ..
			"\9" ..	var.y ..
			sigh.END
	end,
	function(var)
		local x, y = var:match("\9(.-)\9(.-)")
		return Vec2(tonumber(x), tonumber(y))
	end
)