local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        kwkcover = {
        }
      },
      {
        kwkwitch = {
          class={ "button", }  }
      },
      {
        kwkmask = {
        }
      },
      {
        readMe = {     {
          en = {
            class={ "button", }  }
        },
        {
          ja = {
            class={ "button", }  }
        },
        {
          pt = {
          }
        },
        {
          sp = {
          }
        },

        }
      },
      {
        Candice = {
        }
      },
      {
        langTxt = {
        }
      },
      {
        over = {
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
  commands = {   "actEn",   "actJp",   "actWitch",  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
