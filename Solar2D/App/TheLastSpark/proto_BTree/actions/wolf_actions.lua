-- Wolf Actions
-- Consolidated actions for Wolf character
-- Accepts action parameter to specify which Wolf action to execute

local bt = require("btree")
local M = {}

-- Scene objects reference
local sceneObjects = {}

-- Action constants
M.ACTIONS = {
    SHOW = "show",
    PLAY_GROWL = "play_growl"
}

function M.initialize(objects)
    sceneObjects = objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for Wolf")
        return bt.FAILED
    end

    if action == M.ACTIONS.SHOW then
        return M.showWolf()
    elseif action == M.ACTIONS.PLAY_GROWL then
        return M.playGrowl()
    else
        print("Error: Unknown Wolf action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.showWolf()
    if not sceneObjects.wolf then
        print("Error: Wolf object not found")
        return bt.FAILED
    end

    -- Make wolf visible
    sceneObjects.wolf.isVisible = true
    sceneObjects.wolf.alpha = 0
    transition.fadeIn(sceneObjects.wolf, { time = 1000 })

    print("Showing wolf")
    return bt.SUCCESS
end

function M.playGrowl()
    -- Play wolf growl sound effect
    audio.play(audio.loadSound("sounds/wolf_growl.mp3"), { channel = 3 })

    print("Playing wolf growl")
    return bt.SUCCESS
end

return M