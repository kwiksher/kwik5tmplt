-------------------------------------------------------------------------------
-- Forest Scene View - BTree Implementation
-------------------------------------------------------------------------------
local composer = require("composer")

local scene = composer.newScene()
local model = require("models.forest_model")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local ElaraDisplay = require("views.forest.elara_display")
local LuminSeedDisplay = require("views.forest.lumin_seed_display")
local WolfDisplay = require("views.forest.wolf_display")

-- BTree components
local bt = require("utils.btree")
local actionController = require("actions.forest_actions")
local conditionController = require("conditions.forest_conditions")
local waitActionModule = require("actions.forest.wait_action")

-- Layout diagram (keeps object placement explicit, similar to BT test scene)
local layout = {
    background = "images/bg_cabin.png",
    notes = [[
        [ luminSeed ]   → trail →   [ wolf ]
                 |                       ↑
              [ elara ]           (forest edge)
    ]],
    objects = {
        elara = {
            x = (model.objects.elara or {}).x or 300,
            y = (model.objects.elara or {}).y or 500,
            width = (model.objects.elara or {}).width or 300,
            height = (model.objects.elara or {}).height or 500,
            neutralState = ((model.objects.elara or {}).states or {}).neutral or "images/elara_neutral.png",
        },
        wolf = {
            x = (model.objects.wolf or {}).x or 900,
            y = (model.objects.wolf or {}).y or 450,
            width = (model.objects.wolf or {}).width or 400,
            height = (model.objects.wolf or {}).height or 300,
            aggroState = ((model.objects.wolf or {}).states or {}).aggro or "images/corrupted_wolf_aggro.png",
        },
        luminSeed = {
            x = (model.objects.luminSeed or {}).x or display.contentCenterX,
            y = (model.objects.luminSeed or {}).y or 400,
            width = (model.objects.luminSeed or {}).width or 100,
            height = (model.objects.luminSeed or {}).height or 100,
            idleState = ((model.objects.luminSeed or {}).states or {}).normal or "images/item_lumin_seed.png",
        },
    }
}

-- BTree state
local behaviorTree
local treeController  -- Manual controller instead of timer

-- Scene sequence and dialogue
local sceneDialogue = model.dialogue

