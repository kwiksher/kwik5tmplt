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
  {{^sceneGroup}}
  local target = layer.{{myLName}}
  {{/sceneGroup}}
  {{#sceneGroup}}
  local target = sceneGroup
  {{/sceneGroup}}

  if target == nil then return end
  _K.Gesture.activate( target, {{dbounds}} )
  _K.{{myLName}}Swipe = function (event )
   if event.phase == "ended" and event.direction ~= nil then
       if event.direction == "up" then
      {{#gcompleteUp}}
         UI.scene:dispatchEvent({name="{{gcompleteUp}}", swip=event })
      {{/gcompleteUp}}
      elseif event.direction =="down" then
      {{#gcompleteDown}}
         UI.scene:dispatchEvent({name="{{gcompleteDown}}", swip=event })
      {{/gcompleteDown}}
      elseif event.direction =="left" then
      {{#gcompleteLeft}}
         UI.scene:dispatchEvent({name="{{gcompleteLeft}}", swip=event })
      {{/gcompleteLeft}}
      elseif event.direction=="right" then
      {{#gcompleteRight}}
         UI.scene:dispatchEvent({name="{{gcompleteRight}}", swip=event })
      {{/gcompleteRight}}
      end
    end
    return true
  end
  target:addEventListener( _K.Gesture.SWIPE_EVENT, _K.{{myLName}}Swipe )
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^sceneGroup}}
  local target = layer.{{myLName}}
  {{/sceneGroup}}
  {{#sceneGroup}}
  local target = sceneGroup
  {{/sceneGroup}}
  if target == nil or  _K.{{myLName}}Swipe == nil then return end
  target:removeEventListener ( _K.Gesture.SWIPE_EVENT, _K.{{myLName}}Swipe )
  _K.{{myLName}}Swipe = nil
    --_K.Gesture.deactivate(layer.{{myLName+') ;
end
--
function _M:toDestroy(UI)
  _K.{{myLName}}Swipe = nil
end
--
return _M