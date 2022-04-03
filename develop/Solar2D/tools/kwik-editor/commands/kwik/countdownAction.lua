-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app            = require "Application"
--
function _M:playCountDown(tname, ttime, upTime, UI)
  local tnameSeconds = ttime
     -- print("playCountDown")
     UI.layer[tname..'Seconds'] = ttime
     upTime()
     if (app.timerStash[tname]) then
         timer.cancel(app.timerStash[tname])
         app.timerStash[tname] = nil
     end
     app.timerStash[tname] = timer.performWithDelay(1000, upTime, tnameSeconds + 1 )
   end
--
return _M