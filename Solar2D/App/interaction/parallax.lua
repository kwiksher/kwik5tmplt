local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        background2 = {
             }
      },
      {
        background1 = {
          -- class={ "parallax", }
          }
      },
      {
        cat = {
          class={ "parallax", }  }
      },
      {
        water = {
          class={ "parallax", }  }
      },
      {
        fish = {
          class={ "parallax", }  }
      },
      {
        caption = {
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
