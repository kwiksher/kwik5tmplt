PNGQUANT="/Library/Application Support/Adobe/CEP/extensions/com.kwiksher.kwik4/ext/Mac/pngquant"
PROJPATH="{{projPath}}"

chmod a+x "$PNGQUANT"
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/*.png
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/assets/images/*.png
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/assets/sprites/*.png
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/Images.xcassets/AppIcon.appiconset/*.png

{{#expDir}}
{{#pages}}
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/assets/images/{{pageDir}}/*.png
{{/pages}}
{{/expDir}}

{{^expDir}}
{{#pages}}
"$PNGQUANT" --ext .png -f --quality=60-95 $PROJPATH/build4/assets/{{pageDir}}/*.png
{{/pages}}
{{/expDir}}

