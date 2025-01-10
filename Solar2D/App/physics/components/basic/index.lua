local sceneName = ...
--
local model = {
  --name = "",
  components = {
    layers = {
      {
        bg = {
        }
      },
      {
        rect_0 = {
          class={ "body","force", }  }
      },
      {
        ellipse_0 = {
          class={ "body","collision", }  }
      },
    },
    audios = {
    },
    groups = {
      {
        hitGroup = {
        }
      },
    },
    timers = {  },
    variables = {  },
    joints    = {  },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
