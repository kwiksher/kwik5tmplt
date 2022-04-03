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
  {{#idist}}
  local idist = {{idist}}/4
  {{/idist}}
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
  {{#idist}}
  local idist = {{idist}}
  {{/idist}}
{{/ultimate}}
--
function _M:myMain()
end
--
function _M:localVars()
end
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if UI.tSearch["{{bn}}"] == nil then return end
  {{#multLayers}}
    layer.{{myLName}} = display.newImageRect( _K.imgDir.. UI.tSearch["{{bn}}"][1], _K.systemDir, UI.tSearch["{{bn}}"][2], UI.tSearch["{{bn}}"][3] );
    layer.{{myLName}}.x        = UI.tSearch["{{bn}}"][4]
    layer.{{myLName}}.y        = UI.tSearch["{{bn}}"][5]
    layer.{{myLName}}.alpha    = UI.tSearch["{{bn}}"][6]
    layer.{{myLName}}.oldAlpha = UI.tSearch["{{bn}}"][6]
    {{#randX}}
      layer.{{myLName}}.x = math.random( randXStart}}, randXEnd);
    {{/randX}}
    {{#randY}}
      layer.{{myLName}}.y = math.random( randYStart}}, randYEnd);
    {{/randY}}
    {{#scaleW}}
      layer.{{myLName}}.xScale = {{scaleW}}
    {{/scaleW}}
    {{#scaleH}}
      layer.{{myLName}}.yScale = {{scaleH}}
    {{/scaleH}}
    {{#rotate}}
      layer.{{myLName}}:rotate( {{rotate))
    {{/rotate}}
    layer.{{myLName}}.oriX  = layer.{{myLName}}.x
    layer.{{myLName}}.oriY  = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale
    layer.{{myLName}}.name  = "{{myLName}}"
    sceneGroup.{{myLName}}  = layer.{{myLName}}
    --
    {{#layerAsBg}}
      sceneGroup:insert( 1, layer.{{myLName}})
    {{/layerAsBg}}
    {{^layerAsBg}}
      sceneGroup:insert( layer.{{myLName}})
    {{/layerAsBg}}
    --
    {{#infinity}}
      sceneGroup:insert( layer.{{myLName}}_2)
      sceneGroup.{{myLName}}_2    = layer.{{myLName}}_2
      layer.{{myLName}}.anchorX   = 0
      layer.{{myLName}}.anchorY   = 0;
      repositionAnchor(layer.{{myLName}}, 0,0)
      layer.{{myLName}}_2.anchorX = 0
      layer.{{myLName}}_2.anchorY = 0;
      repositionAnchor(layer.{{myLName}}_2, 0,0)
      {{#up}}
        layer.{{myLName}}.x = layer.{{myLName}}.oriX
        layer.{{myLName}}.y = 0;
        {{#idist}}
          layer.{{myLName}}_2.y        = layer.{{myLName}}.height + idist
          layer.{{myLName}}_2.x        = layer.{{myLName}}.oriX;
          layer.{{myLName}}.distance   = idist
          layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.y = layer.{{myLName}}.height
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
        {{/idist}}
        layer.{{myLName}}.enterFrame   = infinityBack
        layer.{{myLName}}.speed        = {{infinitySpeed}}
        layer.{{myLName}}.direction    = "{{idir}}"
        layer.{{myLName}}_2.enterFrame = infinityBack
        layer.{{myLName}}_2.speed      = {{infinitySpeed}}
        layer.{{myLName}}_2.direction  = "{{idir}}"
      {{/up}}
      {{#down}}
        layer.{{myLName}}.x = layer.{{myLName}}.oriX
        layer.{{myLName}}.y = 0
        {{#idist}}
          layer.{{myLName}}_2.y      = -layer.{{myLName}}.height - idist
          layer.{{myLName}}_2.x      = layer.{{myLName}}.oriX;
          layer.{{myLName}}.distance = idist
          layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.y = -layer.{{myLName}}.height
          layer.{{myLName}}_2.x = layer.{{myLName}}.oriX;
        {{/idist}}
        layer.{{myLName}}.enterFrame = infinityBack
        layer.{{myLName}}.speed = {{infinitySpeed}}
        layer.{{myLName}}.direction = "{{idir}}"
        layer.{{myLName}}_2.enterFrame = infinityBack
        layer.{{myLName}}_2.speed = {{infinitySpeed}}
        layer.{{myLName}}_2.direction = "{{idir}}"
      {{/down}}
      {{#right}}
        layer.{{myLName}}.x = 0
        layer.{{myLName}}.y = layer.{{myLName}}.oriY;
        {{#idist}}
          layer.{{myLName}}_2.x = -layer.{{myLName}}.width + idist
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
          layer.{{myLName}}.distance = idist
          layer.{{myLName}}_2.distance = idist
        {{/idist}}
        {{^idist}}
          layer.{{myLName}}_2.x = -layer.{{myLName}}.width
          layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
        {{/idist}}
        layer.{{myLName}}.enterFrame = infinityBack
        layer.{{myLName}}.speed = {{infinitySpeed}}
        layer.{{myLName}}.direction = "{{idir}}"
        layer.{{myLName}}_2.enterFrame = infinityBack
        layer.{{myLName}}_2.speed = {{infinitySpeed}}
        layer.{{myLName}}_2.direction = "{{idir}}"
      {{/right}}
      {{#left}}
        layer.{{myLName}}.x = 0
        layer.{{myLName}}.y = layer.{{myLName}}.oriY;
         {{#idist}}
            layer.{{myLName}}_2.x = layer.{{myLName}}.width + idist
            layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
            layer.{{myLName}}.distance = idist
            layer.{{myLName}}_2.distance = idist
         {{/idist}}
         {{^idist}}
            layer.{{myLName}}_2.x = layer.{{myLName}}.width
            layer.{{myLName}}_2.y = layer.{{myLName}}.oriY;
         {{/idist}}
        layer.{{myLName}}.enterFrame = infinityBack
        layer.{{myLName}}.speed = {{infinitySpeed}}
        layer.{{myLName}}.direction = "{{idir}}"
        layer.{{myLName}}_2.enterFrame = infinityBack
        layer.{{myLName}}_2.speed = {{infinitySpeed}}
        layer.{{myLName}}_2.direction = "{{idir}}"
      {{/left}}
    {{/infinity}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    {{#infinity}}
     -- Infinity background
     Runtime:addEventListener("enterFrame", layer.{{myLName}})
     Runtime:addEventListener("enterFrame", layer.{{myLName}}_2)
    {{/infinity}}
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    {{#infinity}}
      if layer.{{myLName}} ~=nil and layer.{{myLName}}_2 ~=nil then
      Runtime:removeEventListener("enterFrame", layer.{{myLName}})
      Runtime:removeEventListener("enterFrame", layer.{{myLName}}_2)
      end
    {{/infinity}}
  {{/multLayers}}
end
--
function  _M:toDestory()
end
--
return _M