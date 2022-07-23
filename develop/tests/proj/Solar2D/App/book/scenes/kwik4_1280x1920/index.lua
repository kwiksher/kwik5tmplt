local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "kwik4_1280x1920",
    layers = {
          {  weight={
                            } },
          {  bg={
                            } },
          {  weight={
                            } },
          {  hello={
                            } },
          {  bg={
                            } },
          {  hello={
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
