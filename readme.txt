running:
	go to http://www.crydev.net and download the latest SDK (oohh uses 3.4.0)
	extract the sdk somewhere on your pc
	make an account that you need to use when launching the game
	
	download this repository (if you're reading this from github) 
	and extract it somewhere on your pc
	
	run install.bat and type in your cryengine3 sdk path
	this will make links and copy files to your cryengine 3 sdk path so you 
	don't have to move this repository
	
	to launch the game start cryengine3sdk/Bin32/Launcher.exe
	
	some useful launch parameters are:
		-noborder
		-dx9 (because dx10 and dx11 is crashing in 3.4.0
	
	when hosting it is recommended to make the server use less resources by
	setting its cpu affinity mask and cpu priority flags from the task manager
	
	if you're running into Failed to load GameDLL issues, the install probably failed
		open cmd.exe as admin
		cd to the root of where install.bat is
		run install.bat from within the cmd
		
		
building:
	run generate_project_files.bat and input your cryengine3 sdk path

	project files will be made in a folder named "oohh_project_files" 
	in the root of your cryengine3 sdk folder
	
	note that this is coded using vs2012

	premake issues:
	  vs20xx:
		- premake sets the debugger target to CryGame.dll, so you need to 
		  set it to use launcher.exe instead if you want shortcuts 
		  like f5 to work