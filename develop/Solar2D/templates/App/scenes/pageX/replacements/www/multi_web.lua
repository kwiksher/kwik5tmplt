-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _K              = require("Application")

local _M = {}
--
{{#ultimate}}
local xFactor = display.contentWidth/1920
local yFactor = display.contentHeight/1280
  {{#randX}}
  local randXStart = {{randXStart}}/4
  local randXEnd = {{randXEnd}}/4
  {{/randX}}
  {{#randY}}
  local randYStart = {{randYStart}}/4
  local randYEnd = {{randYEnd}}/4
  {{/randY}}
{{/ultimate}}
{{^ultimate}}
  {{#randX}}
  local randXStart = {{randXStart}}
  local randXEnd = {{randXEnd}}
  {{/randX}}
  {{#randY}}
  local randYStart = {{randYStart}}
  local randYEnd = {{randYEnd}}
  {{/randY}}
{{/ultimate}}

function _M:localVars()
end
--
function _M:localPos()
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if UI.tSearch["{{bn}}"] == nil then return end
  {{#multLayers}}
    layer.{{myLName}} = native.newWebView( UI.tSearch["{{bn}}"][4], UI.tSearch["{{bn}}"][5], UI.tSearch["{{bn}}"][2], UI.tSearch["{{bn}}"][3] )
    {{#elLocal}}
      -- Loads web pages
      layer.{{myLName}}:request( UI.tSearch["{{bn}}"][6], _K.systemDir )
    {{/elLocal}}
    {{^elLocal}}
      -- Loads web pages
      layer.{{myLName}}:request( UI.tSearch["{{bn}}"][6] )
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
    layer.{{myLName}}.alpha = UI.tSearch["{{bn}}"][7]
    layer.{{myLName}}.oldAlpha = UI.tSearch["{{bn}}"][7]
    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}

  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
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