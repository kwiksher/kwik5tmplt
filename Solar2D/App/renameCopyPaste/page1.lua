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
          class={ "dynamictext", }  }
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
          class={ "properties","button", }  }
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
    timers = {  "nameTimer",  },
    variables = {  "myText",  },
    joints    = {  },
    page = {  }
  },
  commands = {   "nameAct",   "previousPage",  },
  onInit = function(scene)  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
