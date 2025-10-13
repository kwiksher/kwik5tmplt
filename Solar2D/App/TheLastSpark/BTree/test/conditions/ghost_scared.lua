-- conditions/ghost_scared.lua
-- Condition: Is the ghost in scared state?

local bt = require("btree")

local M = {}

function M.create(pacman, ghost, world)
    -- Check if ghost is scared (vulnerable)
    local isScared = ghost.scared

    return isScared and bt.SUCCESS or bt.FAILED
end

return M
