-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = require("components.kwik.tabButFunction").new(scene)
--
local widget = require("widget")
local _K = require "Application"
--
-- scene, layer and sceneGroup should be INPUT
-- tab{{um}} should be INPUT
-- tabja["witch"] = {"p2_witch_ja.png", 180, 262, 550, 581, 1}
--
-- UI.tSearch = tabja
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

function _M:localVars (UI)
  self:buttonVars(UI)
end
--
function _M:localPos(UI)
  self:buttonLocal(UI)
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  local self       = UI.scene
  --
  local tab{{um}} = UI.tab{{um}}
  --
  if UI.tSearch["{{dois}}"] == nil then return end
    {{^Press}}
      {{^kwik}}
        layer.{{myLName}} = display.newImageRect( _K.imgDir.. UI.tSearch["{{dois}}"][1], _K.systemDir, UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][3] )
      {{/kwik}}
      {{#kwik}}
        layer.{{myLName}} = display.newImageRect( _K.imgDir.. UI.tSearch["{{dois}}"][1], _K.systemDir, UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][3]  )
      {{/kwik}}
      layer.{{myLName}}.x        = UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][4]
      layer.{{myLName}}.y        = UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][5]
      layer.{{myLName}}.alpha    = UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][8]
      layer.{{myLName}}.oldAlpha = UI.tSearch["{{dois}}"][2], UI.tSearch["{{dois}}"][8]
      {{#randX}}
        layer.{{myLName}}.x = math.random( randXStart, randXEnd);
      {{/randX}}
      {{#randY}}
        layer.{{myLName}}.y = math.random( randYStart, randYEnd);
      {{/randY}}
      {{#scaleW}}
          layer.{{myLName}}.xScale = {{scaleW}}
      {{/scaleW}}
      {{#scaleH}}
          layer.{{myLName}}.yScale = {{scaleH}}
      {{/scaleH}}
      {{#rotate}}
          layer.{{myLName}}:rotate({{rotate}});
      {{/rotate}}
      layer.{{myLName}}.oriX  = layer.{{myLName}}.x
      layer.{{myLName}}.oriY  = layer.{{myLName}}.y
      layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
      layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
      layer.{{myLName}}.name  = "{{myLName}}"
      sceneGroup.{{myLName}}  = layer.{{myLName}}
      sceneGroup:insert(layer.{{myLName}})
    {{/Press}}
    {{#Press}}
    local function on{{myLName}}Event(self)
       if layer.{{myLName}}.enabled == nil or layer.{{myLName}}.enabled then
         layer.{{myLName}}.type = "press"
        -- {{bfun}}(layer.{{myLName}})
         self.scene:dispatchEvent({name=UI.tSearch["{{dois}}"][7], layer=layer.{{myLName}}})
       end
    end
    --
    layer.{{myLName}} = widget.newButton {
       id          = "{{myLName}}",
       defaultFile = _K.imgDir.. UI.tSearch["{{dois}}"][1],
       overFile    = _K.imgDir.. UI.tSearch["{{dois}}"][6],
       width       = UI.tSearch["{{dois}}"][2],
       height      = UI.tSearch["{{dois}}"][3],
       onRelease   = on{{myLName}}Event, -- UI.tSearch["{{dois}}"][7
       baseDir     = _K.systemDir
    }
    --
    {{#mask}}
    local suffix = display.imageSuffix or ""
     {{#ultimate}}
      local maskName = "{{bn}}".. "_mask.jpg"
     {{/ultimate}}
     {{^ultimate}}
      local maskName = "{{bn}}".. "_mask" .. suffix..".jpg"
     {{/ultimate}}
    local mask = graphics.newMask(_K.imgDir.."p{{docNum}}/"..maskName, _K.systemDir)
    layer.{{myLName}}:setMask( mask )
    {{/mask}}
    --
    layer.{{myLName}}.x        = UI.tSearch["{{dois}}"][4]
    layer.{{myLName}}.y        = UI.tSearch["{{dois}}"][5]
    layer.{{myLName}}.oriX     = UI.tSearch["{{dois}}"][4]
    layer.{{myLName}}.oriY     = UI.tSearch["{{dois}}"][5]
    layer.{{myLName}}.oriXs    = UI.tSearch["{{dois}}"].xScale
    layer.{{myLName}}.oriYs    = UI.tSearch["{{dois}}"].yScale
    layer.{{myLName}}.alpha    = UI.tSearch["{{dois}}"][8]
    layer.{{myLName}}.oldAlpha = UI.tSearch["{{dois}}"][8]
    layer.{{myLName}}.name     = "{{myLName}}"
    sceneGroup.{{myLName}}     = layer.{{myLName}}
    sceneGroup:insert(layer.{{myLName}})
    {{/Press}}

  --
  {{#tabButFunction}}
    {{#mask}}
    local suffix = display.imageSuffix or ""
    local maskName = "{{bn}}".. "_mask" .. suffix..".jpg"
    local mask = graphics.newMask(_K.imgDir.."p1/"..maskName)
    layer.{{myLName}}:setMask( mask )
    {{/mask}}
    _M:createTabButFunction(UI, {obj={{tabButFunction.obj}}, btaps={{tabButFunction.btaps}}, eventName=UI.tSearch["{{dois}}"][7]})
  {{/tabButFunction}}
  --
  {{#button}}
    {{#buyProductHide}}
      --Hide button if purchase was already made
      local path = system.pathForFile ("{{inApp}}.txt", _K.DocumentsDir )
      local file = io.open( path, "r" )
      if file then
         --This page was purchased, do not show the BUY button
         {{layer}}.alpha = 0
      end
    {{/buyProductHide}}
  {{/button}}
end
--
function _M:toDispose(UI)
  local layer      = UI.layer
  if UI.tSearch["gotopagejp"] == nil then return end
  {{#tabButFunction}}
    _M:removeTabButFunction(UI, {obj={{tabButFunction.obj}}, eventName=UI.tSearch["{{dois}}"][7]})
  {{/tabButFunction}}
end
--
function _M:toDestroy(UI)
end
--
function _M:buttonVars(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
end
--
function _M:buttonLocal(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
end
--
return _M