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
        }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    joints    = {  "rect_0_touch",  },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
