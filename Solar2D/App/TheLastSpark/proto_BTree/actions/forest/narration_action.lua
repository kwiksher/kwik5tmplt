-- Narration Actions
-- Displays narrative text in the dialogue text area
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

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

-- Narration text content
local narrationTexts = {
    cabin_scene = "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light.",
    forest_quiet = "The forest is unnervingly quiet. No birdsong, no rustle of creatures.",
}

-- Register narration actions
M.ACTIONS = {
    cabin_scene = function()
        return M.showNarration("cabin_scene")
    end,

    forest_quiet = function()
        return M.showNarration("forest_quiet")
    end,
}

function M.showNarration(textKey)
    local text = narrationTexts[textKey]

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
            -- print("Narration: Typing character " .. currentIndex .. "/" .. textLength)

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

return M
