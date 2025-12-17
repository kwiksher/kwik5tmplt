-------------------------------------------------------------------------------
-- Forest Scene View - Solar2D Implementation
-------------------------------------------------------------------------------
local composer = require("composer")

local scene = composer.newScene()
local controller = require("controllers.forest_controller")
local model = require("models.forest_model")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local ElaraDisplay = require("views.forest.elara_display")
local LuminSeedDisplay = require("views.forest.lumin_seed_display")
local WolfDisplay = require("views.forest.wolf_display")

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

-- Local variables for this scene
local elara, wolf, luminSeed
local background, vignette
local dialogueText
local nextButton
local characterGroup, uiGroup

-- Scene sequence and dialogue
local sceneDialogue = model.dialogue

-- Audio file mappings
local audioFiles = model.audio

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Create display groups for organization
    local layers = displayManager.createSceneLayers(sceneGroup)
    background = layers.background
    characterGroup = layers.characters

    uiGroup = layers.ui

    -- Initial background (cabin interior)
    local backgroundElements = displayManager.createBackgroundLayer(background, {
        image = layout.background,
    })
    vignette = backgroundElements.vignette

    -- Dialogue elements (text plus navigation)
    local uiElements = displayManager.createDialogueInterface(uiGroup, {
        onRelease = function()
            self:advanceDialogue()
        end,
    })
    dialogueText = uiElements.dialogueText
    nextButton = uiElements.nextButton

    -- Pre-load characters (but don't show them yet)
    local elaraTemplate = (model.objects or {}).elara or {}
    local elaraLayout = layout.objects.elara or {}
    local elaraModelData = common.buildDisplayModel(elaraTemplate, elaraLayout, { visible = false })
    elara = ElaraDisplay.create(characterGroup, elaraModelData)

    local seedTemplate = (model.objects or {}).luminSeed or {}
    local seedLayout = layout.objects.luminSeed or {}
    local seedModelData = common.buildDisplayModel(seedTemplate, seedLayout, { visible = false })
    luminSeed = LuminSeedDisplay.create(characterGroup, seedModelData)

    local wolfTemplate = (model.objects or {}).wolf or {}
    local wolfLayout = layout.objects.wolf or {}
    local wolfModelData = common.buildDisplayModel(wolfTemplate, wolfLayout, { visible = false })
    wolf = WolfDisplay.create(characterGroup, wolfModelData)

    -- Object registry for state management (hydrated from model templates)
    self._objects = {}
    for name, template in pairs(model.objects or {}) do
        self._objects[name] = common.deepCopy(template)
    end
    if self._objects.elara then
        self._objects.elara.image = elara
        self._objects.elara.displayModule = ElaraDisplay
        self._objects.elara.parentGroup = characterGroup
        self._objects.elara.visible = elara.isVisible
    end
    if self._objects.wolf then
        self._objects.wolf.image = wolf
        self._objects.wolf.displayModule = WolfDisplay
        self._objects.wolf.parentGroup = characterGroup
        self._objects.wolf.visible = wolf.isVisible
    end
    if self._objects.luminSeed then
        self._objects.luminSeed.image = luminSeed
        self._objects.luminSeed.displayModule = LuminSeedDisplay
        self._objects.luminSeed.parentGroup = characterGroup
        self._objects.luminSeed.visible = luminSeed.isVisible
    end

    -- Attach helper methods now that scene objects exist
    controller.attach(self, {
        background = background,
        vignette = vignette,
        dialogueText = dialogueText,
        nextButton = nextButton,
        characterGroup = characterGroup,
        elara = elara,
        wolf = wolf,
        luminSeed = luminSeed,
        sceneDialogue = sceneDialogue,
        audioFiles = audioFiles,
        objects = self._objects,
    })
end

function scene:show(event)
    if event.phase == "will" then
        -- Start the scene sequence
        self:executeSceneStep(1)
    elseif event.phase == "did" then
        -- Scene is fully shown
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Clean up audio
        audio.stop()  -- Stop all audio
    end
end

function scene:destroy(event)
    -- Clean up if needed
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
