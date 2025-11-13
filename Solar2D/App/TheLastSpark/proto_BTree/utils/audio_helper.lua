-------------------------------------------------------------------------------
-- Audio Helper - Generic audio action module creator
-- Creates audio action modules from models with audio and dialogue tables
-------------------------------------------------------------------------------

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

local M = {}

-- Track active toasts for positioning
local activeToasts = {}

-- Active vo toast reference (only one at a time)
local activeVoToast = nil

-- Helper function to show a voice-over text toast
local function showVoToast(message, duration)
    duration = duration or 5000  -- Longer duration for vo text

    -- Remove any existing vo toast
    if activeVoToast then
        if activeVoToast.background then
            activeVoToast.background:removeSelf()
        end
        activeVoToast:removeSelf()
        activeVoToast = nil
    end

    -- Position on top of narration field (dialogue box is at contentHeight - 120)
    -- Place it just above the dialogue box
    local yPosition = display.contentHeight - 180

    local toast = display.newText({
        text = message,
        x = display.contentCenterX,
        y = yPosition,
        width = 900,  -- Wide toast for longer text
        font = native.systemFont,
        fontSize = 22,
        align = "center"
    })
    toast:setFillColor(0.6, 0.8, 1)  -- Light blue color for voice-over

    local background = display.newRoundedRect(
        toast.x,
        toast.y,
        toast.width + 40,
        toast.height + 20,
        10
    )
    background:setFillColor(0.2, 0.2, 0.4, 0.9)  -- Dark blue background
    background:toBack()
    toast:toFront()

    -- Store background reference
    toast.background = background
    activeVoToast = toast

    -- Fade in
    toast.alpha = 0
    background.alpha = 0
    transition.to(toast, {alpha = 1, time = 300})
    transition.to(background, {alpha = 1, time = 300})

    -- Fade out and remove after duration
    timer.performWithDelay(duration, function()
        if toast and toast.removeSelf then
            transition.to(toast, {
                alpha = 0,
                time = 500,
                onComplete = function()
                    if activeVoToast == toast then
                        activeVoToast = nil
                    end
                    if toast.removeSelf then
                        toast:removeSelf()
                    end
                end
            })
        end
        if background and background.removeSelf then
            transition.to(background, {
                alpha = 0,
                time = 500,
                onComplete = function()
                    if background.removeSelf then
                        background:removeSelf()
                    end
                end
            })
        end
    end)
end

-- Helper function to show a toast notification
local function showToast(message, duration)
    duration = duration or 3000

    -- Calculate Y position based on number of active toasts
    -- Position toasts above dialogue area (which is at contentHeight - 120)
    -- Start at 250 pixels from bottom to avoid narration field
    local yOffset = 250 + (#activeToasts * 60)  -- Stack toasts 60 pixels apart

    local toast = display.newText({
        text = message,
        x = display.contentCenterX,
        y = display.contentHeight - yOffset,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    toast:setFillColor(1, 1, 1)

    local background = display.newRoundedRect(
        toast.x,
        toast.y,
        toast.width + 40,
        toast.height + 20,
        10
    )
    background:setFillColor(0, 0, 0, 0.8)
    background:toBack()
    toast:toFront()

    -- Store background reference
    toast.background = background

    -- Add to active toasts list
    table.insert(activeToasts, toast)

    -- Fade in
    toast.alpha = 0
    background.alpha = 0
    transition.to(toast, {alpha = 1, time = 200})
    transition.to(background, {alpha = 1, time = 200})

    -- Fade out and remove after duration
    timer.performWithDelay(duration, function()
        transition.to(toast, {
            alpha = 0,
            time = 300,
            onComplete = function()
                -- Remove from active toasts list
                for i = #activeToasts, 1, -1 do
                    if activeToasts[i] == toast then
                        table.remove(activeToasts, i)
                        break
                    end
                end
                toast:removeSelf()
            end
        })
        transition.to(background, {
            alpha = 0,
            time = 300,
            onComplete = function()
                background:removeSelf()
            end
        })
    end)
end

-- Helper function to load audio with error handling
local function loadAudioSafely(soundName, filePath, isStream)
    local success, result = pcall(function()
        if isStream then
            return audio.loadStream(filePath)
        else
            return audio.loadSound(filePath)
        end
    end)

    if success then
        return result
    else
        print("Warning: Failed to load audio file: " .. filePath .. " - " .. tostring(result))
        return nil
    end
end

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

    -- Voice-over text mapping (from dialogue)
    local voTexts = {}

    -- Override initialize to handle audio preloading
    function audioModule.initialize(objects)
        audioModule.sceneObjects = objects

        -- Load audio configuration from model
        local model = require(modelPath)
        audioPaths = model.audio or {}

        -- Build a map of sound types and vo texts from dialogue
        if model.dialogue then
            for _, entry in ipairs(model.dialogue) do
                if entry.sound then
                    soundTypes[entry.sound] = entry.type
                    -- Store vo text for voice-over entries
                    if entry.type == "vo" and entry.text then
                        voTexts[entry.sound] = entry.text
                    end
                end
            end
        end

        -- Preload all audio files
        print(logPrefix .. ": Preloading audio files...")

        for soundName, filePath in pairs(audioPaths) do
            local soundType = soundTypes[soundName] or "sfx"  -- Default to sfx if not found

            -- Use loadStream for music and voice-over, loadSound for SFX
            local isStream = (soundType == "music" or soundType == "vo")
            audioHandles[soundName] = loadAudioSafely(soundName, filePath, isStream)

            if audioHandles[soundName] then
                local loadType = isStream and "stream" or "sound"
                print("  Loaded (" .. loadType .. "): " .. soundName .. " [" .. soundType .. "] -> " .. filePath)
            else
                print("  Skipped (file not found): " .. soundName .. " -> " .. filePath)
            end
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

            -- Show vo text as toast if available
            local soundType = soundTypes[action]
            if soundType == "vo" and voTexts[action] then
                showVoToast(voTexts[action])
            end

            -- Play audio directly using Solar2D audio library
            local success, err = pcall(function()
                audio.play(audioHandles[action], { channel = channel })
            end)

            if success then
                return bt.SUCCESS
            else
                print("Error: Failed to play audio - " .. tostring(err))
                return bt.FAILED
            end
        else
            local fileName = audioPaths[action] or action
            print("Warning: Audio file not loaded for action - " .. tostring(action))

            -- Show vo text as toast even if audio is missing
            local soundType = soundTypes[action]
            if soundType == "vo" and voTexts[action] then
                showVoToast(voTexts[action])
            end

            showToast("Missing audio: " .. fileName)
            return bt.SUCCESS  -- Return success to not block the tree execution
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
