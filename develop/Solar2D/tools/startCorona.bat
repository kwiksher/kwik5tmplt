@echo off
set APP_NAME=Corona Simulator.exe
set APP_FOLDER=C:\Program Files (x86)\Corona Labs\Corona\
cd %APP_FOLDER%
rem /f first word
for /f %%i in ('tasklist 2^>^&1') do (
    if /i %%i==Corona (
        taskkill /im "Corona Simulator.exe" /f
        taskkill /im "Corona.Console.exe" /f
        goto ENDLOOP;
    )
)
:ENDLOOP
{{^closeCorona}}
{{#tmp}}
start  "" "{{corona}}" "{{projPath}}\temp\main.lua"
{{/tmp}}
{{^tmp}}
start  "" "{{corona}}" "{{projPath}}\build4\main.lua"
{{/tmp}}
{{/closeCorona}}
