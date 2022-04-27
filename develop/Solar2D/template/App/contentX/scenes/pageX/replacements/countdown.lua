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
local mX, mY = _K.ultimatePosition({{mX}}, {{mY}})
{{#randX}}
local randXStart = _K.ultimatePosition({{randXStart}})
local randXEnd = _K.ultimatePosition({{randXEnd}})
{{/randX}}
{{#randY}}
local dummy, randYStart = _K.ultimatePosition(0, {{randYStart}})
local dummy, randYEnd     = _K.ultimatePosition(0, {{randYEnd}})
{{/randY}}
local elFontSize = {{elFontSize}}/4
{{/ultimate}}
{{^ultimate}}
local imageWidth = {{elW}}
local imageHeight = {{elH}}
local mX = {{mX}}
local mY = {{mY}}
{{#randX}}
local randXStart = {{randXStart}}
local randXEnd = {{randXEnd}}
{{/randX}}
{{#randY}}
local randYStart = {{randYStart}}
local randYEnd = {{randYEnd}}
{{/randY}}
local elFontSize = {{elFontSize}}
{{/ultimate}}
local oriAlpha = {{oriAlpha}}
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = { "{{elVar}}", imageWidth, imageHeight, mX, mY, oriAlpha, {{elFont}}, elFontSize, {{elFontColor}} }
  {{/multLayers}}
  --
  layer.{{elControl}} = {{elTime}}
  layer.{{myLName}}Min = math.floor(layer.{{elControl}} / 60)
  layer.{{myLName}}Sec = layer.{{elControl}} % 60
  if (layer.{{myLName}}Sec < 10) then
     layer.{{myLName}}Sec = "0"..layer.{{myLName}}Sec
  end
  if (layer.{{myLName}}Min < 10) then
     layer.{{myLName}}Min = "0"..layer.{{myLName}}Min
  end
  layer.{{myLName}}Txt = layer.{{myLName}}Min..":"..layer.{{myLName}}Sec
  --
  {{^multLayers}}
    local {{myLName}}_options = { text = "{{elVar}}", x = mX, y = mY, fontSize = elFontSize, font = {{elFont}}, align = "{{elAlign}}" }
    layer.{{myLName}} = display.newText( {{myLName}}_options )
   if layer.{{myLName}} == nil then return end
    layer.{{myLName}}.anchorX = 0.5; layer.{{myLName}}.anchorY = 0;
    _K.repositionAnchor(layer.{{myLName}},0.5,0);
    layer.{{myLName}}:setFillColor ({{elFontColor}})
    layer.{{myLName}}.alpha = oriAlpha
    layer.{{myLName}}.oldAlpha = oriAlpha
    layer.{{myLName}}.oriX = mX
    layer.{{myLName}}.oriY = mY
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{myLName}} == nil then return end
  --
  local function upTime_{{myLName}}()
    layer.{{myLName}}Min = math.floor(layer.{{elControl}} / 60)
    layer.{{myLName}}Sec = layer.{{elControl}} % 60
    if (layer.{{myLName}}Sec < 10) then
      layer.{{myLName}}Sec = "0"..layer.{{myLName}}Sec
    end
    if (layer.{{myLName}}Min ~= - 1) then
      layer.{{myLName}}.text = layer.{{myLName}}Min..":"..layer.{{myLName}}Sec
    end
    if (layer.{{myLName}}Min < 10) then
      layer.{{myLName}}Min = "0"..layer.{{myLName}}Min
    end
    layer.{{elControl}} = layer.{{elControl}} - 1
    {{#elAction}}
       if (layer.{{elControl}} == -1) then
         UI.scene:dispatchEvent({name="action_{{elAction}}", layer=layer.{{myLName}} })

       end
    {{/elAction}}
  end
  --
  upTime_{{myLName}}()
  UI.upTime_{{myLName}} = upTime_{{myLName}}

  {{#elStarts}}
    _K.timerStash.{{myLName}} = timer.performWithDelay( 1000, upTime_{{myLName}}, layer.{{elControl}} + 1 )
  {{/elStarts}}
end
--
return _M
