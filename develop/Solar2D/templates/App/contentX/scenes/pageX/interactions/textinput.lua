-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
local Var = require("components.kwik.vars")
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{myLName}} == nil then return end
  {{#variable}}
    if Var:kwkVarCheck("{{elContent}}") ~= nil then
       UI.{{elContent}} = Var:kwkVarCheck("{{elContent}}")
       layer.{{myLName}}.text=UI.{{elContent }}
    else
       layer.{{myLName}}.text="{{contents}}"
    end
  {{/variable}}
  --
  local function fieldHandler_{{myLName}}(event)
    if ("began" == event.phase) then
    elseif ("ended" == event.phase) then
    elseif ("submitted" == event.phase) then
      {{#variable}}
         UI.{{elContent}} = layer.{{myLName}}.text
      {{/variable}}
      {{^variable}}
        local path = system.pathForFile( "{{elContent}}", _K.DocumentsDir )
        local file = io.open( path, "w+" )
        file:write( layer.{{myLName}}.text )
        io.close( file )
      {{/variable}}
      {{#dynamic}}
        layer.{{$.kwik.myProj.pages.page[myi].replacement[bi].name}}.text = UI.{{elContent}}
      {{/dynamic}}
      {{#elTrigger}}
           UI.scene:dispatchEvent({name="action_{{elTrigger}}", layer=layer.{{myLName}} })
      {{/elTrigger}}
      native.setKeyboardFocus(nil)
      end
    end
  {{^multLayers}}
    layer.{{myLName}}:addEventListener( "userInput", fieldHandler_{{myLName}} )
  {{/multLayers}}
end
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
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = { {{elKey}}, imageWidth, imageHeight, mX, mY, oriAlpha }
  {{/multLayers}}
  {{^multLayers}}
    layer.{{myLName}} = native.newTextField( mX, mY, imageWidth, imageHeight )
    layer.{{myLName}}.input = "{{elKey}}"
    {{#randX}}
      layer.{{myLName}}.x = math.random(randXStart, randXEnd)
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random(randYStart, randYEnd)
    {{/randY}}
    {{#scaleW}}
      layer.{{myLName}}.xScale = {{scaleW}}
    {{/scaleW}}
    {{#scaleH}}
      layer.{{myLName}}.yScale = {{scaleH}}
    {{/scaleH}}
    {{#rotate}}
      layer.{{myLName}}:rotate( {{rotate}})
    {{/rotate}}
    layer.{{myLName}}.anchorX = 0.5
    layer.{{myLName}}.anchorY = 0;
    _K.repositionAnchor(layer.{{myLName}},0.5,0);
    layer.{{myLName}}.oriX = layer.{{myLName}}.x
    layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if layer.{{myLName}} == nil then return end
  {{^multLayers}}
    layer.{{myLName}}:removeSelf()
    layer.{{myLName}} = nil
  {{/multLayers}}
end
--
function _M:localVars()
end
--
return _M