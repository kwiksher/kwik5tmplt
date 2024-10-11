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
        witch = {     {
          en = {
            class={ "linear", }  }
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

        class={ "lang", }  }
      },
      {
        flyOver = {     {
          en = {
          }
        },
        {
          jp = {
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
        fly = {     {
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
        father = {     {
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
    },
    audios = {
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
