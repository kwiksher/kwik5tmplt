local name = ...
local parent,root = newModule(name)

local props = require(root.."model").pageTools.group
props.anchorName = "selectGroup"
props.icons      = {"groups", "trash"}
props.type       = "groups"

local M = require(root.."baseTable").new(props)

M.x = display.contentCenterX
M.y = 20

function M:init(UI, x, y)
  self.x = x or self.x
  self.y = y or self.y
end
-- function M:setPosition()
--   self.x = self.rectWidth/2 + 22
--   self.y = self.rootGroup.selectLayer.y + marginY
-- end

return M
