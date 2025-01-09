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
        gearL = {
          class={ "body", }  }
      },
      {
        gearR = {
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
         "rect_0_gearL_pivot",
         "rect_0_gearR_pivot",
         "rect_0_rect_1_piston",
         "gearL_gearR_gear",
        "gearR_rect_1_gear",
      },
    page = { "physics",  }
  },
  commands = {  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
