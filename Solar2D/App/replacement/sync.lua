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
        ABC = {
          class={ "sync", }  }
      },
    },
    audios = {
      long={  }, short={   }
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    joints    = {  },
    page = {  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
