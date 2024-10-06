local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."{{layer}}").properties

local M = {
  name="{{name}}",
  --
  properties = {
    {{#properties}}
    target = "{{layer}}",
    type  = "{{type}}",
    isActive = "{{isActive}}",
    dbounds = { swipeLength = {{swipeLength}}, limitAngle = {{limitAngle}}, useStrictBounds = {{useStrictBounds}}}
    {{/properties}}
  },
  --
  actions={
    onUp = "{{onUp}}",
    onDown ="{{onDown}}",
    onRight ="{{onRight}}",
    onLeft  = "{{onLeft}}"
  },
  --
  layerProps = layerProps
}

function M:create(UI)
  self.UI = UI
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  --
  self:setSwipe(self.obj)
end

function M:didShow(UI)
  self.UI = UI
  self:addEventListener(self.obj)
end

function M:didHide(UI)
  self:removeEventListener(self.obj)
end

return require("components.kwik.layer_swipe").set(M)