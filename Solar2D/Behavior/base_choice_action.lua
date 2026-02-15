-------------------------------------------------------------------------------
-- Base Choice Action
-- Base class for choice actions that handle player choices with narration
-- Manages typing animation, focus actions, and button visibility
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")

local BaseChoiceAction = {}

local function requireFirst(candidates)
    for i = 1, #candidates do
        local ok, mod = pcall(require, candidates[i])
        if ok and mod then
            return mod
        end
    end
    return nil
end

-------------------------------------------------------------------------------
-- Creates a new choice action module
-- @param choiceConfig table - Map of choice types to config (narration, scene, focus)
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

        -- If this is a resumed choice and wait was cleared
        if M.currentChoice == choiceType and not M.isWaitingForButton then
            print("Choice Action: Wait was cleared, returning SUCCESS")

            local showChoicesModule = requireFirst({
                "Behavior.BTree_test.actions.narration.show_choices_action",
                "Behavior.TheLastSpark.actions.cabin.show_choices_action",
                "Behavior.TheLastSpark.actions.forest.show_choices_action",
                "actions.narration.show_choices_action",
                "actions.cabin.show_choices_action",
                "actions.forest.show_choices_action"
            })
            if showChoicesModule and showChoicesModule.completeChoice then
                showChoicesModule.completeChoice()
            end

            M.lastCompletedChoice = choiceType
            M.currentChoice = nil
            M.isTypingComplete = true

            -- Execute callback if available (used by BTree_test)
            local mergedChoiceConfig = config[choiceType]
            if mergedChoiceConfig and mergedChoiceConfig.callback then
                timer.performWithDelay(1000, function()
                    mergedChoiceConfig.callback()
                end)
            end

            return bt.SUCCESS
        end

        print("Action: Player chose " .. choiceType .. " - Starting new choice execution")
        M.currentChoice = choiceType

        local selectedChoiceConfig = config[choiceType]
        if not selectedChoiceConfig then
            print("ERROR: Unknown choice type - " .. tostring(choiceType))
            return bt.FAILED
        end

        print("Choice Action: Config found - narration: " .. selectedChoiceConfig.narration)

        -- Execute focus action first
        if selectedChoiceConfig.focus then
            print("Choice Action: Executing focus on " .. selectedChoiceConfig.focus)
            local focusModule = requireFirst({
                "Behavior.TheLastSpark.actions.cabin.focus_actions",
                "Behavior.TheLastSpark.actions.forest.focus_actions",
                "actions.cabin.focus_actions",
                "actions.forest.focus_actions"
            })

            if focusModule and focusModule.execute then
                local result = focusModule.execute(selectedChoiceConfig.focus)
                if result == bt.SUCCESS then
                    print("Choice Action: Focus executed successfully")
                else
                    print("ERROR: Focus execution failed for: " .. selectedChoiceConfig.focus)
                end
            else
                print("ERROR: Focus module not found or has no execute function")
            end
        end

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
            print("Choice: Starting typing, isTypingComplete set to false")

            -- Hide next button while typing
            if sceneObjects.nextButton then
                sceneObjects.nextButton.isVisible = false
                sceneObjects.nextButton.alpha = 1.0
                if sceneObjects.nextButton.setEnabled then
                    sceneObjects.nextButton:setEnabled(false)
                end
                print("Choice Action: Next button hidden")
            else
                print("ERROR: nextButton not found in sceneObjects")
            end

            -- Start typing effect
            local currentIndex = 0
            local typingSpeed = 30
            local textLength = #selectedChoiceConfig.narration

            sceneObjects.dialogueText.text = ""

            typingTimer = timer.performWithDelay(typingSpeed, function()
                currentIndex = currentIndex + 1

                if currentIndex <= textLength then
                    sceneObjects.dialogueText.text = string.sub(selectedChoiceConfig.narration, 1, currentIndex)
                else
                    -- Typing complete
                    cancelTyping()
                    M.isTypingComplete = true

                    -- Show button after delay for reading time
                    timer.performWithDelay(4000, function()
                        if sceneObjects and sceneObjects.nextButton then
                            if sceneObjects.nextButton.setEnabled then
                                sceneObjects.nextButton:setEnabled(true)
                            end
                            sceneObjects.nextButton.isVisible = true
                            sceneObjects.nextButton.alpha = 1.0
                            M.isWaitingForButton = true
                            print("Choice Action: Next button shown and enabled; waiting for click")

                            local function blinkCycle()
                                if sceneObjects.nextButton and sceneObjects.nextButton.removeSelf then
                                    transition.to(sceneObjects.nextButton, {
                                        alpha = 0.3,
                                        time = 500,
                                        onComplete = function()
                                            if sceneObjects.nextButton and sceneObjects.nextButton.removeSelf then
                                                transition.to(sceneObjects.nextButton, {
                                                    alpha = 1.0,
                                                    time = 500,
                                                    onComplete = blinkCycle
                                                })
                                            end
                                        end
                                    })
                                end
                            end
                            blinkCycle()
                        end
                    end)
                end
            end, textLength + 1)
        else
            print("ERROR: dialogueText not found in sceneObjects")
            return bt.FAILED
        end

        print("Choice Action: Returning RUNNING to pause tree")
        print("=== CHOICE ACTION DEBUG END ===")
        return bt.RUNNING
    end

    function M.execute(actionName)
        -- Compatibility: direct choice key (BTree_test style)
        if config[actionName] then
            return M.executeChoice(actionName)
        end

        -- Handle "choice dynamic" - check playerState for which choice was made
        if actionName == "choice dynamic" then
            print("Choice Action: Dynamic handler - checking playerState")
            local Runtime = _G.Runtime or require("CoronaLibraries.Runtime")
            local playerState = Runtime.playerState or {}

            if playerState.currentChoice then
                print("Choice Action: Dynamic found choice - " .. playerState.currentChoice)
                return M.executeChoice(playerState.currentChoice)
            else
                print("Warning: Dynamic choice called but no currentChoice in playerState")
                return bt.FAILED
            end
        end

        -- Handle specific choices like "choice fight", "choice calm", etc.
        local choiceType = actionName and actionName:match("choice%s+(.+)")
        if choiceType then
            return M.executeChoice(choiceType)
        end

        print("Warning: Unknown choice action - " .. tostring(actionName))
        return bt.FAILED
    end

    return M
end

return BaseChoiceAction
