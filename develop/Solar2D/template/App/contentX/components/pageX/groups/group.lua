-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
---------------------
---------------------
{{^Table}}
-- Capture and set group position
 local function groupPos(obj)
    local minX, minY
    for i = 1, obj.numChildren do
       local currentRecord = obj[ i ]
       if i == 1 then
          minX = currentRecord.x - currentRecord.contentWidth * 0.5
          minY = currentRecord.y - currentRecord.contentHeight * 0.5
       end
       local mX = currentRecord.x - currentRecord.contentWidth * 0.5
       if mX < minX then
          minX = mX
       end
       local mY = currentRecord.y - currentRecord.contentHeight * 0.5
       if mY < minY then
          minY = mY
       end
    end
    obj.x = minX + obj.contentWidth * 0.5
    obj.y = minY + obj.contentHeight * 0.5
end
{{/Table}}
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
{{^Table}}
  layer.{{gname}} = display.newGroup()
  layer.{{gname}}.anchorX = 0.5
  layer.{{gname}}.anchorY = 0.5
  layer.{{gname}}.anchorChildren = true
  {{#children}}
    layer.{{gname}}:insert(layer.{{chldName}})
  {{/children}}
  {{#alpha}}
     layer.{{gname}}.alpha = {{alpha}}
  {{/alpha}}
  layer.{{gname}}.oldAlpha = layer.{{gname}}.alpha
  {{#scaleW}}
  layer.{{gname}}.xScale = {{scaleW}}
  {{/scaleW}}
  {{#scaleH}}
  layer.{{gname}}.yScale = {{scaleH}}
  {{/scaleH}}
  {{#rotation}}
  layer.{{gname}}.rotation = {{rotation}}
  {{/rotation}}
  layer.{{gname}}}.oriX = layer.{{gname}}}.x
  layer.{{gname}}}.oriY = layer.{{gname}}}.y
  layer.{{gname}}}.oriXs = layer.{{gname}}}.xScale
  layer.{{gname}}}.oriYs = layer.{{gname}}}.yScale
  sceneGroup:insert( layer.{{gname}}})
  groupPos( layer.{{gname}}})
{{/Table}}
end
--
function _M:didShow(UI)
end
--
function _M:toDispose(UI)
end
--
function _M:willHide(UI)
end
--
function _M:localVars(UI)
{{#Table}}
  UI.{{ggname}} = {}
  {{#children}}
    table.insert(UI.{{ggname}}, "{{chldName}}")
  {{/children}}
{{/Table}}
end
--
return _M