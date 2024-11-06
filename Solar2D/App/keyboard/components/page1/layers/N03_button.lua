local name = ...
local parent,root = newModule(name)
local layerProps = require(parent.."N03").layerProps
local M = {
  name ="N03_button",
  properties = {
    target = "N03",
    type  = "",
    eventType = "tap",  -- tap, touch
    over = "",
    btaps = 1,
    mask = "",
  },
  actions={
    onTap = "onN03"
  },
  -- buyProductHide =
  -- product       =
  -- TV =
  layerProps = layerProps
}
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local obj =  self:createButton(UI)
  UI.layers[self.properties.target] = obj
  sceneGroup[self.properties.target] = obj
  sceneGroup:insert(obj)
end
function M:didShow(UI)
  self:addEventListener(UI)
end
function M:didHide(UI)
  self:removeEventListener(UI)
end
return require("components.kwik.layer_button").set(M)
