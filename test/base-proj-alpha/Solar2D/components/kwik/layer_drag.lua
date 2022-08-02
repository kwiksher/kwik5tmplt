local _M = {}
--
local app = require "Application"
--
function _M.add(dragLayer, onComplete)
	if dragLayer == nil then return end
	app.MultiTouch.activate( dragLayer, "move", "single", {})
	--
	local eventHandler = function (event )
		local t = event.target
		if event.phase == "began" then
			local parent = t.parent; parent:insert(t); display.getCurrentStage():setFocus(t); t.isFocus = true
		elseif event.phase == "moved" then
		elseif event.phase == "ended" or event.phase == "cancelled" then
			--UI.scene:dispatchEvent({name="dragComplete", event={UI=UI, target=t} })
			onComplete(t)
			display.getCurrentStage():setFocus(nil); t.isFocus = false
		end
		return true
	end
	--
	dragLayer:addEventListener( app.MultiTouch.MULTITOUCH_EVENT, eventHandler )
end
--
function _M.remove(dragLayer)
	if dragLayer then
		dragLayer:removeEventListener ( app.MultiTouch.MULTITOUCH_EVENT,  eventHandler );
	end
end
--
return _M