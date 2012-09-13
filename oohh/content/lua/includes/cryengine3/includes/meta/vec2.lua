local META = util.FindMetaTable("vec2")

META.__old_index = META.__old_index or META.__index
function META.__index(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	end
	return META.__old_index(self, key, ...)
end

META.__old_newindex = META.__old_newindex or META.__newindex
function META.__newindex(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	end
	return META.__old_newindex(self, key, ...)
end

--[[
Give this function the coordinates of a pixel on your screen, and it will return a unit vector pointing
in the direction that the camera would project that pixel in.

Useful for converting mouse positions to aim vectors for traces.

iScreenX is the x position of your cursor on the screen, in pixels.
iScreenY is the y position of your cursor on the screen, in pixels.
iScreenW is the width of the screen, in pixels.
iScreenH is the height of the screen, in pixels.
angCamRot is the angle your camera is at
fFoV is the Field of View (FOV) of your camera in ___radians___
    Note: This must be nonzero or you will get a divide by zero error.
 ]]
function META:ToWorld(w, h, ang, fov)
	local ply = entities.GetLocalPlayer()
	local _w, _h = render.GetScreenSize()
	
	w = w or _w
	h = h or _h
	ang = ang or ply:GetEyeAngles()
	fov = fov or math.rad(90) -- ???
	
    --This code works by basically treating the camera like a frustrum of a pyramid.
    --We slice this frustrum at a distance "d" from the camera, where the slice will be a rectangle whose width equals the "4:3" width corresponding to the given screen height.
    local d = 4 * h / (6 * math.tan(0.5 * fov))

    --Forward, right, and up vectors (need these to convert from local to world coordinates
    local fwd = ang:GetForward()
    local rgt = ang:GetRight()
    local upw = ang:GetUp()

    --Then convert vec to proper world coordinates and return it
	local dir = (fwd * d) + (rgt * (self.x - 0.5 * w)) + (upw * (0.5 * h - self.y))
	dir:Normalize()
    return dir
end
