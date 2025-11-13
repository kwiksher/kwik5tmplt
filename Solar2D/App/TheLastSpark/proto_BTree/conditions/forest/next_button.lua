-- Next Button Condition
-- This condition is always true when evaluated, allowing the behavior tree to proceed
-- The manual controller only ticks when the button is pressed, so this effectively
-- gates progression to button clicks

local M = {}

M.CONDITION_NAME = "next_button"

-- Scene objects reference (not needed for this simple condition)
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

-- Always returns true since the manual controller only ticks on button press
function M.evaluate_clicked()
    print("Next button condition evaluated - TRUE (manual tick)")
    return true
end

function M.evaluate(conditionType)
    if conditionType == "clicked" then
        return M.evaluate_clicked()
    else
        print("Next button condition: Unknown condition type - " .. tostring(conditionType))
        return false
    end
end

-- Generate condition wrappers
function M.generateConditions()
    local conditionWrappers = {}

    conditionWrappers["next button clicked"] = {
        initialize = M.initialize,
        evaluate = function()
            return M.evaluate("clicked")
        end
    }

    return conditionWrappers
end

return M
