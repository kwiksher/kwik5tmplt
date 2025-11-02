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
local tickTimer

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
            -- BTree handles navigation via tree structure
            print("Next button pressed (BTree mode)")
        end,
    })
    self.objs.dialogueText = uiElements.dialogueText
    self.objs.nextButton = uiElements.nextButton

    -- Pre-load characters (but don't show them yet)
    local elaraTemplate = (model.objects or {}).elara or {}
    local elaraLayout = layout.objects.elara or {}
    local elaraModelData = common.buildDisplayModel(elaraTemplate, elaraLayout, { visible = false })
    self.objs.elara = ElaraDisplay.create(self.objs.characterGroup, elaraModelData)

    local seedTemplate = (model.objects or {}).luminSeed or {}
    local seedLayout = layout.objects.luminSeed or {}
    local seedModelData = common.buildDisplayModel(seedTemplate, seedLayout, { visible = false })
    self.objs.luminSeed = LuminSeedDisplay.create(self.objs.characterGroup, seedModelData)

    local wolfTemplate = (model.objects or {}).wolf or {}
    local wolfLayout = layout.objects.wolf or {}
    local wolfModelData = common.buildDisplayModel(wolfTemplate, wolfLayout, { visible = false })
    self.objs.wolf = WolfDisplay.create(self.objs.characterGroup, wolfModelData)

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Load behavior tree
    behaviorTree = common.loadBehaviorTree("forest_scene.tree")
end

function scene:show(event)
    if event.phase == "will" then
        -- Start the behavior tree execution
        tickTimer = common.startBehaviorTree(behaviorTree)
    elseif event.phase == "did" then
        -- Scene is fully shown
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Stop behavior tree
        if tickTimer then
            timer.cancel(tickTimer)
            tickTimer = nil
        end

        -- Clean up audio
        audio.stop()  -- Stop all audio
    end
end

function scene:destroy(event)
    -- Clean up if needed
    if tickTimer then
        timer.cancel(tickTimer)
        tickTimer = nil
    end
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
