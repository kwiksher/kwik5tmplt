-- Show Choices Action Module
-- Displays the player choice buttons (Fight, Calm, Retreat)
-- Returns RUNNING until user selects a choice AND the choice action completes

local bt = require("utils.btree")
local M = {}

M.ACTION_NAME = "show choices"
M.choicesAreVisible = false
M.isWaitingForChoice = false
M.choiceWasSelected = false
M.choiceCompleted = false

local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.choicesAreVisible = false
    M.isWaitingForChoice = false
    M.choiceWasSelected = false
    M.choiceCompleted = false
end

-- Called when user clicks a choice button
function M.selectChoice()
    M.choiceWasSelected = true
    M.isWaitingForChoice = false
    M.choicesAreVisible = false
    print("Show Choices: Choice was selected, will return SUCCESS next tick to let selector execute")
end

-- Called when the choice action completes (from choice_action.lua)
function M.completeChoice()
    M.choiceCompleted = true
    print("Show Choices: Choice action completed, returning SUCCESS next tick")
end

function M.execute()
    print("=== SHOW CHOICES DEBUG START ===")
    print("Show Choices: isWaitingForChoice = " .. tostring(M.isWaitingForChoice))
    print("Show Choices: choiceWasSelected = " .. tostring(M.choiceWasSelected))
    print("Show Choices: choiceCompleted = " .. tostring(M.choiceCompleted))

    -- If this is first execution, show choices and start waiting
    if not M.isWaitingForChoice and not M.choiceWasSelected then
        print("Show Choices: First execution - Displaying player choice buttons")

        M.isWaitingForChoice = true
        M.choiceWasSelected = false
        M.choiceCompleted = false
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
            print("Show Choices: showChoiceButtons() called successfully")
        else
            print("ERROR: showChoiceButtons function not found")
        end

        -- Return RUNNING to pause tree until choice is made
        print("Show Choices: Returning RUNNING - waiting for player to click")
        print("=== SHOW CHOICES DEBUG END ===")
        return bt.RUNNING
    end

    -- If choice was selected, return SUCCESS to let selector execute
    if M.choiceWasSelected then
        print("Show Choices: Choice was selected - Returning SUCCESS to let selector execute")
        M.isWaitingForChoice = false
        M.choiceWasSelected = false
        M.choiceCompleted = false
        print("=== SHOW CHOICES DEBUG END ===")
        return bt.SUCCESS
    end

    -- Still waiting for user to click a choice
    print("Show Choices: Still waiting for choice - returning RUNNING")
    print("=== SHOW CHOICES DEBUG END ===")
    return bt.RUNNING
end

return M
