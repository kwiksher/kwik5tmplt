-- Show Choices Action Module
-- Displays the player choice buttons (Fight, Calm, Retreat)
-- Returns RUNNING until user selects a choice

local bt = require("utils.btree")
local M = {}

M.ACTION_NAME = "show choices"
M.choicesAreVisible = false
M.isWaitingForChoice = false
M.choiceWasSelected = false

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.choicesAreVisible = false
    M.isWaitingForChoice = false
    M.choiceWasSelected = false
end

-- Called when user clicks a choice button
function M.selectChoice()
    M.choiceWasSelected = true
    M.isWaitingForChoice = false
    M.choicesAreVisible = false
    print("Show Choices: Choice was selected, returning SUCCESS next tick")
end

function M.execute()
    -- If this is first execution, show choices and start waiting
    if not M.isWaitingForChoice then
        print("Show Choices: Displaying player choice buttons")

        M.isWaitingForChoice = true
        M.choiceWasSelected = false
        M.choicesAreVisible = true

        -- Hide Next button when showing choices - user must click a choice button
        if sceneObjects.nextButton then
            sceneObjects.nextButton.isVisible = false
            -- Cancel any blinking animation
            transition.cancel(sceneObjects.nextButton)
            sceneObjects.nextButton.alpha = 1.0
            print("Show Choices: Next button hidden for player choices")
        end

        if sceneObjects.showChoiceButtons then
            sceneObjects.showChoiceButtons()
        else
            print("Warning: showChoiceButtons function not found")
        end

        -- Return RUNNING to pause tree until choice is made
        return bt.RUNNING
    end

    -- If choice was selected, reset state and return SUCCESS
    if M.choiceWasSelected then
        print("Show Choices: Choice selected, resetting and returning SUCCESS")
        M.isWaitingForChoice = false
        M.choiceWasSelected = false
        return bt.SUCCESS
    end

    -- Still waiting for user to click a choice
    return bt.RUNNING
end

return M
