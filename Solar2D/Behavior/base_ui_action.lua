-------------------------------------------------------------------------------
-- Base UI Action
-- Base class for UI-related actions
-- Provides common functionality for registering and executing UI actions
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

local BaseUIAction = {}

-------------------------------------------------------------------------------
-- Creates a new UI action module
-- @param actions table - Map of action names to action functions
-- @return table - Action module with UI action functionality
-------------------------------------------------------------------------------
function BaseUIAction.new(actions)
    -- Create action module with helper methods
    local M = actionHelper.createModule()

    -- Store scene objects reference
    M.sceneObjects = nil

    -- Override initialize to capture scene objects reference
    function M.initialize(objects)
        M.sceneObjects = objects
    end

    -- Helper to list all action names
    function M.listActionNames()
        local names = {}
        for name, _ in pairs(M.ACTIONS) do
            table.insert(names, name)
        end
        return names
    end

    -- Override execute to add logging and action lookup
    function M.execute(actionName)
        print("UI Actions: Received action name = '" .. tostring(actionName) .. "'")
        print("UI Actions: Available actions = " .. table.concat(M.listActionNames(), ", "))

        if not actionName then
            print("UI Actions: Error - No action specified")
            return bt.FAILED
        end

        -- Look up action in registry
        if M.ACTIONS[actionName] then
            print("UI Actions: Found action, executing...")
            return M.ACTIONS[actionName]()
        else
            print("UI Actions: Error - Unknown action '" .. tostring(actionName) .. "'")
            return bt.FAILED
        end
    end

    -- Register the provided actions
    M.ACTIONS = actions or {}

    return M
end

return BaseUIAction
