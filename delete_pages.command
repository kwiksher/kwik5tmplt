#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

dst=Solar2D
book=mybook
newIndex=/Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/mybook/index.lua

cd $dst/App/$book
cp "$newIndex" .

mv /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/components/page4 /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/components/page4.bak
mv /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/commands/page4 /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/commands/page4.bak
mv /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/assets/images/page4 /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/assets/images/page4.bak
mv /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/models/page4 /Users/ymmtny/Documents/GitHub/kwik-visual-code/develop/Solar2D/kwik-editor-proj/Solar2D/./App/mybook/models/page4.bak

cd $SCRIPT_DIR/$dst

exit