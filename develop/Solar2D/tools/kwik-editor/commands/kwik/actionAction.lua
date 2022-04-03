-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}

function _M:playAction(trigger, params)
		-- trigger()
	--print(trigger)
    Runtime:dispatchEvent({name=trigger, event=params.event, UI=params.UI})
end
--
return _M