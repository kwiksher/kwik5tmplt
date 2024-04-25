local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}")

-- layerProps
-- local layerProps = {
--   blendMode = "{{blendMode}}",
--   height    =  {{bounds.bottom}} - {{bounds.top}},
--   width     = {{bounds.right}} - {{bounds.left}} ,
--   kind      = {{kind}},
--   name      = "{{parent}}{{name}}",
--   type      = "png",
--   x         = {{bounds.right}} + ({{bounds.left}} -{{bounds.right}})/2,
--   y         = {{bounds.top}} + ({{bounds.bottom}} - {{bounds.top}})/2,
--   alpha     = {{opacity}}/100,
-- }

local M = {
  name ="{{name}}",
  -- commonAsset = "{{common}}",
  -- class = "{{class}}", -- button, drag, canvas ...
  --
  -- buttonProps
  {{#settings}}
  type  = "{{type}}", -- tap, press
  over = "{{over}}",
  btaps = {{btaps}},
  mask = "{{mask}}",
  {{/settings}}
  actions={onTap = "{{actionName}}" },

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