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
          class={ "dynamictext", }  }
      },
      {
        ellipse_0 = {
        }
      },
    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  "myVar",  },
    joints    = {  },
    page = {  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
