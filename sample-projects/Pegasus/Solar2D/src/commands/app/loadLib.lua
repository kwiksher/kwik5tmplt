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
		if event=="init" then
			-- check if current SDK version is the latest compatible with Kwik
			local function versionCheck(event)
			    if "clicked" == event.action then
			        if event.index == 2 then
			            system.openURL( "https://developer.coronalabs.com/downloads/coronasdk" )
			        end
			    end
			end
			if ( system.getInfo("environment") == "simulator" and
			    string.sub(system.getInfo("build"),6) < string.sub("'+ $.kwik.myConfig.corona+'",6) ) then
			    native.showAlert("Corona SDK Incompatible Version",
			        "Your Corona SDK version is different than the certified one with Kwik. "..
			        "Install build {{corona.version}} or you may have issues in your project.",
			        {"OK", "Download"},
			        versionCheck)
			end
		end
	end
	return command
end
--
return _Command