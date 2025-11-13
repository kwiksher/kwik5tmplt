-- Show Choices Action Module
-- Displays the player choice buttons (Fight, Calm, Retreat)

local bt = require("utils.btree")
local M = {}

M.ACTION_NAME = "show choices"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

function M.execute()
    print("Action: Showing player choice buttons")

    if sceneObjects.showChoiceButtons then
        sceneObjects.showChoiceButtons()
    else
        print("Warning: showChoiceButtons function not found")
    end

    return bt.SUCCESS
end

return M
