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
    local doorObj = sceneObjects.cabin_door
    local modelState = doorObj and doorObj.modelData and doorObj.modelData.currentState or nil
    local objectState = doorObj and doorObj.currentState or nil
    local isOpen = doorObj and
                   doorObj.modelData and
                   doorObj.modelData.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isOpen))
    print("  [TRACE is_door_open] object.currentState = " .. tostring(objectState))
    print("  [TRACE is_door_open] modelData.currentState = " .. tostring(modelState))
    print("  [TRACE is_door_open] decision branch=" .. (isOpen and "(is door open)" or "!(is door open)"))
    if sceneObjects.cabin_door and sceneObjects.cabin_door.modelData then
        print("  cabin_door.modelData.currentState = " .. tostring(sceneObjects.cabin_door.modelData.currentState))
    end
    return isOpen
end

return M
