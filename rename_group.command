#!/bin/bash

cd Solar2D
cp /Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/physics/components/basic/index.lua App/physics/components/basic/
mv App/physics/components/basic/groups/group0.lua App/physics/components/basic/groups/hitGroup.lua
sed -i '' 's/group0/hitGroup/g'  App/physics/components/basic/groups/hitGroup.lua

exit