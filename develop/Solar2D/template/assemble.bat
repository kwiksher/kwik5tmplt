@echo GraphicsMagick-X.X.XX-Q8-win32-dll.exe
@echo ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/
@echo off
set PLUGIN_FOLDER=C:\Program Files (x86)\Common Files\Adobe\CEP\extensions\com.kwiksher.kwik4\ext\PC
set PNGASM=apngasm
set MAGICK=gm convert
set PROJPATH={{projPath}}
set SANDBOXPATH={{sandboxPath}}

{{#AGIF}}
%MAGICK% -loop {{loop}} -delay {{delay}} "%SANDBOXPATH%\{{fileName}}_*.png" "%PROJPATH%\temp\{{fileName}}.gif"
{{/AGIF}}

{{#APNG}}
"%PLUGIN_FOLDER%/%PNGASM%" "%PROJPATH%\temp\{{fileName}}.png" "%SANDBOXPATH%\{{fileName}}_*.png" 1 {{frameRate}} -l{{loop}} -z2
{{/APNG}}