-- Audio file mappings
local audioFiles = model.audio

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Initialize display objects container
    self.objs = {}

    -- Create display groups for organization
    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- Initial background (cabin interior)
    local backgroundElements = displayManager.createBackgroundLayer(self.objs.background, {
        image = layout.background,
    })
    self.objs.vignette = backgroundElements.vignette

    -- Dialogue elements (text plus navigation)
    local uiElements = displayManager.createDialogueInterface(self.objs.uiGroup, {
        onRelease = function()
            -- Clear the wait state and tick the behavior tree
            waitActionModule.clearWait()

            if treeController and not treeController.isComplete then
                treeController:tick()
            end
        end,
    })
    self.objs.dialogueText = uiElements.dialogueText
    self.objs.nextButton = uiElements.nextButton

    -- Make button visible for manual control
    self.objs.nextButton.isVisible = true

    -- Create a separate group for choice buttons (on top of everything)
    self.objs.choiceGroup = display.newGroup()
    sceneGroup:insert(self.objs.choiceGroup)

    -- Create player choice buttons (initially hidden)
    local function createChoiceButton(label, x, y, choice)
        local button = display.newRoundedRect(self.objs.choiceGroup, x, y, 200, 60, 12)
        button.strokeWidth = 3
        button:setFillColor(0.2, 0.3, 0.5)
        button:setStrokeColor(0.8, 0.8, 0.8)

        local buttonText = display.newText({
            parent = self.objs.choiceGroup,
            text = label,
            x = x,
            y = y,
            font = native.systemFontBold,
            fontSize = 24
        })
        buttonText:setFillColor(1, 1, 1)

        button.isVisible = false
        buttonText.isVisible = false

        button.label = buttonText
        button:addEventListener("tap", function()
            -- Set the player choice
            self.objs.playerChoice = choice
            print("Player chose: " .. choice)

            -- Hide all choice buttons
            self.objs.fightButton.isVisible = false
            self.objs.fightButton.label.isVisible = false
            self.objs.calmButton.isVisible = false
            self.objs.calmButton.label.isVisible = false
            self.objs.retreatButton.isVisible = false
            self.objs.retreatButton.label.isVisible = false

            -- Clear wait and advance tree
            waitActionModule.clearWait()
            if treeController and not treeController.isComplete then
                treeController:tick()
            end
        end)

        return button
    end

    -- Create three choice buttons
    self.objs.fightButton = createChoiceButton("Fight", display.contentCenterX - 220, display.contentHeight - 150, "fight")
    self.objs.calmButton = createChoiceButton("Calm", display.contentCenterX, display.contentHeight - 150, "calm")
    self.objs.retreatButton = createChoiceButton("Retreat", display.contentCenterX + 220, display.contentHeight - 150, "retreat")

    -- Helper function to show choice buttons
    function self.showChoiceButtons()
        self.objs.nextButton.isVisible = false  -- Hide Next button when showing choices

        -- Bring choice group to absolute front
        if self.objs.choiceGroup then
            self.objs.choiceGroup:toFront()
        end

        -- Show buttons
        self.objs.fightButton.isVisible = true
        self.objs.fightButton.label.isVisible = true
        self.objs.calmButton.isVisible = true
        self.objs.calmButton.label.isVisible = true
        self.objs.retreatButton.isVisible = true
        self.objs.retreatButton.label.isVisible = true
    end

    -- Helper function to hide choice buttons
    function self.hideChoiceButtons()
        self.objs.nextButton.isVisible = true  -- Show Next button again
        self.objs.fightButton.isVisible = false
        self.objs.fightButton.label.isVisible = false
        self.objs.calmButton.isVisible = false
        self.objs.calmButton.label.isVisible = false
        self.objs.retreatButton.isVisible = false
        self.objs.retreatButton.label.isVisible = false
    end

    -- Helper function to change background image
    function self.changeBackground(imagePath)
        if not self.objs.background then
            print("Warning: Background group not found")
            return false
        end

        -- Remove existing background objects (children of the background group)
        for i = self.objs.background.numChildren, 1, -1 do
            local child = self.objs.background[i]
            if child then
                child:removeSelf()
            end
        end

        -- Create new background with the same structure as original
        local backgroundElements = displayManager.createBackgroundLayer(self.objs.background, {
            image = imagePath,
        })
        self.objs.vignette = backgroundElements.vignette

        print("Changed background to: " .. imagePath)
        return true
    end

    -- Pre-load characters (but don't show them yet)
    self.objs.elara = common.createCharacter("elara", model, layout, self.objs.characterGroup, ElaraDisplay)
    self.objs.luminSeed = common.createCharacter("luminSeed", model, layout, self.objs.characterGroup, LuminSeedDisplay)
    self.objs.wolf = common.createCharacter("wolf", model, layout, self.objs.characterGroup, WolfDisplay)

    -- Store reference to scene for helper functions
    self.objs.showChoiceButtons = function() self.showChoiceButtons() end
    self.objs.hideChoiceButtons = function() self.hideChoiceButtons() end
    self.objs.changeBackground = function(imagePath) return self.changeBackground(imagePath) end

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Initialize condition controller with scene objects
    conditionController.initialize(self.objs)

    -- Load behavior tree and register action/condition handlers
    behaviorTree = common.loadBehaviorTree("forest_scene.tree", actionController, conditionController)
end

function scene:show(event)
    if event.phase == "will" then
        -- Create manual behavior tree controller instead of auto-ticking
        treeController = common.createManualBehaviorTree(behaviorTree, conditionController)
        print("Use the Next button to advance through the story")
    elseif event.phase == "did" then
        -- Scene is fully shown
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Clean up controller
        treeController = nil

        -- Clean up audio
        audio.stop()  -- Stop all audio
    end
end

function scene:destroy(event)
    -- Clean up if needed
    treeController = nil
    behaviorTree = nil
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
