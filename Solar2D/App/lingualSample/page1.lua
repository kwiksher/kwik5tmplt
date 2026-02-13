local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
  --name = "",
  components = {
    layers = {
      {
        kwkcover = {
        }
      },
      {
        kwkwitch = {
        }
      },
      {
        readMe = {     {
          en = {
          }
        },
        {
          ja = {
          }
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
    },
    audios = {
      long={  "Tranquility",  }, short={   }
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
})
--
return scene
