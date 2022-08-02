local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "iPhoneX_1125x2436",
    layers = {
          {  Artboard_1={
                            } },
    },
    components = {
      audios = {  },
      groups = {  },
      timers = {  },
      variables = {  },
      others = {  }
     },
    events = {  },
    onInit = function(scene) print("onInit") end
})
--
return scene
