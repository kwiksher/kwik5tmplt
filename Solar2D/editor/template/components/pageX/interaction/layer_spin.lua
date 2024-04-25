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
  name="{{name}}",
  --
  {{#settings}}
  constrainAngle = nil,
  bounds = {xStart=nil, xEnd=nil, yStart=nil, yEnd=nil},
  isActive = "{{isActive}}",
  {{/settings}}
  --
  actions={
    onClokwise = "{{}}",
    onCounterClockwise ="{{}}",
    onReleased ="{{}}",
    -- onMoved="{{}}"
  },
  --
  layerProps = layerProps
}

function M:create(UI)
  self.UI = UI
  local sceneGroup = UI.sceneGroup
  local layerName  = self.layerProps.name
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  --
  self:setSpin(self.obj)
end

function M:didShow(UI)
  self.UI = UI
  self:addEventListener(self.obj)
end

function M:didHide(UI)
  self:removeEventListener(self.obj)
end

return require("components.kwik.layer_spin").set(M)