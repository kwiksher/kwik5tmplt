#!/bin/bash

#dst="$(cd $(dirname $0); pwd)"
dst=Solar2D

book=mybook
pages=("page1")
tmp=""

mkdir -p $dst/App/$book
cd $dst/App/$book

for page in  "${pages[@]}"
do
tmp+="'${page}', "
page="$page"
echo $page
mkdir -p assets/images/$page
mkdir -p commands/$page
mkdir -p components/$page
mkdir -p components/$page/audios
mkdir -p components/$page/audios/long
mkdir -p components/$page/audios/short
mkdir -p components/$page/audios/sync
mkdir -p components/$page/groups
mkdir -p components/$page/layers
mkdir -p components/$page/page
mkdir -p components/$page/timers
mkdir -p components/$page/variables
mkdir -p components/$page/joints
mkdir -p models/$page

cp ../../editor/template/components/pageX/layers/bg.lua components/$page/layers/bg.lua

cd components/$page
#cp $newPageIndex index.lua
cat << EOF > index.lua
local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    components = {
      layers = { { bg={} } },
      audios = { },
      groups = { },
      timers = { },
      variables = { },
      page = { }
    },
    commands = { },
    onInit = function(scene) print("onInit") end
})
--
return scene
EOF
cd ..
cd ..
done

echo $tmp

cd $dst/App/$book
#cp $newIndex index.lua
cat << EOF > index.lua
local scenes = {
$tmp
}
return scenes
EOF

#cd $dst
# exit