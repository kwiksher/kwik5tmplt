-- Cabin Actions
-- Consolidated actions for Cabin entity
-- Accepts action parameter to specify which Cabin action to execute

local bt = require("btree")
local M = {}

-- Scene objects reference
local sceneObjects = {}

-- Action constants
M.ACTIONS = {
    SHOW_INTERIOR = "show_interior",
    FOCUS_ON = "focus_on"
}

function M.initialize(objects)
    sceneObjects = objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for Cabin")
        return bt.FAILED
    end

    if action == M.ACTIONS.SHOW_INTERIOR then
        return M.showInterior()
    elseif action == M.ACTIONS.FOCUS_ON then
        return M.focusOn()
    else
        print("Error: Unknown Cabin action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.showInterior()
    if not sceneObjects.cabin then
        print("Error: Cabin object not found")
        return bt.FAILED
    end

    -- Show cabin interior
    -- This would typically change the cabin display to show interior
    print("Showing cabin interior")
    return bt.SUCCESS
end

function M.focusOn()
    if not sceneObjects.cabin then
        print("Error: Cabin object not found")
        return bt.FAILED
    end

    -- Focus camera on cabin
    -- This would typically move camera to focus on cabin
    print("Focusing on cabin")
    return bt.SUCCESS
end

return M