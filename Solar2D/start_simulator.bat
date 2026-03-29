@echo off
setlocal

set REFRESH_OFF=0

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--refresh-off" (
	set REFRESH_OFF=1
)
shift
goto parse_args

:args_done
if "%REFRESH_OFF%"=="1" (
	reg add "HKCU\Software\Ansca Mobile\Corona Simulator\Preferences" /v "relaunchProjectOnModify" /t REG_DWORD /d 0 /f >nul
	echo Set Corona Simulator relaunchProjectOnModify=0
)

start /b "" cmd /c ""C:\Program Files (x86)\Corona Labs\Corona\Corona Simulator.exe" -no-console main.lua > ../tmp.txt"
code ../tmp.txt