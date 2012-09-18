-- unfinished GUI system (lacks controls, base control is more or less finished)

return
{
	friendly = "AAHH",
	description = "oohh's gui",
	startup = "aahh/init.lua",
	
	priority = 10,

	load = CRYENGINE3 ~= nil,
}