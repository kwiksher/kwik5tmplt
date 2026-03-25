local name = ...
local parent,root = newModule(name)

local layerProps = require(parent.."cat")

-- layerProps
-- local layerProps = {
--   blendMode = "",
--   height    =   - ,
--   width     =  -  ,
--   kind      = ,
--   name      = "",
--   type      = "png",
--   x         =  + ( -)/2,
--   y         =  + ( - )/2,
--   alpha     = /100,
-- }

local M = {
  name ="cat_button",
  -- commonAsset = "",
  -- class = "button", -- button, drag, canvas ...
  --
  -- buttonProps
  properties ={
    target = "cat",
    type  = "nil", -- tap, press
    eventType = NIL,
    over = "nil",
    btaps = 1,
    mask = "nil",
  },
  actions={onTap = "" },
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
