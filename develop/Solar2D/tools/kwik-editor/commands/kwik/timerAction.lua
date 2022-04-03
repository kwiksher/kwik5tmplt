-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app            = require "Application"
--
function _M:startTimer(tname, delay, trigger, loop)
	app.timerStash[tname] = timer.performWithDelay(delay*1000, trigger, loop )
end
--
function _M:pauseTimer(tname)
	timer.pause( app.timerStash[tname])
end
--
function _M:resumeTimer(tname)
	timer.resume( app.timerStash[tname])
end
--
function _M:createTimer(tname, delay, trigger, loop, params)
	app.timerStash[tname] = timer.performWithDelay(delay*1000,
		function()
    Runtime:dispatchEvent({name=trigger, event=params.event, UI=params.UI})
		end , loop )
end
--
function _M:cancelTimer(tname)
	timer.cancel( app.timerStash[tname])
end
--
return _M