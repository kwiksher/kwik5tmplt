local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        bg = {
        }
      },
      {
        rect_0 = {
          class={ "body", }  }
      },
      {
        rect_1 = {
          class={ "body", }  }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    -- joints    = {   },
    joints    = {  "rect_0_rect_1_distance"  },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
