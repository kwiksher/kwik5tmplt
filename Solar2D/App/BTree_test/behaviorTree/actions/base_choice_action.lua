-------------------------------------------------------------------------------
-- Base Choice Action
-- Base class for choice actions that handle player choices with narration
-- Manages typing animation and button visibility
-------------------------------------------------------------------------------
local bt = require("utils.btree")

local BaseChoiceAction = {}

-------------------------------------------------------------------------------
-- Creates a new choice action module
-- @param choiceConfig table - Map of choice types to config (narration, scene)
-- @return table - Action module with choice functionality
-------------------------------------------------------------------------------
function BaseChoiceAction.new(choiceConfig)
    local M = {}

    M.ACTION_NAME = "choice"

    local sceneObjects = {}
    local typingTimer = nil
    M.isTypingComplete = true
    M.isWaitingForButton = false
    M.currentChoice = nil
    M.lastCompletedChoice = nil

    -- Store choice configuration
    local config = choiceConfig or {}

    function M.initialize(objects)
        sceneObjects = objects
        M.isTypingComplete = true
        M.isWaitingForButton = false
        M.currentChoice = nil
        M.lastCompletedChoice = nil
    end

    -- Cancel any active typing animation
    local function cancelTyping()
        if typingTimer then
            timer.cancel(typingTimer)
            typingTimer = nil
        end
    end

    -- Clear the wait state (called when Next button is clicked)
    function M.clearWait()
        M.isWaitingForButton = false
        M.lastCompletedChoice = M.currentChoice
        M.currentChoice = nil
        print("Choice Action: Wait cleared, returning SUCCESS next tick")
    end

    -- Execute choice action - shows appropriate narration based on choice with typing effect
    function M.executeChoice(choiceType)
        print("=== CHOICE ACTION DEBUG START ===")
        print("Choice Action: executeChoice called with type: " .. tostring(choiceType))
        print("Choice Action: M.currentChoice = " .. tostring(M.currentChoice))
        print("Choice Action: M.isWaitingForButton = " .. tostring(M.isWaitingForButton))
        print("Choice Action: M.isTypingComplete = " .. tostring(M.isTypingComplete))
        print("Choice Action: M.lastCompletedChoice = " .. tostring(M.lastCompletedChoice))

        -- If this choice was already completed, return SUCCESS immediately
        if M.lastCompletedChoice == choiceType then
            print("Choice Action: This choice already completed, returning SUCCESS")
            return bt.SUCCESS
        end

        -- If we've already processed this choice and are waiting for button click
        if M.currentChoice == choiceType and M.isWaitingForButton then
            print("Choice Action: Still waiting for button, returning RUNNING")
            return bt.RUNNING
        end

        -- If this is a new choice or we were waiting and button was clicked
        if M.currentChoice == choiceType and not M.isWaitingForButton then
            print("Choice Action: Wait was cleared, returning SUCCESS")

            -- Notify show_choices that the choice action is complete
            local success, showChoicesModule = pcall(require, "actions.narration.show_choices_action")
            if success and showChoicesModule and showChoicesModule.completeChoice then
                showChoicesModule.completeChoice()
            end

            M.lastCompletedChoice = choiceType
            M.currentChoice = nil
            M.isTypingComplete = true

            -- Execute callback if available
            local choiceConfig = config[choiceType]
            if choiceConfig and choiceConfig.callback then
                timer.performWithDelay(1000, function()
                    choiceConfig.callback()
                end)
            end

            return bt.SUCCESS
        end

        print("Action: Player chose " .. choiceType .. " - Starting new choice execution")
        M.currentChoice = choiceType

        local choiceConfig = config[choiceType]
        if not choiceConfig then
            print("ERROR: Unknown choice type - " .. choiceType)
            return bt.FAILED
        end

        print("Choice Action: Config found - narration: " .. choiceConfig.narration)

        -- Hide choice buttons after selection
        if sceneObjects.hideChoiceButtons then
            sceneObjects.hideChoiceButtons()
            print("Choice Action: Choice buttons hidden")
        else
            print("ERROR: hideChoiceButtons function not found")
        end

        -- Show narration for the choice with typing effect
        if sceneObjects.dialogueText then
            print("Choice Action: dialogueText object found, starting typing animation")

            -- Cancel any existing typing animation
            cancelTyping()

            -- Set typing flag to false
            M.isTypingComplete = false

            local narrationText = choiceConfig.narration
            local charIndex = 0
            local typingSpeed = 30 -- milliseconds per character

            -- Function to type one character at a time
            local function typeNextChar()
                charIndex = charIndex + 1
                if charIndex <= #narrationText then
                    sceneObjects.dialogueText.text = string.sub(narrationText, 1, charIndex)
                else
                    -- Typing complete
                    M.isTypingComplete = true
                    M.isWaitingForButton = true
                    typingTimer = nil

                    -- Show Next button
                    if sceneObjects.nextButton then
                        sceneObjects.nextButton.isVisible = true

                        -- Start blinking animation
                        transition.to(sceneObjects.nextButton, {
                            alpha = 0.3,
                            time = 500,
                            iterations = 0,
                            transition = easing.continuousLoop
                        })

                        print("Choice Action: Typing complete, Next button shown and blinking")
                    else
                        print("ERROR: nextButton not found")
                    end
                end
            end

            -- Start typing animation
            typingTimer = timer.performWithDelay(typingSpeed, typeNextChar, #narrationText)
            print("Choice Action: Typing animation started")
        else
            print("ERROR: dialogueText object not found")
            return bt.FAILED
        end

        print("Choice Action: Returning RUNNING (typing in progress)")
        print("=== CHOICE ACTION DEBUG END ===")
        return bt.RUNNING
    end

    -- Main execute function - routes to specific choice handler
    function M.execute(choiceType)
        return M.executeChoice(choiceType)
    end

    return M
end

return BaseChoiceAction
