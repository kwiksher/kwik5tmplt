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
  local sceneGroup  = UI.sceneGroup
  local layers       = UI.layers
{{^Table}}
  sceneGroup.{{gname}} = display.newGroup()
  sceneGroup.{{gname}}.anchorX = 0.5
  sceneGroup.{{gname}}.anchorY = 0.5
  sceneGroup.{{gname}}.anchorChildren = true
  {{#children}}
    sceneGroup.{{gname}}:insert(sceneGroup.{{chldName}})
  {{/children}}
  {{#alpha}}
     sceneGroup.{{gname}}.alpha = {{alpha}}
  {{/alpha}}
  sceneGroup.{{gname}}.oldAlpha = sceneGroup.{{gname}}.alpha
  {{#scaleW}}
  sceneGroup.{{gname}}.xScale = {{scaleW}}
  {{/scaleW}}
  {{#scaleH}}
  sceneGroup.{{gname}}.yScale = {{scaleH}}
  {{/scaleH}}
  {{#rotation}}
  sceneGroup.{{gname}}.rotation = {{rotation}}
  {{/rotation}}
  sceneGroup.{{gname}}}.oriX = sceneGroup.{{gname}}}.x
  sceneGroup.{{gname}}}.oriY = sceneGroup.{{gname}}}.y
  sceneGroup.{{gname}}}.oriXs = sceneGroup.{{gname}}}.xScale
  sceneGroup.{{gname}}}.oriYs = sceneGroup.{{gname}}}.yScale
  sceneGroup:insert( sceneGroup.{{gname}}})
  groupPos( sceneGroup.{{gname}}})
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