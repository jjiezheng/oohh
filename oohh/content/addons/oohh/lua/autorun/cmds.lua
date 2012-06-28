console.RunString("log_verbosity -1", true)
console.RunString(
	[[
	r_DisplayInfo 0
	s_MusicVolume 0
	r_stereodevice 0
	sys_asserts 0

	net_disconnect_on_rmi_error 0

	g_godMode 1
	g_inventoryNoLimits 1
	sys_maxfps 0
	]], 
	true -- this silence oh i will shut down the sounds
)
console.RunString("log_verbosity 5", true)
--[[ 
sys_flash 0 disables scaleform
net_maxpacketsize 10000
net_packetsendrate 0
sv_packetRate 0
]]

engine3d.PauseTOD(true)