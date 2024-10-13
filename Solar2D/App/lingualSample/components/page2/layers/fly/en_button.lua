local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."en").layerProps

local M = {
  name ="en_button",
  properties = {
    target = "fly/en",
    type  = "", -- tap, touch
    eventType = "tap",
    over = "NIL",
    btaps = 1,
    mask = "NIL",
  },
  actions={
    onTap = "flyAnim"
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
