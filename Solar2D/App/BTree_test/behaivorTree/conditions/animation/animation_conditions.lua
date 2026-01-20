-------------------------------------------------------------------------------
-- Animation Conditions
-- Conditions for checking animation state
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

-- Parse object name from condition string
-- Example: "star animation completed" -> "star"
--          "circle animation completed" -> "circle"
local function parseObjectName(conditionName)
    local objectName = conditionName:match("^(.+)%s+animation%s+completed$")
    return objectName
end

-- Check if this is the first tick of the scene (for counter increment)
function M.checkSceneFirstTick()
    local isFirstTick = not sceneObjects.sceneFirstTickDone
    print("[CONDITION] scene first tick: " .. tostring(isFirstTick))

    if isFirstTick then
        sceneObjects.sceneFirstTickDone = true
    end

    return isFirstTick and bt.SUCCESS or bt.FAILED
end

-- Check if animation was completed for specific object
function M.checkAnimationCompleted(conditionName)
    local objectName = parseObjectName(conditionName)

    if not objectName then
        print("[CONDITION] animation completed - ERROR: Could not parse object name from: " .. tostring(conditionName))
        return bt.FAILED
    end

    -- Check if this specific object's animation is complete
    local completed = sceneObjects.animationComplete and sceneObjects.animationComplete[objectName] == true
    print("[CONDITION] animation completed " .. objectName .. ": " .. tostring(completed))
    return completed and bt.SUCCESS or bt.FAILED
end

-- Evaluate function for condition controller
function M.evaluate(conditionName)
    -- Check for scene first tick condition
    if conditionName == "scene first tick" then
        return M.checkSceneFirstTick()
    -- Check if this is an animation completed condition
    elseif conditionName:match("%s+animation%s+completed$") then
        return M.checkAnimationCompleted(conditionName)
    else
        print("Warning: Unknown condition: " .. tostring(conditionName))
        return bt.FAILED
    end
end

return M
