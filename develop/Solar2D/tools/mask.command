# https://superuser.com/questions/213336/using-graphicsmagick-or-imagemagick-how-do-i-replace-transparency-with-a-fill-c
# gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
# gm convert "$OUT" -resize 68x60 -background black -gravity center -extent 100x100  "$OUT"
#

PROJPATH="{{projPath}}"
{{#ultimate}}
{{#kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/{{bn}}@4x.png
OUT=$PROJPATH/build4/{{imgFolder}}/{{bn}}_mask@4x.jpg
{{/kwk}}
{{^kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@4x.png
OUT=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@4x.jpg
{{/kwk}}
gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
gm convert "$OUT" -resize {{width4x}}x{{height4x}} -background black -gravity center -extent {{width4xOut}}x{{height4xOut}} "$OUT"
#
{{#kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/{{bn}}@2x.png
OUT=$PROJPATH/build4/{{imgFolder}}/{{bn}}_mask@2x.jpg
{{/kwk}}
{{^kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@2x.png
OUT=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@2x.jpg
{{/kwk}}
gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
gm convert "$OUT" -resize {{width2x}}x{{height2x}} -background black -gravity center -extent {{width2xOut}}x{{height2xOut}} "$OUT"
{{#kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/{{bn}}.png
OUT=$PROJPATH/build4/{{imgFolder}}/{{bn}}_mask.jpg
{{/kwk}}
#
{{^kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}.png
OUT=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask.jpg
{{/kwk}}
gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
gm convert "$OUT" -resize {{width1x}}x{{height1x}} -background black -gravity center -extent {{width1xOut}}x{{height1xOut}} "$OUT"
{{/ultimate}}

{{^ultimate}}
{{#kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/{{bn}}@2x.png
OUT=$PROJPATH/build4/{{imgFolder}}/{{bn}}_mask@2x.jpg
{{/kwk}}
{{^kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}@2x.png
OUT=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask@2x.jpg
{{/kwk}}
gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
gm convert "$OUT" -resize {{width2x}}x{{height2x}} -background black -gravity center -extent {{width2xOut}}x{{height2xOut}} "$OUT"
#
{{#kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/{{bn}}.png
OUT=$PROJPATH/build4/{{imgFolder}}/{{bn}}_mask.jpg
{{/kwk}}
{{^kwk}}
FILENAME=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}.png
OUT=$PROJPATH/build4/{{imgFolder}}/p{{docNum}}/{{bn}}_mask.jpg
{{/kwk}}
gm convert "$FILENAME" -background black -extent 0x0 +matte -threshold 20% "$OUT"
gm convert "$OUT" -resize {{width1x}}x{{height1x}} -background black -gravity center -extent {{width1xOut}}x{{height1xOut}} "$OUT"
{{/ultimate}}

