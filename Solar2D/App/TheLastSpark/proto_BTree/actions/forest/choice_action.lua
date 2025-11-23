-- Choice Action Module
-- Handles the narrative actions after player makes a choice (fight, calm, retreat)
-- Returns RUNNING while typing, SUCCESS when complete

local bt = require("utils.btree")
local M = {}

M.ACTION_NAME = "choice"

local sceneObjects = {}
local typingTimer = nil
M.isTypingComplete = true
M.isWaitingForButton = false
M.currentChoice = nil
M.lastCompletedChoice = nil  -- Track the last choice that was completed

-- Choice configuration: narration, scene, and focus
local CHOICE_CONFIG = {
    fight = {
        narration = "You prepare to fight the corrupted wolf...",
        scene = "fight",
        focus = "wolf"
    },
    calm = {
        narration = "You hold out the Lumin Seed, hoping to calm the beast...",
        scene = "calm",
        focus = "elara"
    },
    retreat = {
        narration = "You slowly back away toward the cabin...",
        scene = "retreat",
        focus = "cabin"
    }
}

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
    M.lastCompletedChoice = M.currentChoice  -- Remember which choice just completed
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
        local showChoicesModule = require("actions.forest.show_choices_action")
        showChoicesModule.completeChoice()

        M.lastCompletedChoice = choiceType  -- Mark this choice as completed
        M.currentChoice = nil
        M.isTypingComplete = true  -- Reset typing flag for next choice
        return bt.SUCCESS
    end

    print("Action: Player chose " .. choiceType .. " - Starting new choice execution")
    M.currentChoice = choiceType

    local config = CHOICE_CONFIG[choiceType]
    if not config then
        print("ERROR: Unknown choice type - " .. choiceType)
        return bt.FAILED
    end

    print("Choice Action: Config found - narration: " .. config.narration)

    -- Execute focus action first
    if config.focus then
        print("Choice Action: Executing focus on " .. config.focus)
        local focusModule = require("actions.forest.focus_actions")
        if focusModule.execute then
            local result = focusModule.execute(config.focus)
            if result == bt.SUCCESS then
                print("Choice Action: Focus executed successfully")
            else
                print("ERROR: Focus execution failed for: " .. config.focus)
            end
        else
            print("ERROR: Focus module has no execute function")
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
            print("Choice Action: Next button hidden")
        else
            print("ERROR: nextButton not found in sceneObjects")
        end

        -- Start typing effect
        local currentIndex = 0
        local typingSpeed = 30  -- milliseconds per character
        local textLength = #config.narration

        print("Choice: Text length = " .. textLength .. ", typing speed = " .. typingSpeed .. "ms")
        print("Choice: Full narration text: " .. config.narration)

        -- Clear the text initially
        sceneObjects.dialogueText.text = ""
        print("Choice Action: dialogueText.text cleared, starting timer")

        typingTimer = timer.performWithDelay(typingSpeed, function()
            currentIndex = currentIndex + 1

            if currentIndex == 1 then
                print("Choice Action: Timer fired - first character")
            end

            if currentIndex <= textLength then
                -- Add one more character
                sceneObjects.dialogueText.text = string.sub(config.narration, 1, currentIndex)
                if currentIndex % 10 == 0 then
                    print("Choice Action: Typing progress - " .. currentIndex .. "/" .. textLength)
                end
            else
                -- Typing complete
                print("Choice Action: Typing animation complete")
                cancelTyping()
                M.isTypingComplete = true
                print("Choice: Typing complete, isTypingComplete set to true")

                -- Show button after delay for reading time
                timer.performWithDelay(4000, function()
                    if sceneObjects and sceneObjects.nextButton then
                        print("Choice: Showing next button with blinking")
                        sceneObjects.nextButton.isVisible = true
                        sceneObjects.nextButton.alpha = 1.0
                        M.isWaitingForButton = true

                        -- Create blinking animation
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
        end, textLength + 1)  -- +1 to trigger the completion block

        print("Choice (typing): Timer created with " .. (textLength + 1) .. " iterations")
    else
        print("ERROR: dialogueText not found in sceneObjects")
    end

    -- Return RUNNING to pause tree execution until typing and reading time complete
    print("Choice Action: Returning RUNNING to pause tree")
    print("=== CHOICE ACTION DEBUG END ===")
    return bt.RUNNING
end

function M.execute(actionName)
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
    local choiceType = actionName:match("choice%s+(%w+)")
    if choiceType then
        return M.executeChoice(choiceType)
    else
        print("Warning: Unknown choice action - " .. tostring(actionName))
        return bt.FAILED
    end
end

return M

