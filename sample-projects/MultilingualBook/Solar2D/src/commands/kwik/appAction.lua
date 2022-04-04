-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}

function _M:rateApp(appID)
    local options = { iOSAppId = appID,
	    supportAndroidStores = {"google", "samsung", "amazon"}
    }
    native.showPopup("rateApp", options)
end
--
return _M