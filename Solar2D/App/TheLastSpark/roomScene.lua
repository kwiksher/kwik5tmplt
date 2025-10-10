-------------------------------------------------------------------------------
-- Room Scene - Demonstrates generic object state handling
-------------------------------------------------------------------------------

local scene = composer.newScene()
local widget = require("widget")
local helpers = require("App.TheLastSpark.forestScene_helpers")

local elara, luminSeed
local background, vignette
local dialogueText, nextButton
local characterGroup

local sceneDialogue = {
    { type = "narration", text = "You stand before an old cabin in the woods." },
    { type = "show", what = "cabin_door" },
    { type = "object_state", object = "cabin_door", state = "closed" },

    { type = "narration", text = "The door is firmly closed. You try the handle..." },
    { type = "sfx", sound = "door_rattle" },
    { type = "object_state", object = "cabin_door", state = "open" },
    { type = "sfx", sound = "door_creak" },

    { type = "narration", text = "The door creaks open, revealing a dark interior." },
    { type = "show", what = "elara" },
    { type = "emotion", character = "elara", state = "determined" },

    { type = "narration", text = "On a dusty table, you spot the Lumin Seed." },
    { type = "show", what = "lumin_seed" },
    { type = "object_state", object = "lumin_seed", state = "glowing" },

    { type = "narration", text = "In the corner, an old chest catches your eye." },
    { type = "show", what = "chest" },
    { type = "object_state", object = "chest", state = "locked" },

    { type = "narration", text = "The chest is locked. You search for a key..." },
    { type = "sfx", sound = "key_turn" },
    { type = "object_state", object = "chest", state = "unlocked" },
    { type = "sfx", sound = "chest_open" },
    { type = "object_state", object = "chest", state = "open" },

    { type = "narration", text = "The chest is empty! Someone got here first." },
    { type = "emotion", character = "elara", state = "scared" },
    { type = "object_state", object = "chest", state = "empty" },

    { type = "sfx", sound = "door_slam" },
    { type = "object_state", object = "cabin_door", state = "closed" },
    { type = "narration", text = "The door slams shut behind you! You're trapped!" },

    { type = "choice", options = {
        "Try to force the door open",
        "Search for another way out",
        "Investigate the strange markings"
    }}
}

local audioFiles = {
    door_rattle = "audio/sfx_door_rattle.wav",
    door_creak = "audio/sfx_door_creak.wav",
    key_turn = "audio/sfx_key_turn.wav",
    chest_open = "audio/sfx_chest_open.wav",
    door_slam = "audio/sfx_door_slam.wav",
}

function scene:create(event)
    local sceneGroup = self.view

    background = display.newGroup()
    characterGroup = display.newGroup()
    uiGroup = display.newGroup()

    sceneGroup:insert(background)
    sceneGroup:insert(characterGroup)
    sceneGroup:insert(uiGroup)

    local bgImage = display.newImageRect(background, "images/bg_cabin.png", 1280, 720)
    bgImage.x = display.contentCenterX
    bgImage.y = display.contentCenterY

    vignette = display.newRect(background, display.contentCenterX, display.contentCenterY, 1280, 720)
    vignette:setFillColor(0, 0, 0, 0.3)

    local dialogueBox = display.newRoundedRect(uiGroup, display.contentCenterX, 600, 1000, 120, 10)
    dialogueBox:setFillColor(0, 0, 0, 0.8)
    dialogueBox.strokeWidth = 2
    dialogueBox:setStrokeColor(0.5, 0.3, 0.1)

    dialogueText = display.newText({ parent = uiGroup, text = "", x = display.contentCenterX, y = 600, width = 900, height = 100, font = native.systemFont, fontSize = 24, align = "center" })
    dialogueText:setFillColor(1, 1, 1)

    nextButton = widget.newButton({
        label = "Next",
        shape = "roundedRect",
        width = 120,
        height = 50,
        cornerRadius = 10,
        fillColor = { default={0.2,0.5,0.2,1}, over={0.3,0.6,0.3,1} },
        labelColor = { default={1,1,1}, over={0.8,0.8,0.8} },
        onRelease = function() self:advanceDialogue() end
    })
    nextButton.x = display.contentWidth - 100
    nextButton.y = 660
    uiGroup:insert(nextButton)
    nextButton.isVisible = false

    -- Preload sample characters if desired (optional; object registry will create as needed)
    elara = display.newImageRect(characterGroup, "images/elara_neutral.png", 300, 500)
    elara.x, elara.y = 300, 500
    elara.isVisible = false

    luminSeed = display.newImageRect(characterGroup, "images/lumin_seed_normal.png", 100, 100)
    luminSeed.x, luminSeed.y = display.contentCenterX, 400
    luminSeed.isVisible = false

    -- Object registry
    self._objects = {
        elara = {
            image = elara,
            states = {
                neutral = "images/elara_neutral.png",
                scared = "images/elara_scared.png",
                determined = "images/elara_determined.png",
                happy = "images/elara_happy.png",
            }
        },
        cabin_door = {
            image = nil,
            states = {
                open = "images/door_open.png",
                closed = "images/door_closed.png",
                broken = "images/door_broken.png",
            },
            x = 900, y = 380, width = 220, height = 320
        },
        lumin_seed = {
            image = luminSeed,
            states = {
                normal = "images/lumin_seed_normal.png",
                glowing = "images/lumin_seed_glowing.png",
                dim = "images/lumin_seed_dim.png",
                pulsing = "images/lumin_seed_pulsing.png",
            }
        },
        chest = {
            image = nil,
            states = {
                locked = "images/chest_locked.png",
                unlocked = "images/chest_unlocked.png",
                open = "images/chest_open.png",
                empty = "images/chest_empty.png",
            },
            x = 600, y = 420, width = 170, height = 130
        },
    }

    -- Attach helper methods via metatable
    helpers.attach(self, {
        background = background,
        vignette = vignette,
        dialogueText = dialogueText,
        nextButton = nextButton,
        characterGroup = characterGroup,
        elara = elara,
        luminSeed = luminSeed,
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
