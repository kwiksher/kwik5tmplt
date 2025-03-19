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
          class={ "button", }  }
      },
      {
        ellipse_0 = {
        }
      },
    },
    audios = {
      long={  }, short={ "Crickets",   }
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    joints    = {  },
    page = {  }
  },
  commands = {  "eventAudio",  },
  onInit = function(scene)
    --print("onInit")
  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
