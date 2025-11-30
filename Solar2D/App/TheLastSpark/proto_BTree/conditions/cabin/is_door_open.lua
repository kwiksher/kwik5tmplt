-- Is Door Open Condition
-- Checks if the cabin door is open

local M = {}

M.CONDITION_NAME = "is door open"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    -- Check modelData.currentState since cabin_door is a display object with modelData
    local isOpen = sceneObjects.cabin_door and
                   sceneObjects.cabin_door.modelData and
                   sceneObjects.cabin_door.modelData.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isOpen))
    if sceneObjects.cabin_door and sceneObjects.cabin_door.modelData then
        print("  cabin_door.modelData.currentState = " .. tostring(sceneObjects.cabin_door.modelData.currentState))
    end
    return isOpen
end

return M
