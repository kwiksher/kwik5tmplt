-- Audio Actions
-- Consolidated actions for ambient/background audio
-- Accepts action parameter to specify which audio to play

local bt = require("btree")
local M = {}

-- Action constants
M.ACTIONS = {
    RUSTLING_SOUND = "rustling_sound",
    WIND_SOUND = "wind_sound",
    FOOTSTEPS_SOUND = "footsteps_sound",
    CROW_CAW_SOUND = "crow_caw_sound",
    TENSION_MUSIC = "tension_music"
}

function M.initialize(objects)
    -- Audio actions don't typically need scene objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for Audio")
        return bt.FAILED
    end

    if action == M.ACTIONS.RUSTLING_SOUND then
        return M.playRustlingSound()
    elseif action == M.ACTIONS.WIND_SOUND then
        return M.playWindSound()
    elseif action == M.ACTIONS.FOOTSTEPS_SOUND then
        return M.playFootstepsSound()
    elseif action == M.ACTIONS.CROW_CAW_SOUND then
        return M.playCrowCawSound()
    elseif action == M.ACTIONS.TENSION_MUSIC then
        return M.playTensionMusic()
    else
        print("Error: Unknown Audio action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.playRustlingSound()
    -- Play rustling sound effect
    audio.play(audio.loadSound("sounds/rustling.mp3"), { channel = 2 })

    print("Playing rustling sound")
    return bt.SUCCESS
end

function M.playWindSound()
    -- Play wind sound effect
    audio.play(audio.loadSound("sounds/wind.mp3"), { channel = 2 })

    print("Playing wind sound")
    return bt.SUCCESS
end

function M.playFootstepsSound()
    -- Play footsteps sound effect
    audio.play(audio.loadSound("sounds/footsteps.mp3"), { channel = 2 })

    print("Playing footsteps sound")
    return bt.SUCCESS
end

function M.playCrowCawSound()
    -- Play crow caw sound effect
    audio.play(audio.loadSound("sounds/crow_caw.mp3"), { channel = 2 })

    print("Playing crow caw sound")
    return bt.SUCCESS
end

function M.playTensionMusic()
    -- Play tension music
    audio.play(audio.loadSound("sounds/tension_music.mp3"), { channel = 1 })

    print("Playing tension music")
    return bt.SUCCESS
end

return M