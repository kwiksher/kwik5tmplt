-- Focus Actions
-- Consolidated actions for focus management
-- Accepts action parameter to specify which focus action

local bt = require("btree")
local M = {}

-- Scene objects reference
local sceneObjects = {}

-- Action constants
M.ACTIONS = {
    FOCUS_ON_WOLF = "focus_on_wolf",
    FOCUS_ON_ELARA = "focus_on_elara",
    FOCUS_ON_CABIN = "focus_on_cabin"
}

function M.initialize(objects)
    sceneObjects = objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for Focus")
        return bt.FAILED
    end

    if action == M.ACTIONS.FOCUS_ON_WOLF then
        return M.focusOnWolf()
    elseif action == M.ACTIONS.FOCUS_ON_ELARA then
        return M.focusOnElara()
    elseif action == M.ACTIONS.FOCUS_ON_CABIN then
        return M.focusOnCabin()
    else
        print("Error: Unknown Focus action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.focusOnWolf()
    if not sceneObjects.wolf then
        print("Error: Wolf object not found")
        return bt.FAILED
    end

    -- Focus camera on wolf
    -- This would typically move camera to focus on wolf
    print("Focusing on wolf")
    return bt.SUCCESS
end

function M.focusOnElara()
    if not sceneObjects.elara then
        print("Error: Elara object not found")
        return bt.FAILED
    end

    -- Focus camera on Elara
    -- This would typically move camera to focus on Elara
    print("Focusing on Elara")
    return bt.SUCCESS
end

function M.focusOnCabin()
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