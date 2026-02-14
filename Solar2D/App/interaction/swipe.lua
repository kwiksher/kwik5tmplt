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
          class={ "swipe", }  }
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
    variables = {  },
    joints    = {  },
    page = {  }
  },
  commands = {   "swipeAction",  },
  onInit = function(scene) print("onInit") end
}
local scene = require('controller.scene').new(sceneName, model)
--
return scene
