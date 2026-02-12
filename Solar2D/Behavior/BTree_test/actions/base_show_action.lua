-------------------------------------------------------------------------------
-- Base Show Action
-- Base class for show actions that display various UI elements
-- Manages action registration and execution
-------------------------------------------------------------------------------
local bt = require("utils.btree")

local BaseShowAction = {}

-------------------------------------------------------------------------------
-- Creates a new show action module
-- @param showConfig table - Map of action names to action functions
-- @return table - Action module with show functionality
-------------------------------------------------------------------------------
function BaseShowAction.new(showConfig)
    local M = {}

    M.ACTION_NAME = "show"

    local sceneObjects = {}

    -- Store show configuration
    local config = showConfig or {}

    function M.initialize(objects)
        sceneObjects = objects
    end

    -- Register actions from the show config
    M.ACTIONS = {}
    for key, actionFunc in pairs(config) do
        M.ACTIONS[key] = actionFunc
    end

    -- Main execute function - routes to specific show action
    -- @param actionTarget string - The target to show (e.g., "choices")
    function M.execute(actionTarget)
        if not actionTarget then
            print("Show Action: No target specified")
            return bt.FAILED
        end

        local actionFunc = M.ACTIONS[actionTarget]
        if actionFunc then
            print("Show Action: Executing show " .. actionTarget)
            return actionFunc()
        else
            print("Show Action: Unknown target - " .. tostring(actionTarget))
            return bt.FAILED
        end
    end

    return M
end

return BaseShowAction
