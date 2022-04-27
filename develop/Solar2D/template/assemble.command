APNGASM="/Library/Application Support/Adobe/CEP/extensions/com.kwiksher.kwik4/ext/Mac/apngasm"
SANDBOXPATH="{{sandboxPath}}"
PROJPATH="{{projPath}}"

chmod a+x "$APNGASM"

{{#APNG}}
"$APNGASM" $PROJPATH/temp/{{fileName}}.png "$SANDBOXPATH"/{{fileName}}_*.png 1 {{fps}} -l{{loop}} -z2
{{/APNG}}

{{#AGIF}}
gm convert -loop {{loop}} -delay {{delay}} "$SANDBOXPATH"/{{fileName}}_*.png $PROJPATH/temp/{{fileName}}.gif
{{/AGIF}}
