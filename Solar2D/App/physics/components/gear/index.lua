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
        rect_1 = {
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
    joints    = {
         "rect_0_ellipse_0_pivot",
         "rect_0_ellipse_1_pivot",
         "rect_0_rect_1_piston",
         "ellipse_0_ellipse_1_gear",
        "ellipse_1_rect_1_gear",
      },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
