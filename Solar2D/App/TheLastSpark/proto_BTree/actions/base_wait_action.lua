-------------------------------------------------------------------------------
-- Base Wait Action
-- Base class for wait actions that pause tree execution
-- Returns RUNNING until clearWait is called
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

local BaseWaitAction = {}

-------------------------------------------------------------------------------
-- Creates a new wait action module
-- @return table - Action module with wait functionality
-------------------------------------------------------------------------------
function BaseWaitAction.new()
    -- Create action module with helper methods
    local M = actionHelper.createModule()

    -- Wait state - tracks which wait instance is currently waiting
    local currentWaitId = 0
    local nextWaitId = 1
    local clearedWaitId = 0

    -- Override initialize
    function M.initialize(objects)
        M.sceneObjects = objects
        currentWaitId = 0
        nextWaitId = 1
        clearedWaitId = 0
    end

    -- Clear the wait state (call this when Next button is pressed)
    function M.clearWait()
        -- Mark the current waiting instance as cleared
        clearedWaitId = currentWaitId
        print("Wait Action: Cleared wait ID " .. clearedWaitId)

        -- Clear the voice text (VO toast) immediately
        local audioHelper = require("utils.audio_helper")
        audioHelper.clearVoToast()

        -- Clear the narration text immediately
        if M.sceneObjects and M.sceneObjects.dialogueText then
            M.sceneObjects.dialogueText.text = ""
            print("Wait Action: Cleared narration text")
        end
    end

    -- Execute wait action - returns RUNNING until cleared
    function M.executeWaitForNext()
        -- If this is a new wait (not the current one), assign it an ID
        local isNewWait = (currentWaitId == 0)

        if isNewWait then
            -- Create a brand new wait instance
            currentWaitId = nextWaitId
            nextWaitId = nextWaitId + 1
            print("Wait Action: Started new wait ID " .. currentWaitId)

            -- Check if narration or VO is currently active
            local narrationAction = require("actions.forest.narration_action")
            local isNarrationActive = not narrationAction.isTypingComplete

            -- Check if player choices are visible
            local showChoicesAction = require("actions.forest.show_choices_action")
            local areChoicesVisible = showChoicesAction.choicesAreVisible

            -- Only show next button if no narration/VO/choices are in progress
            if M.sceneObjects and M.sceneObjects.nextButton then
                if areChoicesVisible then
                    -- Keep button hidden - choices are being shown
                    print("Wait Action: Player choices visible, keeping button hidden")
                elseif isNarrationActive then
                    -- Keep button hidden - narration will show it when complete
                    print("Wait Action: Narration in progress, keeping button hidden")
                else
                    -- Show button - no narration/VO/choices active
                    M.sceneObjects.nextButton.isVisible = true
                    M.sceneObjects.nextButton.alpha = 1.0
                    print("Wait Action: No narration/choices active, showing next button")
                end
            end

            -- Always return RUNNING on first encounter - don't check if cleared
            return bt.RUNNING
        elseif clearedWaitId == currentWaitId then
            -- This wait was cleared and needs to be recreated next time
            print("Wait Action: Wait ID " .. currentWaitId .. " was cleared, returning SUCCESS")
            currentWaitId = 0  -- Reset for next wait
            return bt.SUCCESS
        else
            -- Still waiting
            return bt.RUNNING
        end
    end

    -- Override execute to handle wait actions
    function M.execute(actionName)
        if actionName == "for next" then
            return M.executeWaitForNext()
        else
            print("Wait Actions: Unknown action type - " .. tostring(actionName))
            return bt.FAILED
        end
    end

    return M
end

return BaseWaitAction
