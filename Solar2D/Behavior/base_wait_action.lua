-------------------------------------------------------------------------------
-- Base Wait Action
-- Base class for wait actions that pause tree execution
-- Returns RUNNING until clearWait is called
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

local BaseWaitAction = {}

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
-- Creates a new wait action module
-- @return table - Action module with wait functionality
-------------------------------------------------------------------------------
function BaseWaitAction.new()
    local M = actionHelper.createModule()

    local currentWaitId = 0
    local nextWaitId = 1
    local clearedWaitId = 0
    local lastSuccessId = -1

    function M.initialize(objects)
        M.sceneObjects = objects
        currentWaitId = 0
        nextWaitId = 1
        clearedWaitId = 0
        lastSuccessId = -1
    end

    function M.reset()
        currentWaitId = 0
        nextWaitId = 1
        clearedWaitId = 0
        lastSuccessId = -1
    end

    function M.clearWait()
        clearedWaitId = currentWaitId
        print("Wait Action: Cleared wait ID " .. clearedWaitId)

        local audioHelper = require("behaivor.audio_helper")
        audioHelper.clearVoToast()

        if M.sceneObjects and M.sceneObjects.dialogueText then
            M.sceneObjects.dialogueText.text = ""
        end
    end

    function M.executeWaitForNext()
        local isNewWait = (currentWaitId == 0)

        if isNewWait then
            currentWaitId = nextWaitId
            nextWaitId = nextWaitId + 1

            local narrationAction = requireFirst({
                "Behavior.BTree_test.actions.narration.narration_actions",
                "Behavior.TheLastSpark.actions.cabin.narration_action",
                "Behavior.TheLastSpark.actions.forest.narration_action",
                "actions.narration.narration_actions",
                "actions.cabin.narration_action",
                "actions.forest.narration_action"
            })
            local isNarrationActive = narrationAction and (not narrationAction.isTypingComplete) or false

            local showChoicesAction = requireFirst({
                "Behavior.BTree_test.actions.narration.show_choices_action",
                "Behavior.TheLastSpark.actions.cabin.show_choices_action",
                "Behavior.TheLastSpark.actions.forest.show_choices_action",
                "actions.narration.show_choices_action",
                "actions.cabin.show_choices_action",
                "actions.forest.show_choices_action"
            })
            local areChoicesVisible = showChoicesAction and showChoicesAction.choicesAreVisible or false

            if M.sceneObjects and M.sceneObjects.nextButton then
                if areChoicesVisible then
                    print("Wait Action: Player choices visible, keeping button hidden")
                elseif isNarrationActive then
                    print("Wait Action: Narration in progress, keeping button hidden")
                else
                    M.sceneObjects.nextButton.isVisible = true
                    M.sceneObjects.nextButton.alpha = 1.0
                end
            end

            return bt.RUNNING
        elseif clearedWaitId == currentWaitId then
            currentWaitId = 0
            return bt.SUCCESS
        else
            return bt.RUNNING
        end
    end

    function M.execute(actionName)
        if actionName == "for next" then
            return M.executeWaitForNext()
        end

        print("Wait Actions: Unknown action type - " .. tostring(actionName))
        return bt.FAILED
    end

    return M
end

return BaseWaitAction
