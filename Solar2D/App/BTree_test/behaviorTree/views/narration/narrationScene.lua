-------------------------------------------------------------------------------
-- narration Scene View - BTree Scaffold
-------------------------------------------------------------------------------
local BaseScene = require("views.baseScene")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local ChoiceDisplay = require("views.narration.choice_display")

local scene = BaseScene:new("narration")

local actionController = require("actions.narration.narration_controller")
local conditionController = require("conditions.narration.narration_condition_controller")
local waitActionModule = require("actions.narration.wait_action")

local conditionNames = {
    "player choice reload",
    "player choice continue",
}

local safeOriginX = display.safeScreenOriginX or display.screenOriginX or 0
local safeOriginY = display.safeScreenOriginY or display.screenOriginY or 0
local safeWidth = display.safeActualContentWidth or display.actualContentWidth or display.contentWidth or 320
local safeHeight = display.safeActualContentHeight or display.actualContentHeight or display.contentHeight or 480
local safeCenterX = safeOriginX + safeWidth * 0.5
local safeBottomY = safeOriginY + safeHeight
local dialogMargin = 16
local dialogHeight = 55
local buttonWidth = 110
local buttonHeight = 23
local dialogY = safeBottomY - dialogHeight * 0.5
local nextButtonY = dialogY
local dialogWidth = math.max(safeWidth - 48, 280)
local buttonX = safeOriginX + safeWidth - buttonWidth * 0.5 - dialogMargin
local choiceY = dialogY
local choiceOffset = 90

local layout = {
    dialogBox = {
        x = safeCenterX,
        y = dialogY,
        width = dialogWidth,
        height = dialogHeight
    },
    nextButton = {
        label = "Next",
        x = buttonX,
        y = nextButtonY,
        height = buttonHeight
    },
    choices = {
        {label = "Reload", x = safeOriginX + safeWidth * 0.25, y = choiceY, value = "reload"},
        {label = "Continue", x = safeOriginX + safeWidth * 0.75, y = choiceY, value = "continue"}
    }
}

function scene:create(event)
    local sceneGroup = self.view

    self.objs = self.objs or {}

    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- TODO: add display objects

    -- Use BaseScene initialization for dialogue interface
    self:initializeDialogueInterface(function()
        -- Clear the wait state and tick the behavior tree
        waitActionModule.clearWait()

        -- Also clear choice action wait state if exists
        local choiceActionModule = require("actions.narration.choice_action")
        if choiceActionModule and choiceActionModule.clearWait then
            choiceActionModule.clearWait()
        end

        if self.treeController and not self.treeController.isComplete then
            self.treeController:tick()
        end
    end, {
        -- Dialog box parameters
        x = layout.dialogBox.x,
        y = layout.dialogBox.y,
        width = layout.dialogBox.width,
        height = layout.dialogBox.height,
        -- Next button parameters
        buttonLabel = layout.nextButton.label,
        buttonX = layout.nextButton.x,
        buttonY = layout.nextButton.y,
        buttonWidth = layout.nextButton.width,
        buttonHeight = layout.nextButton.height
    })

    -- Initialize choice display system
    self.objs.choiceGroup = ChoiceDisplay:initialize(sceneGroup, self.objs, nil, layout.choices)

    -- Helper function to show choice buttons
    function self.showChoiceButtons()
        ChoiceDisplay:showChoiceButtons()
    end

    -- Helper function to hide choice buttons
    function self.hideChoiceButtons()
        ChoiceDisplay:hideChoiceButtons()
    end

    -- Store reference to scene for helper functions
    self.objs.showChoiceButtons = function() self.showChoiceButtons() end
    self.objs.hideChoiceButtons = function() self.hideChoiceButtons() end

    actionController.initialize(self.objs)
    conditionController.initialize(self.objs)

    self.behaviorTree = common.loadBehaviorTree("App/BTree_test/behaviorTree/narration_scene.tree", actionController, nil)

    -- Store condition controller for use in BaseScene's onShow
    self.conditionController = conditionController

    -- Store ChoiceDisplay for BaseScene cleanup
    self.ChoiceDisplay = ChoiceDisplay

    print("narration Scene: Created successfully")
end

-- Reset action modules (called by BaseScene on show)
function scene:resetActionModules()
    -- Reset narration actions
    local narrationActions = require("actions.narration.narration_actions")
    if narrationActions.reset then
        narrationActions.reset()
    end

    -- Reset wait action
    local waitAction = require("actions.narration.wait_action")
    if waitAction.reset then
        waitAction.reset()
    end

    -- Reinitialize show choices action
    local showChoicesAction = require("actions.narration.show_choices_action")
    if showChoicesAction.initialize then
        showChoicesAction.initialize(self.objs)
    end

    -- Reinitialize choice action
    local choiceAction = require("actions.narration.choice_action")
    if choiceAction.initialize then
        choiceAction.initialize(self.objs)
    end
end

function scene:show(event)
    -- Call BaseScene's onShow to handle behavior tree initialization
    self:onShow(event.phase)
end

function scene:hide(event)
    -- Call BaseScene's onHide to handle cleanup
    self:onHide(event.phase)
end

function scene:destroy(event)
    -- Call BaseScene's onDestroy to handle cleanup
    self:onDestroy()
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners - Use BaseScene's setupEventListeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:setupEventListeners()

return scene
