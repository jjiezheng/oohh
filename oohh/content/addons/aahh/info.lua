-- unfinished GUI system (lacks controls, base control is more or less finished)

return
{
	friendly = "AAHH",
	description = "oohh's gui",
	startup = "aahh/init.lua",
	
	priority = math.huge,

	load = CRYENGINE3 ~= nil,
}