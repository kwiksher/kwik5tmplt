-- Searched Floorboard Condition
-- Checks if the player has searched the loose floorboard

local M = {}

M.CONDITION_NAME = "searched floorboard"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.evaluate()
    local searched = sceneObjects.loose_floorboard and sceneObjects.loose_floorboard.currentState == "open"
    print(M.CONDITION_NAME .. " condition: " .. tostring(searched))
    return searched
end

return M
