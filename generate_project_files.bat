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

	set /P ANSWER=Do you want to generate the project files to "%CRYENGINETHREEFOLDER%\oohh_project_files\*" (Y/N)?
	echo You chose: %ANSWER%
	if /i {%ANSWER%}=={y} (goto :premake)
	if /i {%ANSWER%}=={yes} (goto :premake)
	goto :end

:premake
	premake4 codeblocks
	premake4 codelite
	premake4 gmake
	premake4 vs2002
	premake4 vs2003
	premake4 vs2005
	premake4 vs2008
	premake4 vs2010
:end

%SystemRoot%\explorer.exe "%CRYENGINETHREEFOLDER%\oohh_project_files\"

exit /b 0