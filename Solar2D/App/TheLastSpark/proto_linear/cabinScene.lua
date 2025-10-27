-------------------------------------------------------------------------------
-- Cabin Scene View - Demonstrates generic object state handling
-------------------------------------------------------------------------------
local composer = require("composer")

local scene = composer.newScene()
local controller = require("controllers.cabin_controller")
local model = require("models.cabin_model")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local ElaraDisplay = require("views.cabin.elara_display")
local LuminSeedDisplay = require("views.cabin.lumin_seed_display")
local ChestDisplay = require("views.cabin.chest_display")
local CabinDoorDisplay = require("views.cabin.cabin_door_display")

-- Layout map (helps visualize where interactive elements are placed)
local layout = {
    background = "images/bg_cabin.png",
    notes = [[
        [ elara ]      [ lumin_seed ]
              \            |
        [ chest ]   ---   [ cabin_door ]
    ]],
    objects = {
        elara = {
            x = (model.objects.elara or {}).x or 300,
            y = (model.objects.elara or {}).y or 500,
            width = (model.objects.elara or {}).width or 300,
            height = (model.objects.elara or {}).height or 500,
            neutralState = ((model.objects.elara or {}).states or {}).neutral or "images/elara_neutral.png",
        },
        lumin_seed = {
            x = (model.objects.lumin_seed or {}).x or display.contentCenterX,
            y = (model.objects.lumin_seed or {}).y or 400,
            width = (model.objects.lumin_seed or {}).width or 100,
            height = (model.objects.lumin_seed or {}).height or 100,
            idleState = ((model.objects.lumin_seed or {}).states or {}).normal or "images/lumin_seed_normal.png",
        },
        chest = {
            x = (model.objects.chest or {}).x or 420,
            y = (model.objects.chest or {}).y or 540,
            width = (model.objects.chest or {}).width or 170,
            height = (model.objects.chest or {}).height or 130,
            lockedState = ((model.objects.chest or {}).states or {}).locked or "images/chest_locked.png",
            visible = false,
        },
        cabin_door = {
            x = (model.objects.cabin_door or {}).x or 940,
            y = (model.objects.cabin_door or {}).y or 520,
            width = (model.objects.cabin_door or {}).width or 220,
            height = (model.objects.cabin_door or {}).height or 320,
            closedState = ((model.objects.cabin_door or {}).states or {}).closed or "images/door_closed.png",
            visible = false,
        },
    }
}

local elara, luminSeed, chest, cabinDoor
local background, vignette
local dialogueText, nextButton
local characterGroup, uiGroup

-- Initialize game data for conditional logic
_G.gameData = _G.gameData or {}
_G.gameData.hasKey = false
_G.gameData.hasMagicKey = false

local sceneDialogue = model.dialogue
local audioFiles = model.audio

function scene:create(event)
    local sceneGroup = self.view

    local layers = displayManager.createSceneLayers(sceneGroup)
    background = layers.background
    characterGroup = layers.characters
    uiGroup = layers.ui

    local backgroundElements = displayManager.createBackgroundLayer(background, {
        image = layout.background,
    })
    vignette = backgroundElements.vignette

    local uiElements = displayManager.createDialogueInterface(uiGroup, {
        onRelease = function() self:advanceDialogue() end,
    })
    dialogueText = uiElements.dialogueText
    nextButton = uiElements.nextButton

    -- Preload sample characters if desired (optional; object registry will create as needed)
    local elaraTemplate = (model.objects or {}).elara or {}
    local elaraLayout = layout.objects.elara or {}
    local elaraModelData = common.buildDisplayModel(elaraTemplate, elaraLayout, { visible = false })
    elara = ElaraDisplay.create(characterGroup, elaraModelData)

    local seedTemplate = (model.objects or {}).lumin_seed or {}
    local seedLayout = layout.objects.lumin_seed or {}
    local seedModelData = common.buildDisplayModel(seedTemplate, seedLayout, { visible = false })
    luminSeed = LuminSeedDisplay.create(characterGroup, seedModelData)

    local chestTemplate = (model.objects or {}).chest or {}
    local chestLayout = layout.objects.chest or {}
    local chestModelData = common.buildDisplayModel(chestTemplate, chestLayout, { visible = false })
    chest = ChestDisplay.create(characterGroup, chestModelData)

    local doorTemplate = (model.objects or {}).cabin_door or {}
    local doorLayout = layout.objects.cabin_door or {}
    local doorModelData = common.buildDisplayModel(doorTemplate, doorLayout, { visible = false })
    cabinDoor = CabinDoorDisplay.create(characterGroup, doorModelData)

    -- Object registry sourced from model definitions
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
    if self._objects.lumin_seed then
        self._objects.lumin_seed.image = luminSeed
        self._objects.lumin_seed.displayModule = LuminSeedDisplay
        self._objects.lumin_seed.parentGroup = characterGroup
        self._objects.lumin_seed.visible = luminSeed.isVisible
    end
    if self._objects.chest then
        self._objects.chest.image = chest
        self._objects.chest.displayModule = ChestDisplay
        self._objects.chest.parentGroup = characterGroup
        self._objects.chest.visible = chest.isVisible
    end
    if self._objects.cabin_door then
        self._objects.cabin_door.image = cabinDoor
        self._objects.cabin_door.displayModule = CabinDoorDisplay
        self._objects.cabin_door.parentGroup = characterGroup
        self._objects.cabin_door.visible = cabinDoor.isVisible
    end

    -- Attach helper methods via controller
    controller.attach(self, {
        background = background,
        vignette = vignette,
        dialogueText = dialogueText,
        nextButton = nextButton,
        characterGroup = characterGroup,
        elara = elara,
        luminSeed = luminSeed,
        chest = chest,
        cabinDoor = cabinDoor,
        sceneDialogue = sceneDialogue,
        audioFiles = audioFiles,
        objects = self._objects,
    })
end

function scene:show(event)
    if event.phase == "will" then
        self:executeSceneStep(1)
    end
end

function scene:hide(event)
    if event.phase == "will" then
        audio.stop()
    end
end

function scene:destroy(event)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
