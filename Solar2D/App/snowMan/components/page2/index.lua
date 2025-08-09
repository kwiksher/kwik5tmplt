local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        Layer_1 = {
        }
      },
      {
        ground = {
        }
      },
      {
        snowman = {
        }
      },
      {
        hat = {
          class={ "linear", }  }
      },
    },
    audios = {
      long={  }, short={   }
    },
    groups = {
      {
        gp_hat_snowmn = {
          class={ "linear", }  }
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
