-------------------------------------------------------------------------------
-- narration Actions
-- Auto-generated scaffold
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

local M = actionHelper.createModule()

-- Debug flag - set to false to only show debug logs
M.DEBUG_ENABLED = true

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

M.ACTIONS = {
    ["narration"] = function() return M.action_narration() end,

}

function M.action_narration()
    print("[ACTION] narration")
    return bt.SUCCESS
end



return M
