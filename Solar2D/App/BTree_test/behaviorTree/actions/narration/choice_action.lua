-- Choice Action Module
-- Handles the narrative actions after player makes a choice (reload, continue)
-- Returns RUNNING while typing, SUCCESS when complete
-- Uses BaseChoiceAction for common functionality

local BaseChoiceAction = require("actions.base_choice_action")
local composer = require("composer")

-- Choice configuration: narration and scene
local CHOICE_CONFIG = {
    reload = {
        narration = "Reloading the scene...",
        scene = "reload",
        callback = function()
            -- Reload current scene
            local currentScene = composer.getSceneName("current")
            if currentScene then
                composer.removeScene(currentScene)
                composer.gotoScene(currentScene, {
                    effect = "fade",
                    time = 300
                })
            end
        end
    },
    continue = {
        narration = "Continuing to the next scene...",
        scene = "continue",
        callback = function()
            -- Go to empty scene
            composer.gotoScene("App.BTree_test.behaviorTree.views.emptyScene", {
                effect = "slideLeft",
                time = 300
            })
        end
    }
}

-- Create module using base class
local M = BaseChoiceAction.new(CHOICE_CONFIG)

return M
