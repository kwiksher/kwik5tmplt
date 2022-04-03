-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:Var()
end
--
{{#ultimate}}
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
  {{#randX}}
  local randXStart = {{randXStart}}
  local randXEnd = {{randXEnd}}
  {{/randX}}
  {{#randY}}
  local randYStart = {{randYStart}}
  local randYEnd = {{randYEnd}}
  {{/randY}}
{{/ultimate}}
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if UI.tSearch["{{bn}}"] == nil then return end
  {{#multLayers}}
    layer.{{myLName}} = display.newText( UI.tSearch["{{bn}}"][1], UI.tSearch["{{bn}}"][4], UI.tSearch["{{bn}}"][5], UI.tSearch["{{bn}}"][7], UI.tSearch["{{bn}}"][8] )
    layer.{{myLName}}:setFillColor(UI.tSearch["{{bn}}"][11], UI.tSearch["{{bn}}"][12], UI.tSearch["{{bn}}"][13])
    layer.{{myLName}}.anchorX = 0
    layer.{{myLName}}.anchorY = 0;
    _K.repositionAnchor(layer.{{myLName}},0.5,0);

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
    layer.{{myLName}}:rotate({{rotate}}
  {{/rotate}}
    layer.{{myLName}}.oriX = layer.{{myLName}}.x; layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale; layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale

    layer.{{myLName}}.alpha = UI.tSearch["{{bn}}"][6]; layer.{{myLName}}.oldAlpha = UI.tSearch["{{bn}}"][6]
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
    layer.{{myLName}}.text = UI.tSearch["{{bn}}"][1]
  {{/multLayers}}
end
--
return _M
