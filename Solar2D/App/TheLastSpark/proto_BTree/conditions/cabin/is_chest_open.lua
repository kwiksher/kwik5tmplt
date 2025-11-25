-- Is Chest Open Condition
-- Checks if the chest is open

local M = {}

M.CONDITION_NAME = "is chest open"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local isOpen = sceneObjects.chest and sceneObjects.chest.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isOpen))
    return isOpen
end

return M
