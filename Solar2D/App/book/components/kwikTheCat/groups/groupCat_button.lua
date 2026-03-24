local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."groupCat").properties

local M = {
  name ="groupCat_button",
  properties = {
    target = "groupCat",
    type  = "group", -- tap, touch
    eventType = "touch",
    over = "NIL",
    btaps = 1,
    mask = "NIL",
  },
  actions={
    onTap = ""
  },

  -- buyProductHide =
  -- product       =
  -- TV =
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
