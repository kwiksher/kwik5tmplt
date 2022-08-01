-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
local composer = require("composer")
local Navigation = require("extlib.kNavi")
--
{{#ultimate}}
local xFactor = display.contentWidth/1920
local yFactor = display.contentHeight/1280
local pSpa =  {{pSpa}}/4
{{/ultimate}}
{{^ultimate}}
local pSpa  = {{pSpa}}
{{/ultimate}}
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local curPage     = UI.curPage
  local numPages    = UI.numPages

  if layer.{{backLayer}} == nil then return end
  _K.Gesture.activate( layer.{{backLayer}}, {swipeLength= pSpa }) --why
  {{#infinity}}
    if layer.{{backLayer}}_2 == nil then return end
    _K.Gesture.activate( layer.{{backLayer}}_2, {swipeLength= pSpa })
  {{/infinity}}
  _K.pageSwap = function (event )
    local options
    if event.phase == "ended" and event.direction ~= nil then
       local wPage = curPage

       if event.direction == "left" and _K.kBidi == false then
          wPage = curPage + 1
          if wPage > numPages then wPage = curPage end
          options = { effect = "fromRight"}
       elseif event.direction == "left" and _K.kBidi == true then
          wPage = curPage - 1
          if wPage < 1 then wPage = 1 end
          options = { effect = "fromLeft"}
       elseif event.direction == "right" and _K.kBidi == true then
          wPage = curPage + 1
          if wPage > numPages then wPage = curPage end
          options = { effect = "fromRight"}
       elseif event.direction == "right" and _K.kBidi == false then
          wPage = curPage - 1
          if wPage < 1 then wPage = 1 end
          options = { effect = "fromLeft"}
       end
       if tonumber(wPage) ~= tonumber(curPage) then
          {{#hasShake}}
          if _K.shakeMe ~= nil then
            Runtime:removeEventListener("accelerometer", _K.shakeMe);
            _K.shakeMe = nil
          end
          {{/hasShake}}
          {{#invert}}
          if _K.kOrientation_act ~= nil then
          Runtime:removeEventListener("orientation", _K.kOrientation_act);
          _K.kOrientation_act = nil
          {{/invert}}
          {{#navigation}}
            Navigation.hide()
          {{/navigation}}
          _K.appInstance:showView("views.page0"..wPage.."Scene", options)
         end
      end
    end
    layer.{{backLayer}}:addEventListener( _K.Gesture.SWIPE_EVENT, _K.pageSwap )
    {{#infinity}}
      layer.{{backLayer}}_2:addEventListener( _K.Gesture.SWIPE_EVENT, _K.pageSwap )
    {{/infinity}}
end
--
function _M:toDispose(UI)
   local layer       = UI.layer
    if _K.pageSwap ~= nil then
    layer.{{backLayer}}:removeEventListener( _K.Gesture.SWIPE_EVENT, _K.pageSwap )
    end
    {{#infinity}}
     if _K.pageSwap ~= nil then
      layer.{{backLayer}}_2:removeEventListener( _K.Gesture.SWIPE_EVENT, _K.pageSwap )
    end
    {{/infinity}}
    _K.pageSwap ~= nil
  --_K.Gesture.deactivate(layer.{{myLName+') ;
end
--
function _M:toDestroy()
  _K.pageSwipe = nil
end
--
return _M