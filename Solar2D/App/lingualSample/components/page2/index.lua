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

        class={ "lang", }  }
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

        class={ "lang", }  }
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
  commands = {   "flyAnim",  },
  onInit = function(scene) print("onInit") end
})
--
return scene
