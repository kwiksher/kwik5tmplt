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
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
    if UI.tSearch["{{bn}}"] == nil then return end
    layer.{{myLName}} = native.newMapView( UI.tSearch["{{bn}}"][4], UI.tSearch["{{bn}}"][5], UI.tSearch["{{bn}}"][2], UI.tSearch["{{bn}}"][3] )
    layer.{{myLName}}.mapType =  UI.tSearch["{{bn}}"][8]
    layer.{{myLName}}:setCenter(UI.tSearch["{{bn}}"][6], UI.tSearch["{{bn}}"][7] )
    layer.{{myLName}}.isScrollEnabled = UI.tSearch["{{bn}}"][10]
    layer.{{myLName}}.isZoomEnabled =UI.tSearch["{{bn}}"][9]

    {{#elMarker}}
        layer.{{myLName}}:addMarker(UI.tSearch["{{bn}}"][6], UI.tSearch["{{bn}}"][7], {title=UI.tSearch["{{bn}}"][12], subtitle=UI.tSearch["{{bn}}"][13] } )
    {{/elMarker}}

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
        layer.{{myLName}}:rotate( {{rotate}});
    {{/rotate}}

    layer.{{myLName}}.oriX = layer.{{myLName}}.x
    layer.{{myLName}}.oriY = layer.{{myLName}}.y
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale

    layer.{{myLName}}.alpha = UI.tSearch["{{bn}}"][14]
    layer.{{myLName}}.oldAlpha = UI.tSearch["{{bn}}"][14]
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
end
--
function _M:toDispose(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#multLayers}}
  if layer.{{myLName}} ~= nil then
     layer.{{myLName}}:removeSelf()
   layer.{{myLName}} = nil
  end
  {{/multLayers}}
end
--
return _M