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
          class={ "dynamictext", }  }
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
          class={ "button", }  }
      },
      {
        OkDown = {
        }
      },
      {
        ok = {
          class={ "button", }  }
      },
      {
        N01 = {
          class={ "button", }  }
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
          class={ "dynamictext", }  }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  "LED",  "numDica",  },
    joints    = {  },
    page = {  }
  },
  commands = {   "onN01",   "onOK",   "onClear",  },
  onInit = function(scene) print("onInit") end
})
--
return scene
