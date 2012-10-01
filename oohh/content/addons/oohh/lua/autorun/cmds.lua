console.RunString("log_verbosity -1", true)
console.RunString(
	[[
	r_DisplayInfo 0
	r_stereodevice 0

	sys_asserts 0
	sys_maxfps 0
	sys_flash 0

	net_disconnect_on_rmi_error 0
	net_automigrate_host 0
	net_migrate_timeout 30	
	net_breakage_sync_entities 1

	g_godMode 1
	g_inventoryNoLimits 1
	g_forceFastUpdate 0
	g_deathcam 0
	g_battleDust_enable 1
	g_friendlyfireratio 0
	
	es_MaxPhysDist 10000
	es_MaxImpulseAdjMass 10000
	
	p_max_player_velocity 100000
	p_max_velocity 100000
	
	s_MusicVolume 0
	
	ai_MNMEditorBackgroundUpdate 0
	
	sv_gamerules DeathMatch
	sv_gamerulesdefault DeathMatch
	
	s_ReverbDynamic 2
	]]
	--[==[	
	
	..[[
	sv_packetRate 0
	cl_packetRate 0
	g_useProfile 0
	p_players_can_break 1
	
	net_maxpacketsize 10000
	net_packetsendrate 0
	]]
	
	]==], 
	true -- this silence oh i will shut down the sounds
)
console.RunString("log_verbosity 0", true)

engine3d.PauseTOD(true)