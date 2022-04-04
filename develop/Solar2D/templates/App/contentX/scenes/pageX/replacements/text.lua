-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
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
local eloH = {{eloH}}/4
local eloV = {{eloV}}/4
local epadV ={{epadV}}/4
local elFontSize = {{elFontSize}}/4
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
local eloH = {{eloH}}
local eloV = {{eloV}}
local epadV ={{epadV}}
local elFontSize = {{elFontSize}}
{{/ultimate}}
local oriAlpha = {{oriAlpha}}
--
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = { imageHeight, imageWidth, "{{elContent}}", mX, mY, eloH, eloV, {{elFont}}, epadV, elFontSize, {{elR}}, {{elG}}, {{elB}} }
  {{/multLayers}}
  {{^multLayers}}
    {{#elpara}}
      local {{myLName}}_options = { text = "{{elContent}}", x = mX, y = mY, fontSize = elFontSize, font = {{elFont}}, width = imageWidth, align = "{{elAlign}}" }
      local {{myLName}}H = imageHeight
      layer.{{myLName}} = display.newText( {{myLName}}_options )
      if layer.{{myLName}} == nil then return end
    {{/elpara}}
    {{^elpara}}
      local {{myLName}}_txt = "{{elContent}}"
      layer.{{myLName}} = display.newText( {{myLName}}_txt, mX, mY, imageWidth+eloH, imageHeight+eloV, {{elFont}}, elFontSize)
      if layer.{{myLName}} == nil then return end
    {{/elpara}}
    layer.{{myLName}}.originalH = imageHeight
    layer.{{myLName}}.originalW = imageWidth
    layer.{{myLName}}:setFillColor ({{elR}}, {{elG}}, {{elB}})
    {{#ultimate}}
    -- layer.{{myLName}}.x = layer.{{myLName}}.x + imageWidth/2
    -- layer.{{myLName}}.y = layer.{{myLName}}.y - imageHeight/2
      layer.{{myLName}}.anchorX = 0.5
      layer.{{myLName}}.anchorY = 0.5
    {{/ultimate}}
    {{^ultimate}}
      layer.{{myLName}}.anchorX = 0.5
      layer.{{myLName}}.anchorY = 0
    {{/ultimate}}
    {{#epadV}}
      layer.{{myLName}}.y = layer.{{myLName}}.y + epadV
    {{/epadV}}
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
    layer.{{myLName}}.alpha = oriAlpha
    layer.{{myLName}}.oldAlpha = oriAlpha
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
end
--
function _M:didShow()
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