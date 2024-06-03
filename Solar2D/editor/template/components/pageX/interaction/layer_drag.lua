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
  -- dragProps
  {{#properties}}
  constrainAngle = nil,
  bounds = {xStart=nil, xEnd=nil, yStart=nil, yEnd=nil},
  isActive = "{{isActive}}",
  isFocus = true,
  isPage = false,
  --
  isFlip = true,
  flipAxis = "x", -- "y",
  flipValue      = 0,
  flipDirection  = "right", -- "left", "bottom", "top"
  flipDirecttion1 = "right",
  flipDirecttion2 = "left",
  flipScale = 1, -- -1
  --
  isDrop = true,
  dropLayer = "",
  dropMargin = 10,
  --
  dropBound = {xStart=0, xEnd=0, yStart = 0, yEnd=0},
  --
  rock = 1, -- 0,
  backToOrigin = true,
  {{/properties}}
  --
  actions={
    onDropped = "{{actionName}}",
    onReleased ="{{}}",
    onMoved="{{}}" },
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
  self:activate(self.obj)
end

function M:didShow(UI)
  self.UI = UI
  self:addEventListener(self.obj)
end

function M:didHide(UI)
  self:removeEventListener(self.obj)
end

return require("components.kwik.layer_drag").set(M)