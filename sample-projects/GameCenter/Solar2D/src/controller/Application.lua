-- Code created by Kwik - Copyright: kwiksher.com 2016
-- Version: 4.0.2 01
-- Project: HelloWorld
--
print("App ".._G.appName)
local app = require("App.".._G.appName..".Application")
app.appName="App.".._G.appName.."."
if "tvOS" == system.getInfo("platform") then
  system.setIdleTimer( false )
  app.DocumentsDir = system.CachesDirectory
else
  app.DocumentsDir = system.DocumentsDirectory
end
return app