-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		local admobKey         = params.admobKey
		local iAdsKey          = params.iAdsKey
		if event=="init" then
			local ads = require "ads"
			-- For personal use  \r\n';
			local function showAd(event)
			   if (event.isError) then
			   -- Failed to receive an ad.
			   end
			   return true
			end
			if (system.getInfo("platform") == "Android") then
			     ads.init("admob", adMobKey, showAd )
			else
			     ads.init("iads", iAdsKey, showAd )
			end
		end
	end
	return command
end
--
return _Command