-------------------------------------------------------------------------------
-- Audio Helper - Generic audio action module creator
-- Creates audio action modules from models with audio and dialogue tables
-------------------------------------------------------------------------------

local bt = require("btree")
local actionHelper = require("utils.action_helper")

local M = {}

-- Create an audio actions module from a model
-- modelPath: string path to the model (e.g., "models.forest_model")
-- logPrefix: optional string for log messages (default: "Audio Actions")
function M.new(modelPath, logPrefix)
    logPrefix = logPrefix or "Audio Actions"

    -- Create action module with helper methods
    local audioModule = actionHelper.new()

    -- Preloaded audio handles
    local audioHandles = {}

    -- Audio file paths (will be loaded from model)
    local audioPaths = {}

    -- Sound type mapping (from dialogue)
    local soundTypes = {}

    -- Override initialize to handle audio preloading
    function audioModule.initialize(objects)
        audioModule.sceneObjects = objects

        -- Load audio configuration from model
        local model = require(modelPath)
        audioPaths = model.audio or {}

        -- Build a map of sound types from dialogue
        if model.dialogue then
            for _, entry in ipairs(model.dialogue) do
                if entry.sound then
                    soundTypes[entry.sound] = entry.type
                end
            end
        end

        -- Preload all audio files
        print(logPrefix .. ": Preloading audio files...")

        for soundName, filePath in pairs(audioPaths) do
            local soundType = soundTypes[soundName] or "sfx"  -- Default to sfx if not found

            -- Use loadStream for music and voice-over, loadSound for SFX
            local isStream = (soundType == "music" or soundType == "vo")
            audioHandles[soundName] = audioModule.loadAudio(soundName, filePath, isStream)

            local loadType = isStream and "stream" or "sound"
            print("  Loaded (" .. loadType .. "): " .. soundName .. " [" .. soundType .. "] -> " .. filePath)
        end

        print(logPrefix .. ": All audio files preloaded")
    end

    -- Override execute to handle audio playback
    function audioModule.execute(action)
        if not action then
            print("Error: No action specified for Audio")
            return bt.FAILED
        end

        -- Check if audio handle exists for this action
        if audioHandles[action] then
            print(logPrefix .. ": Playing " .. action)
            local channel = audioModule.getChannelForSound(action)
            return audioModule.playAudio(audioHandles[action], { channel = channel })
        else
            print("Error: Unknown Audio action - " .. tostring(action))
            return bt.FAILED
        end
    end

    -- Determine appropriate audio channel based on sound type
    function audioModule.getChannelForSound(soundName)
        local soundType = soundTypes[soundName] or "sfx"

        -- Music on channel 1
        if soundType == "music" then
            return 1
        -- Voice-over on channel 4
        elseif soundType == "vo" then
            return 4
        -- SFX on channel 2 (default)
        else
            return 2
        end
    end

    return audioModule
end

return M
