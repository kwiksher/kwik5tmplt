-------------------------------------------------------------------------------
-- narration Conditions
-- Auto-generated scaffold
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

local M = actionHelper.createModule()

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

M.CONDITIONS = {

}



function M.evaluate(conditionName)
    local condition = M.CONDITIONS[conditionName]
    if condition then
        return condition()
    else
        print("Warning: Unknown condition: " .. tostring(conditionName))
        return bt.FAILED
    end
end

return M
