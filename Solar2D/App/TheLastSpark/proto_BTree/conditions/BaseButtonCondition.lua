-- Base Button Condition
-- Generic base class for button-triggered conditions across all scenes
-- Always returns true when evaluated (gated by manual controller ticks)

local M = {}

M.CONDITION_NAME = "button"
M.BUTTON_TYPE = "clicked"  -- Default button type (can be overridden)

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

-- Always returns true since the manual controller only ticks on button press
-- Can be overridden in subclasses for custom behavior
function M.evaluate(buttonType)
    buttonType = buttonType or M.BUTTON_TYPE
    print(M.CONDITION_NAME .. " condition evaluated - TRUE (manual tick)")
    return true
end

-- Generate condition wrappers
function M.generateConditions()
    local conditionWrappers = {}

    local conditionName = M.CONDITION_NAME .. " " .. M.BUTTON_TYPE
    conditionWrappers[conditionName] = {
        initialize = M.initialize,
        evaluate = function()
            return M.evaluate(M.BUTTON_TYPE)
        end
    }

    return conditionWrappers
end

-- Factory function to create a customized button condition
-- Usage: local myButton = BaseButtonCondition.create("next button", "clicked")
function M.create(conditionName, buttonType)
    local instance = {}
    for k, v in pairs(M) do
        instance[k] = v
    end

    if conditionName then
        instance.CONDITION_NAME = conditionName
    end

    if buttonType then
        instance.BUTTON_TYPE = buttonType
    end

    return instance
end

return M
