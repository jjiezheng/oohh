sigh.AddType(
	"vec3",
	function(var)
		return
			"\6" ..
			","	.. var.x ..
			"," .. var.y ..
			"," .. var.z ..
			sigh.END
	end,
	function(var)
		local x, y, z = var:match(",(.-),(.-),(.+)")
		return Vec3(tonumber(x), tonumber(y), tonumber(z))
	end
)

sigh.AddType(
	"ang3",
	function(var)
		return
			"\7" ..
			","	.. var.x ..
			"," .. var.y ..
			"," .. var.z ..
			sigh.END
	end,
	function(var)
		local p, y, r = var:match(",(.-),(.-),(.+)")
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
	"physics",
	function(var)
		return "\9" .. var:GetEntity():GetId() .. sigh.END
	end,
	function(var)
		return entities.GetById(tonumber(var)):GetPhysics()
	end
)

sigh.AddType(
	"vec2",
	function(var)
		return
			"\10" ..	var.x ..
			"\10" ..	var.y ..
			sigh.END
	end,
	function(var)
		local x, y = var:match("\9(.-)\9(.-)")
		return Vec2(tonumber(x), tonumber(y))
	end
)

