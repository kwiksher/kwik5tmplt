-- Lumin Seed Actions (Cabin Scene)
-- Consolidated actions for Lumin Seed entity in cabin scene
-- Accepts action parameter to specify which Lumin Seed action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Lumin Seed-specific actions
M.ACTIONS = {
    luminseed = function()
        return M.showObject("luminSeed")
    end,

    glowing = function()
        return M.changeToGlowing()
    end,
}

function M.changeToGlowing()
    local DisplayBase = require("views.display_base")
    return M.changeState("luminSeed", "glowing", DisplayBase)
end

return M
