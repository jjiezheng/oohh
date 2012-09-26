@echo off

goto again

:again
	cls
	echo enter your Cryengine 3 free SDK folder
	set /P CRYENGINETHREEFOLDER="Cryengine 3 free SDK folder: "
	if exist "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" goto link
	if not exist "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" goto notexist

:notexist
	cls
	echo "%CRYENGINETHREEFOLDER%" is not the Cryengine 3 free SDK directory
	echo ( it checks if "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" exists )
	pause
	goto again

:link
	cd %~dp0premake
	premake4 link
	
	echo "done!"
	pause
	
exit /b 0
