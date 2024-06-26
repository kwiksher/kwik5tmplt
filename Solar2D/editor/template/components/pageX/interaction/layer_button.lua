local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}")

local M = {
  name ="{{layer}}_button",
  {{#properties}}
  target = "{{layer}}",
  type  = "{{type}}", -- tap, touch
  over = "{{over}}",
  btaps = {{btaps}},
  mask = "{{mask}}",
  {{/properties}}
  actions={
  {{#actions}}
    onTap = "{{onTap}}"
  {{/actions}}
  },

    -- buyProductHide = {{buyProductHide}}
    -- product       = {{inApp}}
    -- TV = {{TV}}
  layerProps = layerProps
}

function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local obj =  self:createButton(UI)
  UI.layers[self.name] = obj
  sceneGroup[self.name] = obj
  sceneGroup:insert(obj)
end

function M:didShow(UI)
  self:addEventListener(UI)
end

function M:didHide(UI)
  self:removeEventListener(UI)
end

return require("components.kwik.layer_button").set(M)