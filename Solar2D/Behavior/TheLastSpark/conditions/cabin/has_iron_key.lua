-- Has Iron Key Condition
-- Checks if the player has collected the iron key

local M = {}

M.CONDITION_NAME = "has iron key"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local hasKey = sceneObjects.iron_key and sceneObjects.iron_key.collected == true
    print(M.CONDITION_NAME .. " condition: " .. tostring(hasKey))
    return hasKey
end

return M
