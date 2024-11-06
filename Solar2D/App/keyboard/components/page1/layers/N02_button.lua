local name = ...
local parent,root = newModule(name)
local layerProps = require(parent.."N02").layerProps
local M = {
  name ="N02_button",
  properties = {
    target = "N02",
    type  = "",
    eventType = "tap",  -- tap, touch
    over = "",
    btaps = 1,
    mask = "",
  },
  actions={
    onTap = "onN02"
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
