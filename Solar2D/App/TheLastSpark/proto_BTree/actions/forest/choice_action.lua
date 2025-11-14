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

function M.initialize(objects)
    sceneObjects = objects
    M.isTypingComplete = true
    M.isWaitingForButton = false
    M.currentChoice = nil
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
    M.currentChoice = nil
    print("Choice Action: Wait cleared, returning SUCCESS next tick")
end

-- Execute choice action - shows appropriate narration based on choice with typing effect
function M.executeChoice(choiceType)
    -- If we've already processed this choice and are waiting for button click
    if M.currentChoice == choiceType and M.isWaitingForButton then
        return bt.RUNNING
    end

    -- If this is a new choice or we were waiting and button was clicked
    if M.currentChoice == choiceType and not M.isWaitingForButton then
        print("Choice Action: Wait was cleared, returning SUCCESS")
        M.currentChoice = nil
        return bt.SUCCESS
    end

    print("Action: Player chose " .. choiceType)
    M.currentChoice = choiceType

    -- Hide choice buttons after selection
    if sceneObjects.hideChoiceButtons then
        sceneObjects.hideChoiceButtons()
    end

    -- Show narration for the choice with typing effect
    if sceneObjects.dialogueText then
        local narrationText = ""
        if choiceType == "fight" then
            narrationText = "You prepare to fight the corrupted wolf..."
        elseif choiceType == "calm" then
            narrationText = "You hold out the Lumin Seed, hoping to calm the beast..."
        elseif choiceType == "retreat" then
            narrationText = "You slowly back away toward the cabin..."
        end

        -- Cancel any existing typing animation
        cancelTyping()

        -- Set typing flag to false
        M.isTypingComplete = false
        print("Choice: Starting typing, isTypingComplete set to false")

        -- Hide next button while typing
        if sceneObjects.nextButton then
            sceneObjects.nextButton.isVisible = false
            sceneObjects.nextButton.alpha = 1.0
        end

        -- Start typing effect
        local currentIndex = 0
        local typingSpeed = 30  -- milliseconds per character
        local textLength = #narrationText

        print("Choice: Text length = " .. textLength .. ", typing speed = " .. typingSpeed .. "ms")

        -- Clear the text initially
        sceneObjects.dialogueText.text = ""

        typingTimer = timer.performWithDelay(typingSpeed, function()
            currentIndex = currentIndex + 1

            if currentIndex <= textLength then
                -- Add one more character
                sceneObjects.dialogueText.text = string.sub(narrationText, 1, currentIndex)
            else
                -- Typing complete
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

        print("Choice (typing): " .. narrationText)
    end

    -- Return RUNNING to pause tree execution until typing and reading time complete
    return bt.RUNNING
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
