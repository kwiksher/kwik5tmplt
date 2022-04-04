-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:localVars(UI)
end
--
{{#ultimate}}
local imageWidth = {{elW}}/4
local imageHeight = {{elH}}/4
local mX, mY = _K.ultimatePosition({{mX}}, {{mY}}, "{{align}}")
{{#randX}}
local randXStart = _K.ultimatePosition({{randXStart}})
local randXEnd = _K.ultimatePosition({{randXEnd}})
{{/randX}}
{{#randY}}
local dummy, randYStart = _K.ultimatePosition(0, {{randYStart}})
local dummy, randYEnd     = _K.ultimatePosition(0, {{randYEnd}})
{{/randY}}
{{/ultimate}}
{{^ultimate}}
local imageWidth = {{elW}}
local imageHeight = {{elH}}
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}}, "{{align}}")
{{#randX}}
local randXStart = {{randXStart}}
local randXEnd = {{randXEnd}}
{{/randX}}
{{#randY}}
local randYStart = {{randYStart}}
local randYEnd = {{randYEnd}}
{{/randY}}
{{/ultimate}}
local oriAlpha = {{oriAlpha}}

--
local singleNames = {"PagePrevM", "PageNextM"}
--
local function isSingleton(layerName)
  for i=1, #singleNames do
    if layerName == singleNames[i] then
      return true
    end
  end
  return false
end
--
function _M:localPos(UI)
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = {"", imageWidth, imageHeight, mX, mY, "{{elURL}}", "{{oriAlpha}}"}
  {{/multLayers}}
  {{^multLayers}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
  if isSingleton("{{myLName}}") then
    if _K.layer["{{myLName}}"] == nil or _K.layer["{{myLName}}"].play == nil then
       print("singleton:newVideo")
      _K.layer.{{myLName}} = native.newVideo( mX, mY, imageWidth, imageHeight )
      _K.layer.{{myLName}}.isLoaded = false
    end
    layer.{{myLName}} = _K.layer.{{myLName}}
  else
    layer.{{myLName}} = native.newVideo( mX, mY, imageWidth, imageHeight )
  end
  --
    {{#randX}}
      layer.{{myLName}}.x = math.random( randXStart,randXEnd)
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random( randYStart, {{randYEnd}})
    {{/randY}}
    {{#scaleW}}
      layer.{{myLName}}.xScale = {{scaleW}}
    {{/scaleW}}
    {{#scaleH}}
      layer.{{myLName}}.yScale = {{scaleH}}
    {{/scaleH}}
    {{#rotate}}
      layer.{{myLName}}:rotate( {{rotate)}})
    {{/rotate}}
    layer.{{myLName}}.oriX = layer.{{myLName}}.x
    layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale

    layer.{{myLName}}.alpha = oriAlpha
    layer.{{myLName}}.oldAlpha = oriAlpha
  if isSingleton("{{myLName}}") then
    if not  _K.layer.{{myLName}}.isLoaded then
    {{#elLocal}}
      layer.{{myLName}}:load( _K.videoDir.."{{elURL}}", _K.systemDir )
    {{/elLocal}}
    {{^elLocal}}
      layer.{{myLName}}:load( "{{elURL}}", media.RemoteSource )
    {{/elLocal}}
      _K.layer.{{myLName}}.isLoaded = true;
    else
      layer.{{myLName}}:seek(0)  --rewind video after play
      layer.{{myLName}}:pause()
    end
  else
    {{#elLocal}}
      layer.{{myLName}}:load( _K.videoDir.."{{elURL}}", _K.systemDir )
    {{/elLocal}}
    {{^elLocal}}
      layer.{{myLName}}:load( "{{elURL}}", media.RemoteSource )
    {{/elLocal}}
  end
    {{#elPlay}}
      layer.{{myLName}}:play()
    {{/elPlay}}
    {{#elTriggerElLoop}}
    UI.videoListener_{{myLName}} = function(event)
        if event.phase == "ended" then
          {{#elRewind}}
            layer.{{myLName}}:seek(0)  --rewind video after play
          {{/elRewind}}
          {{#elLoop}}
            layer.{{myLName}}:play()
          {{/elLoop}}
          {{#elTrigger}}
           UI.scene:dispatchEvent({name="action_{{elTrigger}}", layer=layer.{{myLName}} })
          {{/elTrigger}}
         end
      end
    layer.{{myLName}}:addEventListener( "video", UI.videoListener_{{myLName}} )
    {{/elTriggerElLoop}}
    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
    if _K.muteVideos["{{myLName}}"] == true then
      layer.{{myLName}}.isMuted = true
    end
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
  if layer.{{myLName}} ~= nil then
    if isSingleton("{{myLName}}") then
      for i=1, 32 do
        if audio.isChannelActive(i) then
         --   print('channel '..i..' is active')
          -- audio.setVolume( 0.01, {channel=i}  )
        end
      end
    else
        if layer.{{myLName}} then
             layer.{{myLName}}:pause()
             layer.{{myLName}}:removeSelf()
             layer.{{myLName}} = nil
        end
    end
  end
  {{#elTriggerElLoop}}
  if layer.{{myLName}} ~=nil and UI.videoListener_{{myLName}} ~= nil then
      layer.{{myLName}}:removeEventListener( "video", UI.videoListener_{{myLName}} )
      UI.videoListener_{{myLName}} = nil
  end
  {{/elTriggerElLoop}}
  {{/multLayers}}
end
--
function _M:localVars()
  {{#multLayers}}
  {{/multLayers}}
end

function _M:toDestroy(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
  {{/multLayers}}
end

--
return _M