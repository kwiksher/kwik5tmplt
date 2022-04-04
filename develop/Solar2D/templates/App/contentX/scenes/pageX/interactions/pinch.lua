-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{glayer}} == nil then return end
    {{#move}}
    _K.MultiTouch.activate( layer.{{glayer}}, "move", {"single"} )
    {{/move}}
    _K.MultiTouch.activate( layer.{{glayer}}, "scale", "multi", {minScale = {{gmin}}, maxScale = {{gmax}} })
    _K.{{glayer}}Pinc = function (event )
        if event.phase == "moved" then
            {{#gtclock}}
           UI.scene:dispatchEvent({name="{{gtclock}}", pinch=event })
            {{/gtclock}}
         elseif event.phase == "ended" then
            {{#gtcounter}}
           UI.scene:dispatchEvent({name="{{gtcounter}}", pinch=event })
            {{/gtcounter}}
        end
        return true
    end
    layer.{{glayer}}:addEventListener( _K.MultiTouch.MULTITOUCH_EVENT, _K.{{glayer}}Pinc )
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{glayer}} == nil or _K.{{glayer}}Pinc == nil then return end
    layer.{{glayer}}:removeEventListener ( _K.MultiTouch.MULTITOUCH_EVENT,  _K.{{glayer}}Pinc )
    _K.{{glayer}}Pinc = nil
    --_K.Gesture.deactivate(layer.{{glayer}})
end
--
function _M:destroy()
    _K.{{glayer}}Pinc = nil
end
--
return _M
