local sceneName = "App.TheLastSpark.cabinScene"
--
local model = {
  name = "cabinScene",
  components = {
    layers = {
      "bg_cabin.png",
      "elara_neutral.png",
      "elara_scared.png",
      "elara_determined.png",
      "elara_happy.png",
      "lumin_seed_normal.png",
      "lumin_seed_glowing.png",
      "lumin_seed_dim.png",
      "lumin_seed_pulsing.png",
      "door_open.png",
      "door_closed.png",
      "door_broken.png",
      "chest_locked.png",
      "chest_unlocked.png",
      "chest_open.png",
      "chest_empty.png"
    },
    audios = {
      long = {},
      short = {
        "door_rattle",
        "door_creak",
        "key_turn",
        "chest_open",
        "door_slam"
      }
    },
    groups = {},
    timers = {},
    variables = {
      "hasKey",
      "hasMagicKey",
      "chestLooted"
    },
    joints = {},
    page = {}
  },
  -- Actions only
  commands = {
    "setHasKey",
  },
  onInit = function(scene)
  end
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene
