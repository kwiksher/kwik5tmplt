local cabinElara = require("models.cabin.elara")
local cabinDoor = require("models.cabin.cabin_door")
local cabinLuminSeed = require("models.cabin.lumin_seed")
local cabinChest = require("models.cabin.chest")
local ironKey = require("models.cabin.iron_key")
local brassKey = require("models.cabin.brass_key")
local looseFloorboard = require("models.cabin.loose_floorboard")

local M = {}

M.dialogue = {
    { type = "narration", text = "You stand before an old cabin in the woods." },
    { type = "show", what = "elara" },
    { type = "show", what = "cabin_door" },
    { type = "narration", text = "The door is firmly closed. You try the handle..." },
    { type = "sfx", sound = "door_rattle" },
    { type = "sfx", sound = "door_creak" },
    { type = "narration", text = "The door creaks open, revealing a dark interior." },
    { type = "scene", background = "cabin_interior" },
    { type = "music", sound = "ambient_cabin", action = "play", loop = true },
    { type = "show", what = "lumin_seed" },
    { type = "emotion", character = "elara", state = "happy" },
    { type = "vo", sound = "vo_elara_seed_found", text = "The Lumin Seed... I found it." },
    { type = "show", what = "chest" },
    { type = "sfx", sound = "lock_click" },
    { type = "sfx", sound = "chest_creak" },
    { type = "vo", sound = "vo_elara_need_key", text = "There has to be a key somewhere around here..." },
    { type = "narration", text = "The chest is empty! Someone got here first." },
    { type = "emotion", character = "elara", state = "shocked" },
    { type = "vo", sound = "vo_elara_shock_01", text = "No... it can't be!" },
    { type = "vo", sound = "vo_elara_shock_02", text = "Someone got here first." },
    { type = "sfx", sound = "door_slam" },
    { type = "sfx", sound = "shake" },
    { type = "music", sound = "tension", action = "play" },
    { type = "emotion", character = "elara", state = "panicking" },
    { type = "vo", sound = "vo_elara_panic", text = "What?! No!" },
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
    lock_click = "audio/sfx_lock_click.wav",
    chest_creak = "audio/sfx_chest_creak.wav",
    door_slam = "audio/sfx_door_slam.wav",
    shake = "audio/sfx_shake.wav",
    vo_elara_seed_found = "audio/elara_vo_seed_found.wav",
    vo_elara_need_key = "audio/elara_vo_need_key.wav",
    vo_elara_shock_01 = "audio/elara_vo_shock_01.wav",
    vo_elara_shock_02 = "audio/elara_vo_shock_02.wav",
    vo_elara_panic = "audio/elara_vo_panic.wav",
    ambient_cabin = "audio/Music_Ambient_Cabin.mp3",
    tension = "audio/Music_Tension_Builds.mp3"
}

M.objects = {
    elara = cabinElara.create(),
    cabin_door = cabinDoor.create(),
    lumin_seed = cabinLuminSeed.create(),
    chest = cabinChest.create(),
    iron_key = ironKey.create(),
    brass_key = brassKey.create(),
    loose_floorboard = looseFloorboard.create(),
}

return M
