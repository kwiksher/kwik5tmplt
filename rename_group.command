#!/bin/bash

cd Solar2D
cp /Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/book/components/page1/index.lua App/book/components/page1/
mv App/book/components/page1/groups/groupC.lua App/book/components/page1/groups/groupCat.lua
sed -i '' 's/groupC/groupCat/g'  App/book/components/page1/groups/groupCat.lua

exit