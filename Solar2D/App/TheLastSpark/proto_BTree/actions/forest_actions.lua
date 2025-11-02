-- Action Controller
-- Manages all action modules for the BTree
-- Uses action_helper to create controller

local actionHelper = require("utils.action_helper")

-- Create action controller with module paths and show mapping
return actionHelper.new(
    {
        elara = "actions.forest.elara_actions",
        wolf = "actions.forest.wolf_actions",
        cabin = "actions.forest.cabin_actions",
        lumin_seed = "actions.forest.lumin_seed_actions",
        audio = "actions.forest.audio_actions",
        scene = "actions.forest.scene_actions",
        ui = "actions.forest.ui_actions",
        focus = "actions.forest.focus_actions",
    },
    {
        luminseed = "lumin_seed",
        elara = "elara",
        wolf = "wolf",
    },
    "Action Controller"
)