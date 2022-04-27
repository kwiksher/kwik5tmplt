-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K            = require "Application"
--
function _M:playMultiplier(tname)
    _K["multi_"..tname]()
end
--
function _M:stopMultiplier(tname)
   if (tname == "All") then
       _K.disposeMultiplier = 1
   else
       _K["multi_"..tname] = nil
       if _K.kClean ~= nil then
        Runtime:removeEventListener("enterFrame", _K.kClean)
        _K.kClean = nil
       end
   end
end
--
return _M