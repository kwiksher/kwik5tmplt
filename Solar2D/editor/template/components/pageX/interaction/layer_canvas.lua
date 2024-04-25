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
  name = "{{name}}",
  -- commonAsset = "{{common}}",
  -- class = "{{class}}", -- button, drag, canvas ...
  --
  -- canvasProps
  {{#settings}}
  autoSave   = true,
  brushSize  = 10,
  brushColor = {0, 0, 1},
  color      = {255, 255, 255}
  outline    = true,
  {{/settings}}
  --
  actions= nil,
  --
  layerProps = layerProps
}

function M:create(UI)
  self.UI = UI
  local sceneGroup = UI.sceneGroup
  local layerName  = self.layerProps.name
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    sefl.obj = sceneGroup
  end
  --
  self:setCanvas(self.obj)
end

return require("components.kwik.layer_canvas").set(M)