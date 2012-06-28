physics = physics or {}

function physics.TracePos(startpos, endpos, filter)
	if typex(filter) == "entity" then
		filter = filter:GetPhysics()
	end
	return physics.RayWorldIntersection(origin, endpos, ENT_ALL, RWI_STOP_AT_PIERCEABLE, filter)
end

function physics.TraceDir(startpos, direction, filter)
	if typex(filter) == "entity" then
		filter = filter:GetPhysics()
	end
	return physics.RayWorldIntersection(startpos, startpos+direction, ENT_ALL, RWI_STOP_AT_PIERCEABLE, filter)
end