local cabinElara = require("models.cabin.elara")
local cabinDoor = require("models.cabin.cabin_door")
local luminSeed = require("models.cabin.lumin_seed")
local cabinChest = require("models.cabin.chest")

local M = {}

M.dialogue = {
    { type = "narration", text = "You stand before an old cabin in the woods." },
    { type = "show", what = "cabin_door" },
    { type = "object_state", object = "cabin_door", state = "closed" },

    { type = "narration", text = "The door is firmly closed. You try the handle..." },
    { type = "sfx", sound = "door_rattle" },

    { type = "object_state_conditional", object = "cabin_door", state = "open", condition = "hasKey" },
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
    { type = "custom", action = "setHasKey" },
    { type = "sfx", sound = "key_turn" },
    { type = "object_state", object = "chest", state = "unlocked" },
    { type = "sfx", sound = "chest_open" },

    { type = "object_state_conditional", object = "chest", state = "open", condition = "chestNotLooted" },

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

M.audio = {
    door_rattle = "audio/sfx_door_rattle.wav",
    door_creak = "audio/sfx_door_creak.wav",
    key_turn = "audio/sfx_key_turn.wav",
    chest_open = "audio/sfx_chest_open.wav",
    door_slam = "audio/sfx_door_slam.wav",
}

M.objects = {
    elara = cabinElara.create(),
    cabin_door = cabinDoor.create(),
    lumin_seed = luminSeed.create(),
    chest = cabinChest.create(),
}

return M
