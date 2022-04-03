@echo off
set PLUGIN_FOLDER="C:\Program Files (x86)\Common Files\Adobe\CEP\extensions\com.kwiksher.kwik4.dev\ext\PC\"
set PNGQUANT=start /b /wait pngquant --ext .png -f --quality=60-95
set PROJPATH={{projPath}}

cd %PLUGIN_FOLDER%

%PNGQUANT% %PROJPATH%\\build4\\*.png
%PNGQUANT% %PROJPATH%\\build4\\assets\\images\\*.png
%PNGQUANT% %PROJPATH%\\build4\\assets\\sprites\\*.png
%PNGQUANT% %PROJPATH%\\build4\\Images.xcassets\\AppIcon.appiconset\\*.png

{{#expDir}}
{{#pages}}
%PNGQUANT% %PROJPATH%\\build4\\assets\\images\\{{pageDir}}\\*.png
{{/pages}}
{{/expDir}}

{{^expDir}}
{{#pages}}
%PNGQUANT% %PROJPATH%\\build4\\assets\\{{pageDir}}\\*.png
{{/pages}}
{{/expDir}}

