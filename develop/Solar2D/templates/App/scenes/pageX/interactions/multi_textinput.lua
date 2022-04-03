-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
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
--
local Var = require("components.kwik.vars")
local _K = require "Application"
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  if UI.tSearch["{{bn}}"] == nil then return end
  local function fieldHandler_{{myLName}}(event)
    if ("began" == event.phase) then
    elseif ("ended" == event.phase) then
    elseif ("submitted" == event.phase) then
      {{#variable}}
         {{elContent}} = layer.{{myLName}}.text
      {{/variable}}
      {{^variable}}
        local path = system.pathForFile( "{{elContent}}", _K.DocumentsDir )
        local file = io.open( path, "w+" )
        file:write( layer.{{myLName}}.text )
        io.close( file )
      {{/variable}}
      {{#dynamic}}
        layer.{{$.kwik.myProj.pages.page[myi].replacement[bi].name}}.text = {{elContent}}
      {{/dynamic}}
      {{#elTrigger}}
           UI.scene:dispatchEvent({name="action_{{elTrigger}}", layer=layer.{{myLName}} })
      {{/elTrigger}}
      native.setKeyboardFocus(nil)
      end
    end

  {{#multLayers}}
    layer.{{myLName}} = native.newTextField( UI.tSearch["{{bn}}"][4], UI.tSearch["{{bn}}"][5], UI.tSearch["{{bn}}"][2], UI.tSearch["{{bn}}"][3])
    layer.{{myLName}}.input =  UI.tSearch["{{bn}}"][1]
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
    --
  {{#variable}}
    if Var:kwkVarCheck("{{elContent}}") ~= nil then
       {{elContent}} = Var:kwkVarCheck("{{elContent}}")
       layer.{{myLName}}.text={{elContent }}
    else
       layer.{{myLName}}.text="{{contents}}"
    end
  {{/variable}}
  --

    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
    layer.{{myLName}}:addEventListener( "userInput", fieldHandler_{{myLName}} )
  {{/multLayers}}
end

function _M:localVars()
end

function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
end

function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
  if UI.tSearch["{{bn}}"] == nil then return end
    layer.{{myLName}}:removeSelf()
    layer.{{myLName}} = nil
  {{/multLayers}}
end

function _M:localVars()
end

return _M