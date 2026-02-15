-- Has Iron Key Condition
-- Checks if the player has collected the iron key

local M = {}

M.CONDITION_NAME = "has iron key"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local ironKeyObj = sceneObjects.iron_key
    local collectedOnObject = ironKeyObj and ironKeyObj.collected == true
    local collectedOnModelData = ironKeyObj and ironKeyObj.modelData and ironKeyObj.modelData.collected == true
    local hasKey = collectedOnObject
    print(M.CONDITION_NAME .. " condition: " .. tostring(hasKey))
    print("  [TRACE has_iron_key] object.collected=" .. tostring(collectedOnObject) .. ", modelData.collected=" .. tostring(collectedOnModelData))
    print("  [TRACE has_iron_key] decision branch=" .. (hasKey and "(has iron key)" or "!(has iron key)"))
    return hasKey
end

return M
