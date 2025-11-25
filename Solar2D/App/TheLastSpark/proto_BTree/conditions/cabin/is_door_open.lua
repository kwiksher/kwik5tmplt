-- Is Door Open Condition
-- Checks if the cabin door is open

local M = {}

M.CONDITION_NAME = "is door open"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local isOpen = sceneObjects.cabin_door and sceneObjects.cabin_door.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isOpen))
    return isOpen
end

return M
