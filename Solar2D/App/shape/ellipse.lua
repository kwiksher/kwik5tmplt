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
        ellipse_0 = {
            }
      },
      {
        ellipse_1 = {
            }
      },

    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    joints    = { },
    page = {  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
