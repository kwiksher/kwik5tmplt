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
          class={ "body", }  }
      },
      {
        ellipse_0 = {
          class={ "body", }  }
      },
      {
        ellipse_1 = {
          class={ "body", }  }
      },

    },
    audios = {
    },
    groups = {
    },
    timers = {  },
    variables = {  },
    joints    = {  "rect_0_ellipse_0_wheel","rect_0_ellipse_1_wheel"  },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
