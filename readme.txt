run generate.bat and input your cryengine3 sdk path (preferably clean)

project files will be made in a folder named "oohh_project_files" 
in the root of your cryengine3 sdk folder

premake issues:
  vs20xx:
    - premake sets the debugger target to CryGame.dll, so you need to 
	  set it to use launcher.exe instead if you want f5 to work