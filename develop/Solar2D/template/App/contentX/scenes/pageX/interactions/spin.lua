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

  {{#dbounds}}
  _K.MultiTouch.activate( layer.{{glayer}}, "rotate", "single",  {{dbounds}} )
  {{/dbounds}}
  {{^dbounds}}
  _K.MultiTouch.activate( layer.{{glayer}}, "rotate", "single" )
  {{/dbounds}}
  _K.{{glayer}}Spin = function (event )
    if event.direction == "clockwise" then
      {{#gtclock}}
           UI.scene:dispatchEvent({name="{{gtclock}}", spin=event })
      {{/gtclock}}
    elseif event.direction == "counter_clockwise" then
      {{#gtcounter}}
           UI.scene:dispatchEvent({name="{{gtcounter}}", spin=event })
      {{/gtcounter}}
     end
     return true
  end
  layer.{{glayer}}:addEventListener( _K.MultiTouch.MULTITOUCH_EVENT, _K.{{glayer}}Spin )

end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{glayer}} == nil or _K.{{glayer}}Spin == nil then return end

  layer.{{glayer}}:removeEventListener ( _K.MultiTouch.MULTITOUCH_EVENT,  _K.{{glayer}}Spin )
  _K.{{glayer}}Spin = nil
    --_K.Gesture.deactivate(layer.{{glayer}})
end
--
function _M:toDestroy(UI)
  _K.{{glayer}}Spin = nil
end
--
return _M