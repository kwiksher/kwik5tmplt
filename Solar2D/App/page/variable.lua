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
        }
      },
      {
        ellipse_0 = {
        }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  "myvar1",  },
    joints    = {  },
    page = {  }
  },
  commands = {   "varAct",  },
  onInit = function(scene)  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
