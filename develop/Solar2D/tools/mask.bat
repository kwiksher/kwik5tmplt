@echo GraphicsMagick-X.X.XX-Q8-win32-dll.exe
@echo ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/
@echo off

set MAGICK=gm convert
set PROJPATH={{projPath}}

@rem  https://superuser.com/questions/213336/using-graphicsmagick-or-imagemagick-how-do-i-replace-transparency-with-a-fill-c
@rem  %MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
@rem  %MAGICK% "%OUT%" -resize 68x60 -background black -gravity center -extent 100x100  "%OUT%"
@rem

{{#ultimate}}
{{#kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/{{bn}}@4x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/{{bn}}_mask@4x.jpg
{{/kwk}}
{{^kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@4x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@4x.jpg
{{/kwk}}
%MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
%MAGICK% "%OUT%" -resize {{width4x}}x{{height4x}} -background black -gravity center -extent {{width4xOut}}x{{height4xOut}} "%OUT%"
@rem
{{#kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/{{bn}}@2x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/{{bn}}_mask@2x.jpg
{{/kwk}}
{{^kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@2x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@2x.jpg
{{/kwk}}
%MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
%MAGICK% "%OUT%" -resize {{width2x}}x{{height2x}} -background black -gravity center -extent {{width2xOut}}x{{height2xOut}} "%OUT%"
{{#kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/{{bn}}.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/{{bn}}_mask.jpg
{{/kwk}}
@rem
{{^kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask.jpg
{{/kwk}}
%MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
%MAGICK% "%OUT%" -resize {{width1x}}x{{height1x}} -background black -gravity center -extent {{width1xOut}}x{{height1xOut}} "%OUT%"
{{/ultimate}}

{{^ultimate}}
{{#kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/{{bn}}@2x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/{{bn}}_mask@2x.jpg
{{/kwk}}
{{^kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@2x.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@2x.jpg
{{/kwk}}
%MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
%MAGICK% "%OUT%" -resize {{width2x}}x{{height2x}} -background black -gravity center -extent {{width2xOut}}x{{height2xOut}} "%OUT%"
@rem
{{#kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/{{bn}}.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/{{bn}}_mask.jpg
{{/kwk}}
{{^kwk}}
set FILENAME=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}.png
set OUT=%PROJPATH%/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask.jpg
{{/kwk}}
%MAGICK% "%FILENAME%" -background black -extent 0x0 +matte -threshold 20 "%OUT%"
%MAGICK% "%OUT%" -resize {{width1x}}x{{height1x}} -background black -gravity center -extent {{width1xOut}}x{{height1xOut}} "%OUT%"
{{/ultimate}}

