-- Show Actions
-- Consolidated actions for show-related elements
-- Accepts action parameter to specify which show action to execute

local bt = require("utils.btree")

local M = {}
M.ACTION_NAME = "show"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

local function showChoiceButtons()
    -- Delegate to the proper show_choices_action module which handles RUNNING state
    local showChoicesModule = require("actions.narration.show_choices_action")
    return showChoicesModule.execute()
end

-- Register show-specific actions
local ACTIONS = {
    choices = showChoiceButtons,
}

-- Main execute function
-- @param actionTarget string - The target to show (e.g., "choices")
function M.execute(actionTarget)
    if not actionTarget then
        print("Show Action: No target specified")
        return bt.FAILED
    end

    local actionFunc = ACTIONS[actionTarget]
    if actionFunc then
        print("Show Action: Executing show " .. actionTarget)
        return actionFunc()
    else
        print("Show Action: Unknown target - " .. tostring(actionTarget))
        return bt.FAILED
    end
end

return M
