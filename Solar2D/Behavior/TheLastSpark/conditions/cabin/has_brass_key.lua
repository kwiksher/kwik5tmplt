-- Has Brass Key Condition
-- Checks if the player has collected the brass key

local M = {}

M.CONDITION_NAME = "has brass key"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local hasKey = false
    if sceneObjects.brass_key and sceneObjects.brass_key.modelData then
        hasKey = sceneObjects.brass_key.modelData.usedOnChest == true
    end
    print(M.CONDITION_NAME .. " condition: " .. tostring(hasKey))
    if sceneObjects.brass_key then
        if sceneObjects.brass_key.modelData then
            print("  brass_key.modelData.usedOnChest = " .. tostring(sceneObjects.brass_key.modelData.usedOnChest))
            print("  brass_key.modelData.collected = " .. tostring(sceneObjects.brass_key.modelData.collected))
        else
            print("  brass_key.modelData is nil")
        end
    else
        print("  brass_key is nil")
    end
    return hasKey
end

return M
