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
      -- {
      --   rect1 = {
      --   }
      -- },
      -- {
      --   rect2 = {
      --     class={ "scroll", }  }
      -- },
      -- {
      --   rect3 = {
      --   }
      -- },
      {
        article = {
          class = {"text"}
        }
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
