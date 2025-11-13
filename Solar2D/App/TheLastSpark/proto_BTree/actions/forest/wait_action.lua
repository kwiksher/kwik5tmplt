-- Wait Action
-- Returns RUNNING to pause tree execution until clearWait is called

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Wait state
local waitCleared = false
local shouldContinue = false  -- Flag to indicate we should return SUCCESS on next tick

-- Override initialize
function M.initialize(objects)
    M.sceneObjects = objects
    waitCleared = false
    shouldContinue = false
end

-- Clear the wait state (call this when Next button is pressed)
function M.clearWait()
    waitCleared = true
end

-- Reset wait state for next time
function M.resetWait()
    waitCleared = false
    shouldContinue = false
end

-- Execute wait action - returns RUNNING until cleared, then SUCCESS on next tick
function M.executeWaitForNext()
    if shouldContinue then
        -- We were cleared on previous tick, now return SUCCESS
        M.resetWait()
        return bt.SUCCESS
    elseif waitCleared then
        -- Just cleared, set flag to return SUCCESS on next tick
        shouldContinue = true
        waitCleared = false
        return bt.RUNNING  -- Still return RUNNING this tick
    else
        return bt.RUNNING  -- Return running to pause the tree
    end
end

-- Override execute to handle wait actions
function M.execute(actionName)
    if actionName == "for next" then
        return M.executeWaitForNext()
    else
        print("Wait Actions: Unknown action type - " .. tostring(actionName))
        return bt.FAILED
    end
end

return M
