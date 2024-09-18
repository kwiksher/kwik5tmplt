#!/bin/bash

dst=Solar2D
book=book
newIndex="/Users/ymmtny/Library/Application Support/Corona Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/book/index.lua"
newPageIndex="/Users/ymmtny/Library/Application Support/Corona Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/book/components/mybook/index.lua"
page=mybook

cd $dst/App/$book
cp $newIndex index.lua
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
cp $newPageIndex index.lua

exit