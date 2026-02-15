-------------------------------------------------------------------------------
-- narration Scene View - BTree Scaffold
-------------------------------------------------------------------------------
local BaseScene = require("Behavior.baseScene")
local common = require("behaivor.common_helpers")
local behaviorConfig = require("Behavior.config")
local displayManager = require("Behavior.display_manager")
local ChoiceDisplay = require("views.narration.choice_display")

local scene = BaseScene:new("narration")

local actionController = require("actions.narration.narration_controller")
local conditionController = require("conditions.narration.narration_condition_controller")
local waitActionModule = require("actions.narration.wait_action")

local conditionNames = {
    "player choice reload",
    "player choice continue",
}

local uiLayout = behaviorConfig.getDialogueLayout()
local choiceY = uiLayout.dialogY

local layout = {
    dialogBox = {
        x = uiLayout.safeCenterX,
        y = uiLayout.dialogY,
        width = uiLayout.dialogWidth,
        height = uiLayout.dialogHeight
    },
    nextButton = {
        label = "Next",
        x = uiLayout.buttonX,
        y = uiLayout.nextButtonY,
        width = uiLayout.buttonWidth,
        height = uiLayout.buttonHeight
    },
    choices = {
        {label = "Reload", x = uiLayout.safeOriginX + uiLayout.safeWidth * 0.25, y = choiceY, value = "reload"},
        {label = "Continue", x = uiLayout.safeOriginX + uiLayout.safeWidth * 0.75, y = choiceY, value = "continue"}
    }
}

local function traceUiState(self, tag)
    local objs = self and self.objs
    local btn = objs and objs.nextButton
    local dialogue = objs and objs.dialogueText
    local uiGroup = objs and objs.uiGroup
    local tree = self and self.treeController
    local timerNow = system.getTimer() or 0

    if not objs then
        print("[TRACE narration.ui] " .. tostring(tag) .. " objs=nil")
        return
    end

    local enabledState = "n/a"
    if btn then
        if btn._view and btn._view._isEnabled ~= nil then
            enabledState = tostring(btn._view._isEnabled)
        elseif btn.isEnabled ~= nil then
            enabledState = tostring(btn.isEnabled)
        elseif btn.setEnabled then
            enabledState = "unknown(has setEnabled)"
        end
    end

    print("[TRACE narration.ui] " .. tostring(tag)
        .. " timer=" .. tostring(timerNow)
        .. " btn=" .. tostring(btn ~= nil)
        .. " visible=" .. tostring(btn and btn.isVisible)
        .. " alpha=" .. tostring(btn and btn.alpha)
        .. " enabled=" .. enabledState
        .. " x=" .. tostring(btn and btn.x)
        .. " y=" .. tostring(btn and btn.y)
        .. " uiVisible=" .. tostring(uiGroup and uiGroup.isVisible)
        .. " dialogueVisible=" .. tostring(dialogue and dialogue.isVisible)
        .. " playerChoice=" .. tostring(objs.playerChoice)
        .. " suppressUntil=" .. tostring(objs._suppressChoiceTapUntil)
        .. " treeComplete=" .. tostring(tree and tree.isComplete)
    )
end

function scene:create(event)
    local sceneGroup = self.view
    if not sceneGroup then
        sceneGroup = display.newGroup()
        self.view = sceneGroup
    end

    self.objs = self.objs or {}

    if displayManager and displayManager.createSceneLayers then
        local layers = displayManager.createSceneLayers(sceneGroup)
        self.objs.background = layers.background
        self.objs.characterGroup = layers.characters
        self.objs.uiGroup = layers.ui
    else
        self:initializeDisplay(sceneGroup, {})
    end

    -- TODO: add display objects

    -- Use BaseScene initialization for dialogue interface
    self:initializeDialogueInterface(function()
        traceUiState(self, "onRelease.beforeClear")

        -- Clear the wait state and tick the behavior tree
        waitActionModule.clearWait()
        traceUiState(self, "onRelease.afterWaitClear")

        -- Also clear choice action wait state if exists
        local choiceActionModule = require("actions.narration.choice_action")
        if choiceActionModule and choiceActionModule.clearWait then
            choiceActionModule.clearWait()
            traceUiState(self, "onRelease.afterChoiceClear")
        end

        if self.treeController and not self.treeController.isComplete then
            self.treeController:tick()
            traceUiState(self, "onRelease.afterTreeTick")
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
        textWidth = uiLayout.dialogTextWidth,
            textHeight = uiLayout.dialogTextHeight,
        fontSize = uiLayout.dialogueFontSize,
        buttonWidth = layout.nextButton.width,
        buttonHeight = layout.nextButton.height
    })
    traceUiState(self, "create.afterInitDialogue")

    -- Initialize choice display system
    local okChoiceInit, choiceResult = pcall(function()
        return ChoiceDisplay:initialize(sceneGroup, self.objs, nil, layout.choices)
    end)
    if okChoiceInit then
        self.objs.choiceGroup = choiceResult
    else
        print("ChoiceDisplay initialize error:", choiceResult)
        self.objs.choiceGroup = nil
    end

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

    self.behaviorTree = common.loadBehaviorTree("Behavior/BTree_test/narration_scene.tree", actionController, nil)

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

function scene:onShow(phase)
    traceUiState(self, "show." .. tostring(phase) .. ".beforeOnShow")
    BaseScene.onShow(self, phase)
    traceUiState(self, "show." .. tostring(phase) .. ".afterOnShow")

    if phase == "will" and self.objs then
        if self.treeController and self.treeController.reset then
            self.treeController:reset()
            self.treeController.isComplete = false
        end

        self.objs.playerChoice = nil

        local showChoicesAction = require("actions.narration.show_choices_action")
        if showChoicesAction and showChoicesAction.initialize then
            showChoicesAction.initialize(self.objs)
        end

        if self.hideChoiceButtons then
            self:hideChoiceButtons()
        end

        if self.objs.uiGroup then
            self.objs.uiGroup.isVisible = true
            self.objs.uiGroup.alpha = 1
        end

        if self.objs.dialogueText then
            self.objs.dialogueText.isVisible = true
            self.objs.dialogueText.alpha = 1
        end

        if self.objs.nextButton then
            transition.cancel("buttonBlink")
            transition.cancel(self.objs.nextButton)
            self.objs.nextButton.alpha = 1
            self.objs.nextButton.isVisible = true
            if self.objs.nextButton.setEnabled then
                self.objs.nextButton:setEnabled(true)
            end
            self.objs.nextButton:toFront()
        end
        traceUiState(self, "show.will.afterRestore")
    elseif phase == "did" and self.objs and self.objs.nextButton then
        self.objs.nextButton.isVisible = true
        self.objs.nextButton.alpha = 1
        if self.objs.nextButton.setEnabled then
            self.objs.nextButton:setEnabled(true)
        end
        self.objs.nextButton:toFront()
        traceUiState(self, "show.did.afterRestore")
        timer.performWithDelay(100, function()
            if self and self.objs then
                traceUiState(self, "show.did.plus100ms")
            end
        end)
    end
end

function scene:onHide(phase)
    traceUiState(self, "hide." .. tostring(phase) .. ".beforeOnHide")
    BaseScene.onHide(self, phase)
    traceUiState(self, "hide." .. tostring(phase) .. ".afterOnHide")
end

function scene:onDestroy()
    BaseScene.onDestroy(self)
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners - Use BaseScene's setupEventListeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:setupEventListeners()

return scene
