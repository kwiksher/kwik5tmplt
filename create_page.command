#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

dst=Solar2D
book=mybook
newIndex=/Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/mybook/index.lua
newPageIndex=/Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/mybook/components/page6/index.lua
page=page6

cd $dst/App/$book
cp "$newIndex" .
mkdir assets/images/$page
mkdir commands/$page
mkdir components/$page
mkdir components/$page/audios
mkdir components/$page/audios/long
mkdir components/$page/audios/short
mkdir components/$page/audios/sync
mkdir components/$page/groups
mkdir components/$page/layers
mkdir components/$page/page
mkdir components/$page/timers
mkdir components/$page/variables
mkdir components/$page/joints
mkdir models/$page

cd components/$page
cp "$newPageIndex" .
cp $SCRIPT_DIR/$dst/editor/template/components/pageX/layer/bg.lua layers/bg.lua
cd $SCRIPT_DIR/$dst
exit