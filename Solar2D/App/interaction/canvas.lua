local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        back = {
        }
      },
      {
        painting = {
        }
      },
      {
        butBlue = {
        }
      },
      {
        butWhite = {
        }
      },
      {
        butOrange = {
        }
      },
      {
        butCamera = {
        }
      },
      {
        butLarge = {
        }
      },
      {
        butMedium = {
        }
      },
      {
        bigCandice = {
          class={ "canvas", }  }
      },
      {
        twitter = {
        }
      },
      {
        facebook = {
        }
      },
      {
        LogoutBtn = {
        }
      },
      {
        Logout = {
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
