-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K            = require "Application"
--
function _M:playCountDown(tname, ttime, upTime, UI)
  local tnameSeconds = ttime
     -- print("playCountDown")
     UI.layer[tname..'Seconds'] = ttime
     upTime()
     if (_K.timerStash[tname]) then
         timer.cancel(_K.timerStash[tname])
         _K.timerStash[tname] = nil
     end
     _K.timerStash[tname] = timer.performWithDelay(1000, upTime, tnameSeconds + 1 )
   end
--
return _M