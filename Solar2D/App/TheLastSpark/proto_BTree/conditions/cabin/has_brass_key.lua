-- Has Brass Key Condition
-- Checks if the player has collected the brass key

local M = {}

M.CONDITION_NAME = "has brass key"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local hasKey = sceneObjects.brass_key and sceneObjects.brass_key.collected == true
    print(M.CONDITION_NAME .. " condition: " .. tostring(hasKey))
    return hasKey
end

return M
