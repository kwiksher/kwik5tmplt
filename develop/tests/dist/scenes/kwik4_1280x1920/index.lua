local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "kwik4_1280x1920",
    layers = {
          {  bg={
                            } },
          {  hello={
                            } },
    },
    components = {  },
    events = {  },
    onInit = function(scene) print("onInit") end
})
--
return scene
