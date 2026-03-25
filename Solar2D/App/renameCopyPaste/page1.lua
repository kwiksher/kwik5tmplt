local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        background = {
        }
      },
      {
        name = {
        }
      },
      {
        cat = {
        }
      },
      {
        cat_face1 = {
        }
      },
      {
        title_base = {
        }
      },
      {
        title3 = {
        }
      },
      {
        title2 = {
        }
      },
      {
        title1 = {
          class={ "pulse", }  }
      },
      {
        starfish = {
          class={ "button", }  }
      },
      {
        fish = {
        }
      },
    },
    audios = {
      long={  }, short={   }
    },
    groups = {
      {
        groupCat = {
          class={ "linear", }  }
      },
    },
    timers = {  },
    variables = {  },
    joints    = {  },
    page = {  }
  },
  commands = {   "previousPage",  },
  onInit = function(scene)  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
