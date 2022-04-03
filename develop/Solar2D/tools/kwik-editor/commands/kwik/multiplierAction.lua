-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app            = require "Application"
--
function _M:playMultiplier(tname)
    app["multi_"..tname]()
end
--
function _M:stopMultiplier(tname)
   if (tname == "All") then
       app.disposeMultiplier = 1
   else
       app["multi_"..tname] = nil
       if app.kClean ~= nil then
        Runtime:removeEventListener("enterFrame", app.kClean)
        app.kClean = nil
       end
   end
end
--
return _M