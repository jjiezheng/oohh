luadata.SetModifier("vec3", function(var)
	return ("Vec3(%s, %s, %s)"):format(var.x, var.y, var.z)
end)

luadata.SetModifier("vec2", function(var)
	return ("Vec2(%s, %s)"):format(var.x, var.y)
end)

luadata.SetModifier("ang3", function(var)
	return ("Ang3(%s, %s, %s)"):format(var.p, var.y, var.r)
end)