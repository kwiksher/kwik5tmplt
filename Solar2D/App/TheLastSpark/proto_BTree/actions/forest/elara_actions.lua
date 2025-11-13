-- Elara Actions
-- Consolidated actions for Elara character
-- Accepts action parameter to specify which Elara action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Elara-specific actions
M.ACTIONS = {
    elara = function()
        return M.showObject("elara")
    end,

    scared = function()
        return M.changeToScared()
    end,
}

function M.changeToScared()
    -- Change Elara to scared state
    --
    -- Called from action flow:
    -- 1. forest_scene.tree has: [emotion elara scared]
    -- 2. btree parser parses as action name: "emotion elara scared"
    -- 3. action_controller.lua receives "emotion elara scared":
    --    - Matches pattern "^(%S+)%s+(.+)$" → actionType="emotion", actionWhat="elara scared"
    --    - Calls M.executeTreeAction("emotion", "elara scared")
    --    - Parses actionWhat with "(%S+)%s+(.+)" → character="elara", state="scared"
    --    - Calls actions.elara.execute("scared")
    -- 4. This function receives "scared" and executes changeToScared()

    local elaraView = require("views.forest.elara_display")
    return M.changeState("elara", "scared", elaraView)
end

return M