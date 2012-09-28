return 
{
	friendly = "ffi structs",
	description = "cryengine structs redefined in lua using ffi for speed",
	startup = "structs.lua",
	load = CRYENGINE3 ~= nil,	
	
	priority = math.huge,
}