-------------------------------------------------------------------------------
-- narration Scene View - BTree Scaffold
-------------------------------------------------------------------------------
local BaseScene = require("Behavior.baseScene")
local common = require("behaivor.common_helpers")
local displayManager = require("Behavior.display_manager")

local scene = BaseScene:new("narration")

local actionController = require("Behavior.BTree_scaffold.actions.narration.narration_controller")
local conditionController = require("Behavior.BTree_scaffold.conditions.narration.narration_condition_controller")

local conditionNames = {
    -- no conditions

}

function scene:create(event)
    local sceneGroup = self.view

    self.objs = self.objs or {}

    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- TODO: add display objects

    actionController.initialize(self.objs)
    conditionController.initialize(self.objs)

    self.behaviorTree = common.loadBehaviorTree("Behavior/BTree_scaffold/narration_scene.tree", actionController, nil)

    print("narration Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        common.resetTreeController(self.treeController)
    elseif event.phase == "did" then
        if self.treeController and self.treeController.isComplete then
            return
        end

        if self.behaviorTree and not self.treeController then
            self.treeController = {
                tree = self.behaviorTree,
                isComplete = false,
                timerId = nil,
                tick = function(self)
                    if not self.isComplete then
                        for _, conditionName in ipairs(conditionNames) do
                            local status = conditionController.evaluate(conditionName)
                            if status ~= nil then
                                self.tree:setConditionStatus(conditionName, status)
                            end
                        end

                        local status = self.tree:tick()
                        common.handleTreeTickResult(self, status)
                    end
                end
            }

            self.treeController:tick()
        end
    end
end

function scene:hide(event)
    if event.phase == "will" then
        common.stopTreeController(self.treeController)
    end
end

function scene:destroy(event)
    print("narration Scene: Destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
