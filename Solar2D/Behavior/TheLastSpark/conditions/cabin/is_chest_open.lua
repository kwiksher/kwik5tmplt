-- Is Chest Open Condition
-- Checks if the chest is open

local M = {}

M.CONDITION_NAME = "is chest open"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    -- Check modelData.currentState since chest is a display object with modelData
    local isOpen = sceneObjects.chest and
                   sceneObjects.chest.modelData and
                   sceneObjects.chest.modelData.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isOpen))
    return isOpen
end

return M
