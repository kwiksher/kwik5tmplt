-------------------------------------------------------------------------------
-- Button Conditions
-- Conditions for checking button state
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create condition module
local M = actionHelper.createModule()

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register button-specific conditions
M.CONDITIONS = {
    ["button clicked"] = function()
        return M.checkButtonClicked()
    end,
}

-- Check if button was clicked
function M.checkButtonClicked()
    local clicked = sceneObjects.buttonPressed == true
    --print("[CONDITION] button clicked: " .. tostring(clicked))
    return clicked and bt.SUCCESS or bt.FAILED
end

-- Evaluate function for condition controller
function M.evaluate(conditionName)
    local condition = M.CONDITIONS[conditionName]
    if condition then
        return condition()
    else
        print("Warning: Unknown condition: " .. tostring(conditionName))
        return false
    end
end

return M
