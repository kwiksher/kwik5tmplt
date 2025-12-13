-- Searched Floorboard Condition
-- Checks if the player has searched the loose floorboard

local M = {}

M.CONDITION_NAME = "searched floorboard"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    -- Check modelData first (persistent), then fall back to object property
    local searched = false
    if sceneObjects.loose_floorboard then
        if sceneObjects.loose_floorboard.modelData and sceneObjects.loose_floorboard.modelData.searched == true then
            searched = true
        elseif sceneObjects.loose_floorboard.searched == true then
            searched = true
        end
    end
    print(M.CONDITION_NAME .. " condition: " .. tostring(searched))
    return searched
end

return M
