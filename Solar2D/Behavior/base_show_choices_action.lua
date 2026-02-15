-------------------------------------------------------------------------------
-- Base Show Choices Action
-- Base class for displaying player choice buttons
-- Returns RUNNING until user selects a choice
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")

local BaseShowChoicesAction = {}

-------------------------------------------------------------------------------
-- Creates a new show choices action module
-- @return table - Action module with show choices functionality
-------------------------------------------------------------------------------
function BaseShowChoicesAction.new()
    local M = {}

    M.ACTION_NAME = "show choices"
    M.choicesAreVisible = false
    M.isWaitingForChoice = false
    M.choiceWasSelected = false
    M.choiceCompleted = false

    local sceneObjects = {}

    local function hideNextButton()
        local nextButton = sceneObjects and sceneObjects.nextButton
        if not nextButton then
            return
        end

        transition.cancel(nextButton)
        nextButton.isVisible = false
        nextButton.alpha = 0

        if nextButton.setEnabled then
            nextButton:setEnabled(false)
        end
    end

    function M.initialize(objects)
        sceneObjects = objects
        M.choicesAreVisible = false
        M.isWaitingForChoice = false
        M.choiceWasSelected = false
        M.choiceCompleted = false
    end

    function M.selectChoice()
        M.choiceWasSelected = true
        M.isWaitingForChoice = false
        M.choicesAreVisible = false
        print("Show Choices: Choice was selected, will return SUCCESS next tick to let selector execute")
    end

    function M.completeChoice()
        M.choiceCompleted = true
        print("Show Choices: Choice action completed, returning SUCCESS next tick")
    end

    function M.execute()
        if not M.isWaitingForChoice and not M.choiceWasSelected then
            M.isWaitingForChoice = true
            M.choiceWasSelected = false
            M.choiceCompleted = false
            M.choicesAreVisible = true

            sceneObjects.choicesVisible = true
            local now = system.getTimer() or 0
            local suppressUntil = now + 500
            local currentSuppressUntil = sceneObjects._suppressChoiceTapUntil or 0
            sceneObjects._suppressChoiceTapUntil = math.max(currentSuppressUntil, suppressUntil)
            print("Show Choices: suppressing choice taps until=" .. tostring(sceneObjects._suppressChoiceTapUntil))
            hideNextButton()

            if sceneObjects.showChoiceButtons then
                sceneObjects.showChoiceButtons()
            else
                print("ERROR: showChoiceButtons function not found")
            end

            return bt.RUNNING
        end

        if M.choiceWasSelected then
            M.isWaitingForChoice = false
            M.choiceWasSelected = false
            M.choiceCompleted = false
            sceneObjects.choicesVisible = false
            if sceneObjects.nextButton and sceneObjects.nextButton.setEnabled then
                sceneObjects.nextButton:setEnabled(true)
            end
            return bt.SUCCESS
        end

        return bt.RUNNING
    end

    return M
end

return BaseShowChoicesAction
