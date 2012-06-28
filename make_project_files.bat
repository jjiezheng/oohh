@echo off

goto again

:again
	cls
	echo enter your Crysis Wars or Cryengine3 folder
	set /P CRYENGINETHREEFOLDER="Crysis Wars or Cryengine3 folder: "
	if exist "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" goto link
	if not exist "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" goto notexist

:notexist
	cls
	echo "%CRYENGINETHREEFOLDER%" is not the Crysis Wars or Cryengine3 directory
	echo ( it checks if "%CRYENGINETHREEFOLDER%\Bin32\CryAction.dll" exists )
	pause
	goto again

:link
	cd %~dp0premake
	premake4 link

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
	premake4 xcode3
	premake4 xcode4
:end

%SystemRoot%\explorer.exe "%CRYENGINETHREEFOLDER%\oohh_project_files\"

exit /b 0
