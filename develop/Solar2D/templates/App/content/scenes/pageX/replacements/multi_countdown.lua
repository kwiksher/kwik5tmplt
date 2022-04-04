-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
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
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  if UI.tSearch["{{bn}}"] == nil then return end
  {{#multLayers}}
    layer.{{myLName}} = display.newText( UI.tSearch["{{bn}}"][1], UI.tSearch["{{bn}}"][4], UI.tSearch["{{bn}}"][5], UI.tSearch["{{bn}}"][7], UI.tSearch["{{bn}}"][8] )
    layer.{{myLName}}:setFillColor ( UI.tSearch["{{bn}}"][9])

    layer.{{myLName}}.alpha = UI.tSearch["{{bn}}"][6]
    layer.{{myLName}}.oldAlpha = UI.tSearch["{{bn}}"][6]
    layer.{{myLName}}.oriX = UI.tSearch["{{bn}}"][4]
    layer.{{myLName}}.oriY = UI.tSearch["{{bn}}"][5]
    layer.{{myLName}}.oriXs = layer.{{myLName}}.xScale
    layer.{{myLName}}.oriYs = layer.{{myLName}}.yScale

    layer.{{myLName}}.name = "{{myLName}}"
    sceneGroup:insert(layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
  {{/multLayers}}
--
  local function upTime{{myLName}}()
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
          {{elAction}}()
       end
    {{/elAction}}
  end
  --
  upTime{{myLName}}()
  {{#elStarts}}
    _K.timerStash.{{myLName}} = timer.performWithDelay( 1000, upTime{{myLName}}, layer.{{elControl+{{1 )
  {{/elStarts}}
end
--
return _M
