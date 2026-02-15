-------------------------------------------------------------------------------
-- Base Narration Action
-- Base class for narration actions that display text with typing effect
-- Handles typing animation, button visibility, and completion events
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

local BaseNarrationAction = {}

-------------------------------------------------------------------------------
-- Creates a new narration action module
-- @param narrationTexts table - Map of text keys to narration strings
-- @return table - Action module with narration functionality
-------------------------------------------------------------------------------
function BaseNarrationAction.new(narrationTexts)
    local M = actionHelper.createModule()

    local sceneObjects = {}
    local typingTimer = nil

    M.isTypingComplete = true
    M.eventDispatcher = display.newGroup()

    local texts = narrationTexts or {}
    local _completedNarrations = {}

    function M.initialize(objects)
        sceneObjects = objects
    end

    function M.reset()
        _completedNarrations = {}
        M._completedActions = {}
    end

    local function cancelTyping()
        if typingTimer then
            timer.cancel(typingTimer)
            typingTimer = nil
        end
    end

    function M.showNarration(textKey)
        if _completedNarrations[textKey] then
            return bt.SUCCESS
        end

        local text = texts[textKey]
        if not text then
            print("Warning: Narration text not found for key: " .. tostring(textKey))
            return bt.FAILED
        end

        if not sceneObjects.dialogueText then
            print("Warning: dialogueText not available")
            return bt.FAILED
        end

        cancelTyping()
        M.isTypingComplete = false

        if sceneObjects.nextButton then
            sceneObjects.nextButton.isVisible = false
            sceneObjects.nextButton.alpha = 1.0
        end

        local currentIndex = 0
        local typingSpeed = 30
        local textLength = #text

        sceneObjects.dialogueText.text = ""

        typingTimer = timer.performWithDelay(typingSpeed, function()
            currentIndex = currentIndex + 1

            if currentIndex <= textLength then
                sceneObjects.dialogueText.text = string.sub(text, 1, currentIndex)
                return
            end

            cancelTyping()
            M.isTypingComplete = true
            _completedNarrations[textKey] = true

            local event = { name = "narrationComplete" }
            local result = M.eventDispatcher:dispatchEvent(event)

            if not result then
                timer.performWithDelay(4000, function()
                    if sceneObjects and sceneObjects.choicesVisible then
                        return
                    end

                    if sceneObjects and sceneObjects.nextButton then
                        sceneObjects.nextButton.isVisible = true
                        sceneObjects.nextButton.alpha = 1.0

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

        return bt.SUCCESS
    end

    M.ACTIONS = {}
    for key, _ in pairs(texts) do
        M.ACTIONS[key] = function()
            return M.showNarration(key)
        end
    end

    function M.execute(actionName)
        if M.ACTIONS[actionName] then
            return M.ACTIONS[actionName]()
        end

        print("Narration Action: Unknown narration key - " .. tostring(actionName))
        return bt.FAILED
    end

    return M
end

return BaseNarrationAction
