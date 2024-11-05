local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."ok").layerProps

local M = {
  name ="ok_button",
  properties = {
    target = "ok",
    type  = "",
    eventType = "touch",  -- tap, touch
    over = "OkDown",
    btaps = 1,
    mask = "NIL",
  },
  actions={
    onTap = "onOK"
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
