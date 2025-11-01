-- Elara Actions
-- Consolidated actions for Elara character
-- Accepts action parameter to specify which Elara action to execute

local bt = require("btree")
local M = {}

-- Scene objects reference
local sceneObjects = {}

-- Action constants
M.ACTIONS = {
    SHOW = "show",
    CHANGE_TO_SCARED = "change_to_scared",
    PLAY_VOICE_LINE_1 = "play_voice_line_1",
    PLAY_VOICE_LINE_2 = "play_voice_line_2"
}

function M.initialize(objects)
    sceneObjects = objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for Elara")
        return bt.FAILED
    end

    if not sceneObjects.elara then
        print("Error: Elara object not found")
        return bt.FAILED
    end

    if action == M.ACTIONS.SHOW then
        return M.showElara()
    elseif action == M.ACTIONS.CHANGE_TO_SCARED then
        return M.changeToScared()
    elseif action == M.ACTIONS.PLAY_VOICE_LINE_1 then
        return M.playVoiceLine1()
    elseif action == M.ACTIONS.PLAY_VOICE_LINE_2 then
        return M.playVoiceLine2()
    else
        print("Error: Unknown Elara action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.showElara()
    -- Make Elara visible
    sceneObjects.elara.isVisible = true
    sceneObjects.elara.alpha = 0
    transition.fadeIn(sceneObjects.elara, { time = 1000 })

    print("Showing Elara")
    return bt.SUCCESS
end

function M.changeToScared()
    -- Change Elara to scared state
    local elaraView = require("views.elara_display")
    sceneObjects.elara = elaraView.changeState(sceneObjects.elara, "scared")

    print("Changed Elara to scared")
    return bt.SUCCESS
end

function M.playVoiceLine1()
    -- Play Elara voice line 1
    audio.play(audio.loadSound("sounds/elara_voice_1.mp3"), { channel = 4 })

    print("Playing Elara voice line 1")
    return bt.SUCCESS
end

function M.playVoiceLine2()
    -- Play Elara voice line 2
    audio.play(audio.loadSound("sounds/elara_voice_2.mp3"), { channel = 4 })

    print("Playing Elara voice line 2")
    return bt.SUCCESS
end

return M