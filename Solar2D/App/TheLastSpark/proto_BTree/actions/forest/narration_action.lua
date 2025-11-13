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

        -- Start typing effect
        local currentIndex = 0
        local typingSpeed = 30  -- milliseconds per character

        -- Clear the text initially
        sceneObjects.dialogueText.text = ""

        typingTimer = timer.performWithDelay(typingSpeed, function()
            currentIndex = currentIndex + 1

            if currentIndex <= #text then
                -- Add one more character
                sceneObjects.dialogueText.text = string.sub(text, 1, currentIndex)
            else
                -- Typing complete
                cancelTyping()
            end
        end, #text)

        print("Narration (typing): " .. text)
        return bt.SUCCESS
    else
        print("Warning: dialogueText not available")
        return bt.FAILED
    end
end

return M
