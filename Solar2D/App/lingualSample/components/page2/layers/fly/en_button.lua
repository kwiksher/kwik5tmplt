local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."en").layerProps

local M = {
  name ="en_button",
  properties = {
    target = "fly/en",
    type  = "", -- tap, touch
    eventType = "tap",
    over = "flyOver",
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
  if UI.langClassDelegate then
    local t = self.properties.target:split("/")
    self.properties.target = t[1].."/".. UI.lang
  end

  local sceneGroup = UI.sceneGroup
  local obj =  self:createButton(UI)
  UI.layers[self.properties.target] = obj
  sceneGroup[self.properties.target] = obj
  if obj then
    sceneGroup:insert(obj)
  else
    print("Error", self.properties.target)
  end
end

function M:didShow(UI)
  self:addEventListener(UI)
end

function M:didHide(UI)
  self:removeEventListener(UI)
end

return require("components.kwik.layer_button").set(M)
