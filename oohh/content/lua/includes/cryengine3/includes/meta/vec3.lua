local META = util.FindMetaTable("vec3")

META.__old_index = META.__old_index or META.__index
function META.__index(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	elseif key == "r" then
		key = "z"
	end
	return META.__old_index(self, key, ...)
end

META.__old_newindex = META.__old_newindex or META.__newindex
function META.__newindex(self, key, ...)
	if key == "p" or key == "w" then
		key = "x"
	elseif key == "h" then
		key = "y"
	elseif key == "r" then
		key = "z"
	end
	return META.__old_newindex(self, key, ...)
end

--[[
Give this function a vector, pointing from the camera to a position in the world,
and it will return the coordinates of a pixel on your screen - this is where the world position would be projected onto your screen.

Useful for finding where things in the world are on your screen (if they are at all).

vDir is a direction vector pointing from the camera to a position in the world
iScreenW is the width of the screen, in pixels.
iScreenH is the height of the screen, in pixels.
angCamRot is the angle your camera is at
fFoV is the Field of View (FOV) of your camera in ___radians___
    Note: This must be nonzero or you will get a divide by zero error.

Returns x, y, iVisibility.
    x and y are screen coordinates.
    iVisibility will be:
        1 if the point is visible
        0 if the point is in front of the camera, but is not visible
        -1 if the point is behind the camera
]]
function META:ToScreen(dir, w, h, ang, fov)
	local ply = entities.GetLocalPlayer()
	local _w, _h = render.GetScreenSize()
	
	dir =  self:Copy() - ply:GetEyePos()
	dir:Normalize()
	
	w = w or _w
	h = h or _h
	ang = ang or ply:GetEyeAngles()
	fov = fov or math.rad(90) -- ????
	
    --Same as we did above, we found distance the camera to a rectangular slice of the camera's frustrum, whose width equals the "4:3" width corresponding to the given screen height.
    local d = 4 * h / (6 * math.tan(0.5 * fov))
    local fdp = ang:GetForward():Dot(dir)

    --fdp must be nonzero ( in other words, vDir must not be perpendicular to angCamRot:Forward() )
    --or we will get a divide by zero error when calculating vProj below.
    if fdp == 0 then
        return 0, 0, -1
    end

    --Using linear projection, project this vector onto the plane of the slice
    local proj = dir * (d / fdp)

    --Dotting the projected vector onto the right and up vectors gives us screen positions relative to the center of the screen.
    --We add half-widths / half-heights to these coordinates to give us screen positions relative to the upper-left corner of the screen.
    --We have to subtract from the "up" instead of adding, since screen coordinates decrease as they go upwards.
    local x = 0.5 * w + ang:GetRight():Dot(proj)
    local y = 0.5 * h - ang:GetUp():Dot(proj)

    --Lastly we have to ensure these screen positions are actually on the screen.
    local vis
	
	--Simple check to see if the object is in front of the camera
    if fdp < 0 then 
        vis = -1
    elseif x < 0 or x > w or y < 0 or y > h then  --We've already determined the object is in front of us, but it may be lurking just outside our field of vision.
        vis = 0
    else
        vis = 1
    end

    return Vec2(x, y), vis
end
