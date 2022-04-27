-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _K              = require("Application")

local _M = {}
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
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}}, "{{align}}")local mX = {{mX}}
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
function _M:localPos(UI)
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = {"", imageWidth, imageHeight, mX, mY, "{{elURL}}", oriAlpha}
  {{/multLayers}}
  {{^multLayers}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
    layer.{{myLName}} = native.newWebView( mX, mY, imageWidth, imageHeight )

    {{#elLocal}}
      -- Loads web pages
      layer.{{myLName}}:request( "{{elURL}}", _K.systemDir )
    {{/elLocal}}
    {{^elLocal}}
      -- Loads web pages
      layer.{{myLName}}:request( "{{elURL}}" )
    {{/elLocal}}
    {{#randX}}
      layer.{{myLName}}.x = math.random( randXStart, randXEnd)
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random( randYStart, randYEnd)
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
    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}

  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{^multLayers}}
  if layer.{{myLName}} ~= nil then
    layer.{{myLName}}:removeSelf()
    layer.{{myLName}} = nil
  end
  {{/multLayers}}
end
--
function _M:localVars()
end
--
return _M