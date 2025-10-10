-------------------------------------------------------------------------------
-- Forest Scene - Solar2D Implementation
-------------------------------------------------------------------------------

local scene = composer.newScene()
local widget = require("widget")
local helpers = require("App.TheLastSpark.forestScene_helpers")

-- Local variables for this scene
local elara, wolf, luminSeed
local background, vignette
local dialogueText
local nextButton
local characterGroup

-- Scene sequence and dialogue
local sceneDialogue = {
    { type = "narration", text = "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light." },
    { type = "show", what = "luminseed" },
    { type = "show", what = "elara" },
    { type = "sfx", sound = "rustling" },
    { type = "sfx", sound = "wind", loop = true },
    { type = "vo", sound = "vo_elara_01", text = "The Lumin Seed was the last one. The last spark of the Great Tree's light..." },
    { type = "scene", background = "forest" },
    { type = "sfx", sound = "footsteps", loop = true },
    { type = "sfx", sound = "caw" },
    { type = "narration", text = "The forest is unnervingly quiet. No birdsong, no rustle of creatures." },
    { type = "sfx", sound = "growl" },
    { type = "show", what = "wolf" },
    { type = "music", sound = "tension", action = "play" },
    { type = "emotion", character = "elara", state = "scared" },
    { type = "vo", sound = "vo_elara_02", text = "Oh no." },
    { type = "choice", options = {
        "Fight it!",
        "Try to calm it.",
        "Run back to the cabin!"
    }}
}

-- Audio file mappings
local audioFiles = {
    rustling = "audio/sfx_rustling_cloth.wav",
    wind = "audio/sfx_wind_gentle.wav",
    footsteps = "audio/sfx_footsteps_forest.wav",
    caw = "audio/sfx_crow_caw_distant.wav",
    growl = "audio/sfx_wolf_growl_corrupted.wav",
    vo_elara_01 = "audio/elara_vo_01.wav",
    vo_elara_02 = "audio/elara_whisper_ohno.wav",
    tension = "audio/Music_Tension_Builds.mp3"
}

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Create display groups for organization
    background = display.newGroup()
    characterGroup = display.newGroup()
    uiGroup = display.newGroup()

    sceneGroup:insert(background)
    sceneGroup:insert(characterGroup)
    sceneGroup:insert(uiGroup)

    -- Initial background (cabin interior)
    local bgImage = display.newImageRect(background, "images/bg_cabin.png", 1280, 720)
    bgImage.x = display.contentCenterX
    bgImage.y = display.contentCenterY

    -- Create vignette for mood
    vignette = display.newRect(background, display.contentCenterX, display.contentCenterY, 1280, 720)
    vignette:setFillColor(0, 0, 0, 0.3)

    -- Dialogue box
    local dialogueBox = display.newRoundedRect(uiGroup, display.contentCenterX, 600, 1000, 120, 10)
    dialogueBox:setFillColor(0, 0, 0, 0.8)
    dialogueBox.strokeWidth = 2
    dialogueBox:setStrokeColor(0.5, 0.3, 0.1)

    -- Dialogue text
    dialogueText = display.newText({
        parent = uiGroup,
        text = "",
        x = display.contentCenterX,
        y = 600,
        width = 900,
        height = 100,
        font = native.systemFont,
        fontSize = 24,
        align = "center"
    })
    dialogueText:setFillColor(1, 1, 1)

    -- Next button (initially hidden)
    nextButton = widget.newButton({
        label = "Next",
        shape = "roundedRect",
        width = 120,
        height = 50,
        cornerRadius = 10,
        fillColor = { default={0.2,0.5,0.2,1}, over={0.3,0.6,0.3,1} },
        labelColor = { default={1,1,1}, over={0.8,0.8,0.8} },
        onRelease = function()
            self:advanceDialogue()
        end
    })
    nextButton.x = display.contentWidth - 100
    nextButton.y = 660
    uiGroup:insert(nextButton)
    nextButton.isVisible = false

    -- Pre-load characters (but don't show them yet)
    elara = display.newImageRect(characterGroup, "images/elara_neutral.png", 300, 500)
    elara.x = 300
    elara.y = 500
    elara.isVisible = false

    luminSeed = display.newImageRect(characterGroup, "images/item_lumin_seed.png", 100, 100)
    luminSeed.x = display.contentCenterX
    luminSeed.y = 400
    luminSeed.isVisible = false

    wolf = display.newImageRect(characterGroup, "images/corrupted_wolf_aggro.png", 400, 300)
    wolf.x = 900
    wolf.y = 450
    wolf.isVisible = false

    -- Attach helper methods now that scene objects exist
    helpers.attach(self, {
        background = background,
        vignette = vignette,
        dialogueText = dialogueText,
        nextButton = nextButton,
        characterGroup = characterGroup,
        elara = elara,
        wolf = wolf,
        luminSeed = luminSeed,
        sceneDialogue = sceneDialogue,
        audioFiles = audioFiles
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
-- Custom scene functions
-- -----------------------------------------------------------------------------------
-- Custom functions moved to helpers module

-- -----------------------------------------------------------------------------------
-- Scene event listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene