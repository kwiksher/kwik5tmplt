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
        article = {
          class={ "text","scroll", }  }
      },
    },
    audios = {
      long={  }, short={   }
    },
    groups = {
      {
        group0 = {
        }
      },
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
