local forestElara = require("models.forest.elara")
local forestWolf = require("models.forest.wolf")
local forestLuminSeed = require("models.forest.lumin_seed")

local M = {}

M.dialogue = {
    { type = "narration", text = "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light." },
    { type = "show", what = "lumin_seed" },
    { type = "show", what = "elara" },
    { type = "sfx", sound = "rustling" },
    { type = "sfx", sound = "wind", loop = true },
    { type = "vo", sound = "vo_elara_01", text = "The Lumin Seed was the last one. The last spark of the Great Tree's light..." },
    { type = "scene", background = "forest" },
    { type = "sfx", sound = "footsteps", loop = true },
    { type = "sfx", sound = "caw" },
    { type = "narration", text = "The forest is unnervingly quiet. No birdsong, no rustle of creatures." },
    { type = "sfx", sound = "growl" },
    { type = "show", what = "wolf" },
    { type = "music", sound = "tension", action = "play" },
    { type = "emotion", character = "elara", state = "scared" },
    { type = "vo", sound = "vo_elara_02", text = "Oh no." },
    { type = "choice", options = {
        "Fight it!",
        "Try to calm it.",
        "Run back to the cabin!"
    }}
}

M.audio = {
    rustling = "audio/sfx_rustling_cloth.wav",
    wind = "audio/sfx_wind_gentle.wav",
    footsteps = "audio/sfx_footsteps_forest.wav",
    caw = "audio/sfx_crow_caw_distant.wav",
    growl = "audio/sfx_wolf_growl_corrupted.wav",
    vo_elara_01 = "audio/elara_vo_01.wav",
    vo_elara_02 = "audio/elara_whisper_ohno.wav",
    tension = "audio/Music_Tension_Builds.mp3"
}

M.objects = {
    elara = forestElara.create(),
    wolf = forestWolf.create(),
    lumin_seed = forestLuminSeed.create(),
}

return M
