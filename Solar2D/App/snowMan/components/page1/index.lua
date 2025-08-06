local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        Layer_1 = {
        }
      },
      {
        tree = {
        }
      },
      {
        tree2 = {
          class={ "properties", } 
         }
      },
      {
        tree1 = {
           class={ "properties", } 
         }
      },
      {
        tree3 = {
           class={ "properties", } 
         }
      },
      {
        tree4 = {
           class={ "properties", } 
         }
      },
      {
        mytext = {
        }
      },
      {
        ground = {
        }
      },
      {
        snowFlake = {
        }
      },
      {
        snowman = {
        }
      },
      {
        hat = {
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
  onInit = function(scene)  end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
