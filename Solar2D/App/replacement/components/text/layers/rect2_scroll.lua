local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="rect2",
  --
  properties = {
    target = "rect2",
    contents  = "group0",
    type  = "group",
    isActive = "true",
    area     = "layer",
    hideBackGround = true,
    horizontalScrollDisabled = false,
    verticalScrollDisabled = true,
    positionX = nil,
    positionY = nil,
    width = (1382 - 533 )/4,
    height   = (876 - 374)/4,
    -- scrollWidth = nil, --(1382 - 533 )/4,
    -- scrollHeight   = nil, -- (876 - 374)/4
  },
  --
  actions={},
  --
  layerProps = layerProps
}
-- if M.properties.area == "paragraph" then
--   M.properties.width  = (1382 - 533 )/4
-- end
-- if M.properties.area == "object" or M.properties.area =="layer" then
--   M.properties.width = (1382 - 533 )/4
-- end
-- if M.properties.area == "page" then
--   M.properties.width, M.properties.height   = (1382 - 533 )/4, (876 - 374)/4
--   M.properties.scrollWidth, M.properties.scrollHeight = 3*(1382 - 533 )/4, (876 - 374)/4
-- end
-- if M.properties.area == "manual" then
--   -- if M.properties.is1x then
--   --   local top, left   = ,
--   --   local width, height   = ,
--   --   local scrollWidth, scrollHeight = ,
--   -- else

--     M.properties.top, M.properties.left   = 1382 + (533 -1382)/2,   374 + (876 - 374)/2
--     M.properties.width, M.properties.height   =  (1382 - 533 )/4, (876 - 374)/4
--     M.properties.scrollWidth,M.properties.scrollHeight =  3*(1382 - 533 )/4, (876 - 374)/4
--   -- end
-- end
function M:create(UI)
end
function M:didShow(UI)
  self:setScroll(UI)
end
function M:didHide(UI)
end
return require("components.kwik.layer_scroll").set(M)