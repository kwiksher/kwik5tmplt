-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app            = require "Application"
--
function _M:pauseFilter(obj)
	transition.pause(obj.proxy)
end
--
function _M:resumeFilter(obj)
	transition.resume(obj.proxy)
end
--
function _M:playFilter(obj)
	obj:dispatchEvent( {name="playFilterAnim" })
end
--
function _M:cancelFilter(obj)
	transition.cancel(obj.proxy)
end
return _M