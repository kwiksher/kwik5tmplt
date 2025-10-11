local sceneName = "App.TheLastSpark.forestScene"
--
local model = {
  name = "forestScene",
  components = {
    layers = {
      "bg_cabin.png",
      "bg_forest.png",
      "elara_neutral.png",
      "elara_scared.png",
      "elara_determined.png",
      "elara_happy.png",
      "corrupted_wolf_aggro.png",
      "corrupted_wolf_calm.png",
      "item_lumin_seed.png",
      "item_lumin_seed_glowing.png"
    },
    audios = {
      long = {
        "tension"
      },
      short = {
        "rustling",
        "wind",
        "footsteps",
        "caw",
        "growl",
        "vo_elara_01",
        "vo_elara_02"
      }
    },
    groups = {},
    timers = {},
    variables = {},
    joints = {},
    page = {}
  },
  -- Actions only
  commands = {
  },
  onInit = function(scene)
  end
}

local scene = require('controller.scene').new(sceneName, model)
--
return scene
