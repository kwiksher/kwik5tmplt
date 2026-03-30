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
        snowman = {
        }
      },
      {
        hat = {
        }
      },
    },
    audios = {
    },
    groups = {
      {
        group_1 = {
        }
      },
    },
    timers = {  },
    variables = {  },
    joints    = {  },
    page = {  }
  },
  commands = {  },
  onInit = function(scene)  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
