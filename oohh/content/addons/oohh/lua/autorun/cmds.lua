console.RunString("log_verbosity -1", true)
console.RunString(
	[[
	r_DisplayInfo 0
	s_MusicVolume 0
	r_stereodevice 0
	sys_asserts 0

	net_disconnect_on_rmi_error 0
	net_automigrate_host 0
	net_migrate_timeout 30
	

	g_godMode 1
	g_inventoryNoLimits 1
	sys_maxfps 0
	g_forceFastUpdate 1
	g_deathcam 0
	g_battleDust_enable 1
	g_friendlyfireratio 0
	g_useProfile 0
	es_MaxPhysDist 10000
	es_MaxImpulseAdjMass 10000
	p_max_player_velocity 100000
	p_max_velocity 100000
	p_players_can_break 1
	net_packetsendrate 0
	sv_packetRate 1
	cl_packetRate 1
	net_breakage_sync_entities 1
	
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