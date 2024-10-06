local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}").properties

-- if (String(ghasl) == "true" &&  String(ghasu) == "false") {
--   model.dbounds = ' { minAngle = '+glow+' }'
-- } else if (String(ghasu) == "true"  && String(ghasl) == "false") {
--   model.dbounds = '{ maxAngle = '+gupper+' }'
-- }  else if (String(ghasl) == "true"  && String(ghasu) == "true") {
--   model.dbounds = '{ minAngle = '+glow+', maxAngle =  '+gupper+' }'
-- }

local M = {
  name="{{name}}",
  --
  properties = {
    {{#properties}}
    target = "{{layer}}",
    type  = "{{type}}",
    constrainAngle = {{constrainAngle}},
    xStart={{xStart}}, xEnd={{xEnd}}, yStart={{yStart}}, yEnd={{yEnd}},
    isActive = "{{isActive}}",
    {{/properties}}
  },
  --
  actions={
    onClokwise = "{{onClokwise}}",
    onCounterClockwise ="{{onCounterClockwise}}",
    onReleased ="{{onReleased}}",
    onShapeHandler = "{{onShapeHandler}}"
    -- onMoved="{{}}"
  },
  --
  layerProps = layerProps
}

function M:create(UI)
  self:setSpin(UI)
end

function M:didShow(UI)
  self:activate(UI)
end

function M:didHide(UI)
  self:deactivate(UI)
end

return require("components.kwik.layer_pinch").set(M)