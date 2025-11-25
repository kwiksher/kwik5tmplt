-- Key Visible Near Doorstep Condition
-- Checks if the iron key is visible near the doorstep

local M = {}

M.CONDITION_NAME = "key visible near doorstep"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local isVisible = sceneObjects.iron_key and sceneObjects.iron_key.currentState == "visible"
    print(M.CONDITION_NAME .. " condition: " .. tostring(isVisible))
    return isVisible
end

return M
