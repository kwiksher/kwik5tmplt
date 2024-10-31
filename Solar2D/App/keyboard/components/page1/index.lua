local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
  --name = "",
  components = {
    layers = {
      {
        Background = {
        }
      },
      {
        textodica = {
        }
      },
      {
        Tip = {
        }
      },
      {
        Win = {
        }
      },
      {
        Computador = {
        }
      },
      {
        Clear = {
        }
      },
      {
        ok = {
        }
      },
      {
        OkDown = {
        }
      },
      {
        N01 = {
        }
      },
      {
        N02 = {
        }
      },
      {
        N03 = {
        }
      },
      {
        Texto = {
        }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  "LED",  },
    joints    = {  },
    page = {  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
})
--
return scene
