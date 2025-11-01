-- Action Controller
-- Manages all action modules for the BTree
-- Now uses consolidated action files organized by entities

local M = {}

-- Consolidated action modules registry
local actions = {}

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.loadAllActions()
end

function M.loadAllActions()
    -- Load consolidated action modules
    actions.elara = require("actions.elara_actions")
    actions.wolf = require("actions.wolf_actions")
    actions.cabin = require("actions.cabin_actions")
    actions.lumin_seed = require("actions.lumin_seed_actions")
    actions.audio = require("actions.audio_actions")
    actions.scene = require("actions.scene_actions")
    actions.ui = require("actions.ui_actions")
    actions.focus = require("actions.focus_actions")

    -- Initialize all actions with scene objects
    for name, action in pairs(actions) do
        if action.initialize then
            action.initialize(sceneObjects)
        end
    end

    print("Action Controller: Loaded " .. M.getActionCount() .. " consolidated action modules")
end

function M.getActionCount()
    local count = 0
    for _ in pairs(actions) do
        count = count + 1
    end
    return count
end

function M.execute(actionName)
    -- Parse action name format: "module.action" or legacy single action names
    local moduleName, specificAction = string.match(actionName, "([^.]+)%.(.+)")

    if moduleName and specificAction then
        -- New format: module.action (e.g., "elara.show")
        if actions[moduleName] then
            print("Action Controller: Executing " .. moduleName .. "." .. specificAction)
            return actions[moduleName].execute(specificAction)
        else
            print("Action Controller: Unknown module - " .. moduleName)
            return false
        end
    else
        -- Legacy format: single action name (for backward compatibility)
        -- Map old action names to new consolidated modules
        local actionMap = {
            -- Elara actions
            show_elara = { module = "elara", action = "show" },
            change_elara_to_scared = { module = "elara", action = "change_to_scared" },
            play_elara_voice_line_1 = { module = "elara", action = "play_voice_line_1" },
            play_elara_voice_line_2 = { module = "elara", action = "play_voice_line_2" },

            -- Wolf actions
            show_wolf = { module = "wolf", action = "show" },
            play_wolf_growl = { module = "wolf", action = "play_growl" },

            -- Cabin actions
            show_cabin_interior = { module = "cabin", action = "show_interior" },
            focus_on_cabin = { module = "cabin", action = "focus_on" },

            -- Lumin Seed actions
            show_lumin_seed = { module = "lumin_seed", action = "show" },

            -- Audio actions
            play_rustling_sound = { module = "audio", action = "rustling_sound" },
            play_wind_sound = { module = "audio", action = "wind_sound" },
            play_footsteps_sound = { module = "audio", action = "footsteps_sound" },
            play_crow_caw_sound = { module = "audio", action = "crow_caw_sound" },
            play_tension_music = { module = "audio", action = "tension_music" },

            -- Scene actions
            change_to_forest_scene = { module = "scene", action = "change_to_forest" },
            go_to_fight_scene = { module = "scene", action = "go_to_fight" },
            go_to_calm_scene = { module = "scene", action = "go_to_calm" },
            go_to_retreat_scene = { module = "scene", action = "go_to_retreat" },

            -- UI actions
            show_forest_narration = { module = "ui", action = "show_forest_narration" },
            present_choice_fight = { module = "ui", action = "present_choice_fight" },
            present_choice_calm = { module = "ui", action = "present_choice_calm" },
            present_choice_retreat = { module = "ui", action = "present_choice_retreat" },

            -- Focus actions
            focus_on_wolf = { module = "focus", action = "focus_on_wolf" },
            focus_on_elara = { module = "focus", action = "focus_on_elara" },
            focus_on_cabin = { module = "focus", action = "focus_on_cabin" }
        }

        if actionMap[actionName] then
            local mapping = actionMap[actionName]
            print("Action Controller: Executing legacy action " .. actionName .. " -> " .. mapping.module .. "." .. mapping.action)
            return actions[mapping.module].execute(mapping.action)
        else
            print("Action Controller: Unknown action - " .. actionName)
            return false
        end
    end
end

function M.getAction(actionName)
    return actions[actionName]
end

function M.listActions()
    local actionList = {}

    -- Add new consolidated actions
    for moduleName, module in pairs(actions) do
        if module.ACTIONS then
            for actionName, _ in pairs(module.ACTIONS) do
                table.insert(actionList, moduleName .. "." .. actionName)
            end
        end
    end

    -- Add legacy action names for backward compatibility
    local legacyActions = {
        "show_elara", "change_elara_to_scared", "play_elara_voice_line_1", "play_elara_voice_line_2",
        "show_wolf", "play_wolf_growl", "show_cabin_interior", "focus_on_cabin", "show_lumin_seed",
        "play_rustling_sound", "play_wind_sound", "play_footsteps_sound", "play_crow_caw_sound", "play_tension_music",
        "change_to_forest_scene", "go_to_fight_scene", "go_to_calm_scene", "go_to_retreat_scene",
        "show_forest_narration", "present_choice_fight", "present_choice_calm", "present_choice_retreat",
        "focus_on_wolf", "focus_on_elara", "focus_on_cabin"
    }

    for _, actionName in ipairs(legacyActions) do
        table.insert(actionList, actionName)
    end

    table.sort(actionList)
    return actionList
end

return M