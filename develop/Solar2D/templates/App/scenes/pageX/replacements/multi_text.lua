-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
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
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if UI.tSearch["{{dois}}"] == nil then return end
  {{#multLayers}}
    local {{myLName}}_txt = UI.tSearch["{{dois}}"][3]
    {{#elpara}}
      local {{myLName}}H = UI.tSearch["{{dois}}"][1]
      layer.{{myLName}} = display.newText( {{myLName}}_txt, UI.tSearch["{{dois}}"][4], UI.tSearch["{{dois}}"][5], UI.tSearch["{{dois}}"][2], 0, UI.tSearch["{{dois}}"][8],UI.tSearch["{{dois}}"][10])
    {{/elpara}}
    {{^elpara}}
      layer.{{myLName}} = display.newText( {{myLName}}_txt, UI.tSearch["{{dois}}"][4], UI.tSearch["{{dois}}"][5], (UI.tSearch["{{dois}}"][2]+UI.tSearch["{{dois}}"][6]), (UI.tSearch["{{dois}}"][1]+UI.tSearch["{{dois}}"][7]), UI.tSearch["{{dois}}"][8], UI.tSearch["{{dois}}"][10])
    {{/elpara}}
    layer.{{myLName}}:setFillColor(UI.tSearch["{{dois}}"][11], UI.tSearch["{{dois}}"][12], UI.tSearch["{{dois}}"][13])
    {{#epadV}}
      layer.{{myLName}}.y = layer.{{myLName}}.y + UI.tSearch["{{dois}}"][9]
    {{/epadV}}
    layer.{{myLName}}.anchorX = 0.5
    layer.{{myLName}}.anchorY = 0;
    _K.repositionAnchor(layer.{{myLName}},0.5,0);

    {{#scaleW}}
      layer.{{myLName}}.xScale = scaleW
    {{/scaleW}}
    {{#scaleH}}
      layer.{{myLName}}.yScale = scaleH
    {{/scaleH}}
    {{#rotate}}
      layer.{{myLName}}:rotate({{rotate}})
    {{/rotate}}
    {{#randX}}
      layer.{{myLName}}.x = math.random(randXStart, randXEnd)
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random(randYStart, randYEnd)
    {{/randY}}

    layer.{{myLName}}.oriX = layer.{{myLName}}.x
    layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
    layer.{{myLName}}.alpha = {{oriAlpha}}
    layer.{{myLName}}.oldAlpha = {{oriAlpha}}
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
end
--
function _M:toDispose()
end
--
function _M:localVars()
  {{#multLayers}}
  {{/multLayers}}
end
--
return _M