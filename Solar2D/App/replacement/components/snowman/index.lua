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
        tree = {
        }
      },
      {
        tree2 = {
        }
      },
      {
        tree1 = {
          class={ "particles", }  }
      },
      {
        tree3 = {
        }
      },
      {
        tree4 = {
        }
      },
      {
        mytext = {
        }
      },
      {
        ground = {
        }
      },
      {
        snowFlake = {
          class={ "multiplier", }  }
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
