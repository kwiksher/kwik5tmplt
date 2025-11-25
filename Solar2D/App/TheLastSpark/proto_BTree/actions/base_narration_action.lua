-------------------------------------------------------------------------------
-- Base Narration Action
-- Base class for narration actions that display text with typing effect
-- Handles typing animation, button visibility, and completion events
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

local BaseNarrationAction = {}

-------------------------------------------------------------------------------
-- Creates a new narration action module
-- @param narrationTexts table - Map of text keys to narration strings
-- @return table - Action module with narration functionality
-------------------------------------------------------------------------------
function BaseNarrationAction.new(narrationTexts)
    -- Create action module with helper methods
    local M = actionHelper.createModule()

    -- Scene objects reference
    local sceneObjects = {}

    -- Active typing timer reference
    local typingTimer = nil

    -- Narration typing completion flag
    M.isTypingComplete = true

    -- Event dispatcher for narration completion
    M.eventDispatcher = display.newGroup()

    -- Store narration texts
    local texts = narrationTexts or {}

    -- Override initialize to store scene objects
    function M.initialize(objects)
        sceneObjects = objects
    end

    -- Cancel any active typing animation
    local function cancelTyping()
        if typingTimer then
            timer.cancel(typingTimer)
            typingTimer = nil
        end
    end

    -- Show narration with typing effect
    function M.showNarration(textKey)
        local text = texts[textKey]

        if not text then
            print("Warning: Narration text not found for key: " .. tostring(textKey))
            return bt.FAILED
        end

        if sceneObjects.dialogueText then
            -- Cancel any existing typing animation
            cancelTyping()

            -- Set typing flag to false
            M.isTypingComplete = false
            print("Narration: Starting typing, isTypingComplete set to false")

            -- Hide next button while typing
            if sceneObjects.nextButton then
                sceneObjects.nextButton.isVisible = false
                sceneObjects.nextButton.alpha = 1.0
            end

            -- Start typing effect
            local currentIndex = 0
            local typingSpeed = 30  -- milliseconds per character
            local textLength = #text

            print("Narration: Text length = " .. textLength .. ", typing speed = " .. typingSpeed .. "ms")

            -- Clear the text initially
            sceneObjects.dialogueText.text = ""

            typingTimer = timer.performWithDelay(typingSpeed, function()
                currentIndex = currentIndex + 1

                if currentIndex <= textLength then
                    -- Add one more character
                    sceneObjects.dialogueText.text = string.sub(text, 1, currentIndex)
                else
                    -- Typing complete
                    cancelTyping()
                    M.isTypingComplete = true
                    print("Narration: Typing complete, isTypingComplete set to true")

                    -- Dispatch completion event first (VO might be waiting for this)
                    print("Narration: Dispatching narrationComplete event")
                    print("Narration: eventDispatcher = " .. tostring(M.eventDispatcher))
                    local event = { name = "narrationComplete" }
                    local result = M.eventDispatcher:dispatchEvent(event)
                    print("Narration: dispatchEvent returned: " .. tostring(result))

                    -- If no VO listener handled the event (result = false), show button after delay
                    if not result then
                        print("Narration: No VO waiting, will show button after 4 seconds reading time")
                        timer.performWithDelay(4000, function()
                            if sceneObjects and sceneObjects.nextButton then
                                print("Narration: Showing next button with blinking")
                                sceneObjects.nextButton.isVisible = true
                                sceneObjects.nextButton.alpha = 1.0

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
                    else
                        print("Narration: VO listener handled event, VO will control button")
                    end
                end
            end, textLength + 1)  -- +1 to trigger the completion block

            print("Narration (typing): " .. text)
            return bt.SUCCESS
        else
            print("Warning: dialogueText not available")
            return bt.FAILED
        end
    end

    -- Register actions from the narration texts map
    M.ACTIONS = {}
    for key, _ in pairs(texts) do
        M.ACTIONS[key] = function()
            return M.showNarration(key)
        end
    end

    return M
end

return BaseNarrationAction
