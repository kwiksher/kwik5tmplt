dst=kwik-exporter/kwik/base-proj/Solar2D

mkdir -p  $dst/AndroidResources
mkdir -p  $dst/en.lproj
mkdir -p  $dst/Images.xcassets
mkdir -p  $dst/LaunchScreen.storyboardc
mkdir -p  $dst/custom
mkdir -p  $dst/App

cp -rf ../Solar2D/AndroidResources $dst
cp -rf ../Solar2D/App/book $dst
cp -rf ../Solar2D/App/bookstore.lua $dst/App
cp -rf ../Solar2D/App/uiHandler.lua $dst/App
cp -rf ../Solar2D/custom $dst
cp -rf ../Solar2D/en.lproj $dst
cp -rf ../Solar2D/Images.xcassets $dst
cp -f ../Solar2D/build.settings $dst
cp -f ../Solar2D/config.lua $dst
cp -f ../Solar2D/Icon-osx.icns $dst
cp -f ../Solar2D/Icon-win32.ico $dst
cp -rf ../Solar2D/LaunchScreen.storyboardc $dst
cp -f ../Solar2D/License.md $dst
cp -f ../Solar2D/main.lua $dst
cp -f ../Solar2D/mySplashScreen.png $dst
cp -f ../Solar2D/README.md $dst
