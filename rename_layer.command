#!/bin/bash

cd Solar2D
cp /Users/ymmtny/Library/Application\ Support/Corona\ Simulator/.-454202B18A2EC19B0E6BDAED40A4821C/tmp/App/mybook/components/page1/index.lua App/mybook/components/page1/
mv App/mybook/components/page1/layers/bg11.lua App/mybook/components/page1/layers/bg12.lua
sed -i '' 's/bg11/bg12/g'  App/mybook/components/page1/layers/bg12.lua
mv App/mybook/components/page1/layers/bg11_button.lua App/mybook/components/page1/layers/bg12_button.lua
sed -i '' 's/bg11/bg12/g'  App/mybook/components/page1/layers/bg12_button.lua
exit