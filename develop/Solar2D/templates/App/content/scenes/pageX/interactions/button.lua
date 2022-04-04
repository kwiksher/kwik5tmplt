-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = require("components.kwik.tabButFunction").new(scene)
--
local widget = require("widget")
local _K = require "Application"
{{#buyProductHide}}
local model       = require("components.store.model")
local IAP    = require ( "components.store.IAP" )
local view        = require("components.store.view").new()
{{/buyProductHide}}
--
-- scene, layer and sceneGroup should be INPUT
-- tab{{um}} should be INPUT
-- tabja["witch"] = {"p2_witch_ja.png", 180, 262, 550, 581, 1}
--
-- UI.tSearch = tabja
--
{{#bn}}
{{#ultimate}}
local imageWidth             = {{elW}}/4
local imageHeight            = {{elH}}/4
local mX, mY                 = _K.ultimatePosition({{mX}}, {{mY}}, "{{align}}")
{{#randX}}
local randXStart = _K.ultimatePosition({{randXStart}})
local randXEnd = _K.ultimatePosition({{randXEnd}})
{{/randX}}
{{#randY}}
local dummy, randYStart = _K.ultimatePosition(0, {{randYStart}})
local dummy, randYEnd     = _K.ultimatePosition(0, {{randYEnd}})
{{/randY}}
{{#idist}}
local idist     = {{idist}}/4
{{/idist}}
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
{{#idist}}
local idist     = {{idist}}
{{/idist}}
{{/ultimate}}
local oriAlpha = {{oriAlpha}}
--
{{#kwk}}
local imagePath = "{{bn}}.{{fExt}}"
{{/kwk}}
{{^kwk}}
local imageName = "/{{bn}}.{{fExt}}"
{{/kwk}}
{{/bn}}

function _M:localVars (UI)
   {{#isTmplt}}
   {{^kwk}}
   local imagePath = "p"..UI.imagePage..imageName
   {{/kwk}}
   mX, mY, imageWidth, imageHeight , imagePath = _K.getModel("{{myLName}}", imagePath, UI.dummy)
   {{/isTmplt}}
  self:buttonVars(UI)
end
--
function _M:localPos(UI)
  {{#buyProductHide}}
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  -- Page properties
  view:init(sceneGroup, layer)
  IAP:init(model.catalogue, view.restoreAlert, view.purchaseAlert, function(e) print("IAP cancelled") end, model.debug)
  {{/buyProductHide}}

  self:buttonLocal(UI)
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  local self       = UI.scene
  --
  {{^multLayers}}
  {{#tabButFunction}}
  if {{tabButFunction.obj}} == nil then return end
    {{#mask}}
    local suffix = display.imageSuffix or ""
   {{#ultimate}}
    local maskName = "{{bn}}".. "_mask.jpg"
   {{/ultimate}}
   {{^ultimate}}
    local maskName = "{{bn}}".. "_mask" .. suffix..".jpg"
   {{/ultimate}}
    local mask = graphics.newMask(_K.imgDir.."p{{docNum}}/"..maskName, _K.systemDir )
    layer.{{myLName}}:setMask( mask )
    {{/mask}}
    _M:createTabButFunction(UI, {obj={{tabButFunction.obj}}, btaps={{tabButFunction.btaps}}, eventName="{{myLName}}_{{layerType}}_{{triggerName}}"})
  {{/tabButFunction}}
    {{#buyProductHide}}
      --Hide button if purchase was already made
    if IAP.getInventoryValue("unlock_".."{{inApp}}") then
         --This page was purchased, do not show the BUY button
       layer.{{layer}}.alpha = 0
      end
    {{/buyProductHide}}
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local layer      = UI.layer
  local sceneGroup = UI.scene.view

  {{^multLayers}}
  {{#tabButFunction}}
  if {{tabButFunction.obj}} == nil then return end
    _M:removeTabButFunction(UI, {obj={{tabButFunction.obj}}, eventName="{{myLName}}_{{layerType}}_{{triggerName}}"})
  {{/tabButFunction}}
  {{/multLayers}}
end
--
function _M:toDestroy(UI)
end
--
function _M:buttonVars(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
  {{#multLayers}}
  {{^kwk}}
  local imagePath = "p"..UI.imagePage..imageName
  {{/kwk}}
     UI.tab{{um}}["{{dois}}"] = {imagePath,imageWidth, imageHeight, mX, mY, imagePath, "{{myLName}}_{{layerType}}_{{triggerName}}", oriAlpha }
  {{/multLayers}}
end
--
function _M:buttonLocal(UI)
  local sceneGroup = UI.scene.view
  local layer      = UI.layer
{{#bn}}
  {{^multLayers}}
  {{^kwk}}
  local imagePath = "p"..UI.imagePage..imageName
  {{/kwk}}
    {{^Press}}
       layer.{{myLName}} = display.newImageRect( _K.imgDir.. imagePath, _K.systemDir, imageWidth, imageHeight )
    if layer.{{myLName}} == nil then return end
      layer.{{myLName}}.x        = mX
      layer.{{myLName}}.y        = mY
      layer.{{myLName}}.alpha    = oriAlpha
      layer.{{myLName}}.oldAlpha = oriAlpha
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
      layer.{{myLName}}.blendMode = "{{bmode}}"
      sceneGroup.{{myLName}}  = layer.{{myLName}}
      sceneGroup:insert(layer.{{myLName}})
    {{/Press}}
    {{#Press}}
        local function on{{myLName}}Event(self)
          if layer.{{myLName}}.enabled == nil or layer.{{myLName}}.enabled then
             layer.{{myLName}}.type = "press"
            -- {{bfun}}(layer.{{myLName}})
            {{#TV}}
             if layer.{{myLName}}.isKey then
                UI.scene:dispatchEvent({name="{{myLName}}_{{layerType}}_{{triggerName}}", layer=layer.{{myLName}} })
             end
            {{/TV}}
            {{^TV}}
              UI.scene:dispatchEvent({name="{{myLName}}_{{layerType}}_{{triggerName}}", layer=layer.{{myLName}} })
            {{/TV}}
           end
        end
        layer.{{myLName}} = widget.newButton {
           id          = "{{myLName}}",
           defaultFile = _K.imgDir..imagePath,
           overFile    = _K.imgDir.."{{bOver}}.{{rExt}}",
           width       = imageWidth,
           height      = imageHeight,
           onRelease   = on{{myLName}}Event,
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
        layer.{{myLName}}.x        = mX
        layer.{{myLName}}.y        = mY
        layer.{{myLName}}.oriX     = mX
        layer.{{myLName}}.oriY     = mY
        layer.{{myLName}}.oriXs    = layer.{{myLName}}.xScale
        layer.{{myLName}}.oriYs    = layer.{{myLName}}.yScale
        layer.{{myLName}}.alpha    = oriAlpha
        layer.{{myLName}}.oldAlpha = oriAlpha
        layer.{{myLName}}.name     = "{{myLName}}"
        layer.{{myLName}}.on     = on{{myLName}}Event
        sceneGroup.{{myLName}}     = layer.{{myLName}}
        sceneGroup:insert(layer.{{myLName}})
    {{/Press}}
  {{/multLayers}}
{{/bn}}
end
--
return _M