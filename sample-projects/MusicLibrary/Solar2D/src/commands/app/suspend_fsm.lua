-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local composer = require("composer")
local storeFSM = require("components.store.storeFSM").getInstance()
local model       = require("components.store.model")
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			local function onSystemEvent(event)
			    local quitOnDeviceOnly = true
			    if quitOnDeviceOnly and system.getInfo("environment")=="device" then
			       if (event.type == "applicationSuspend")  then
			          if (system.getInfo( "platform" ) == "Android")  then
			              native.requestExit()
			          else
			          		if storeFSM.fsm:getState().name == "ThumbnailDisplayed" then
					              if nil~= composer.getScene("views.page01Scene") then
		                      print("=== suspend remove page01Scene === ")
					                composer.removeScene("views.page01Scene", true)
					              end
				            end
			              print("==== suspend =====")
			              if model.bookShelfType == 1 or model.bookShelfType == 2 then
		    	              storeFSM.fsm:showThumbnail()
				            else
    			              composer.gotoScene("views.page01Scene")
				            end
			          end
			       end
			    end
			end
			Runtime:addEventListener("system", onSystemEvent)
		end
	end
	return command
end
--
return _Command