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
          class={ "button", }  }
      },
      {
        N03 = {
          class={ "button", }  }
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
  commands = {   "onN01",   "onOK",   "onClear",   "onN02", "onN03" },
  onInit = function(scene) print("onInit") end
})
--
return scene
