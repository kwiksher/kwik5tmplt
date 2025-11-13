-- Choice Action Module
-- Handles the narrative actions after player makes a choice (fight, calm, retreat)

local bt = require("utils.btree")
local M = {}

M.ACTION_NAME = "choice"

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

-- Execute choice action - shows appropriate narration based on choice
function M.executeChoice(choiceType)
    print("Action: Player chose " .. choiceType)

    -- Hide choice buttons after selection
    if sceneObjects.hideChoiceButtons then
        sceneObjects.hideChoiceButtons()
    end

    -- Show narration for the choice
    if sceneObjects.dialogueText then
        local narrationText = ""
        if choiceType == "fight" then
            narrationText = "You prepare to fight the corrupted wolf..."
        elseif choiceType == "calm" then
            narrationText = "You hold out the Lumin Seed, hoping to calm the beast..."
        elseif choiceType == "retreat" then
            narrationText = "You slowly back away toward the cabin..."
        end

        sceneObjects.dialogueText.text = narrationText
    end

    return bt.SUCCESS
end

function M.execute(actionName)
    -- actionName will be like "choice fight", "choice calm", etc.
    local choiceType = actionName:match("choice%s+(%w+)")

    if choiceType then
        return M.executeChoice(choiceType)
    else
        print("Warning: Unknown choice action - " .. tostring(actionName))
        return bt.FAILED
    end
end

return M
