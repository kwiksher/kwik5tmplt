-------------------------------------------------------------------------------
-- Forest Scene Helpers - Extracted custom functions for forestScene.lua
-------------------------------------------------------------------------------

local M = {}
local widget = require("widget")
local common = require("App.TheLastSpark.common_helpers")

-- Attach helper methods to a scene with captured environment/state.
-- env fields expected:
--  background, vignette, dialogueText, nextButton, characterGroup,
--  elara, wolf, luminSeed, sceneDialogue, audioFiles
function M.attach(scene, env)
    -- Internal mutable state captured in closures
    local background = env.background
    local vignette = env.vignette
    local dialogueText = env.dialogueText
    local nextButton = env.nextButton
    local characterGroup = env.characterGroup

    local elara = env.elara
    local wolf = env.wolf
    local luminSeed = env.luminSeed

    local sceneDialogue = env.sceneDialogue or {}
    local audioFiles = env.audioFiles or {}

    -- attach runtime state onto env so common methods can access it
    env.state = env.state or { currentDialogueIndex = 1, isChoiceActive = false, choiceGroup = nil }
    env.background = background
    env.vignette = vignette
    env.dialogueText = dialogueText
    env.nextButton = nextButton
    env.characterGroup = characterGroup
    env.elara = elara
    env.wolf = wolf
    env.luminSeed = luminSeed
    env.sceneDialogue = sceneDialogue
    env.audioFiles = audioFiles

    -- set self._env and install methods via metatable
    scene._env = env
    local mt = getmetatable(scene) or {}
    mt.__index = function(t, k)
        return common.methods[k] or rawget(common.methods, k) or rawget(t, k)
    end
    setmetatable(scene, mt)

    function scene:showObject(object)
        if object == "elara" then
            if elara then transition.fadeIn(elara, { time = 1000 }) end
        elseif object == "luminseed" then
            if luminSeed then
                luminSeed.isVisible = true
                transition.scaleTo(luminSeed, { xScale = 1.2, yScale = 1.2, time = 500 })
                transition.scaleTo(luminSeed, { xScale = 1.0, yScale = 1.0, time = 500, delay = 500 })
            end
        elseif object == "wolf" then
            if wolf then
                wolf.isVisible = true
                transition.from(wolf, { x = 1400, time = 800, transition = easing.outBack })
            end
        end
    end

    -- changeBackground, playSFX, advanceDialogue, showDialogue, showChoice, handleChoice
    -- are provided by common.methods via metatable


    function scene:changeEmotion(character, state)
        if character == "elara" and state == "scared" then
            if elara and elara.removeSelf then
                pcall(function() elara:removeSelf() end)
            end
            elara = display.newImageRect(characterGroup, "images/elara_scared.png", 300, 500)
            elara.x = 300
            elara.y = 500
        end
    end

    -- showObject and changeEmotion are scene-specific and remain here

    function scene:transitionToNextScene()
        common.gotoSceneByChoice({
            [1] = "scenes.fightScene",
            [2] = "scenes.calmScene",
            default = "scenes.retreatScene",
        }, { effect = "fade", time = 1000 })
    end
end

return M
