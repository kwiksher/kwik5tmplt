-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
function _M:localVars()
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
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = {"", imageWidth, imageHeight, mX, mY, oriAlpha, {{elColor}} }
  {{/multLayers}}
  {{^multLayers}}
    {{#elVectorRect}}
      layer.{{myLName}} = display.newRect( mX, mY, imageWidth, imageHeight )
    {{/elVectorRect}}
    {{#elVectorCircle}}
      layer.{{myLName}} = display.newCircle( mX, mY, imageWidth/2 )
    {{/elVectorCircle}}
    {{#randX}}
      layer.{{myLName}}.x = math.random( randXStart, {{randXEnd}})
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
    layer.{{myLName}}:setFillColor ({{elColor}})
    layer.{{myLName}}.alpha = oriAlpha
    layer.{{myLName}}.oldAlpha = oriAlpha
    layer.{{myLName}}.anchorX = 0.5
    layer.{{myLName}}.anchorY = 0.5
    {{#background}}
      sceneGroup:insert( 1, layer.{{myLName}})
      sceneGroup.{{myLName}} = layer.{{myLName}}
    {{/background}}
    {{^background}}
      sceneGroup:insert( layer.{{myLName}})
      sceneGroup.{{myLName}} = layer.{{myLName}}
    {{/background}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
end
--
function _M:toDispose()
end
--
function _M:localVars()
end
--
return _M