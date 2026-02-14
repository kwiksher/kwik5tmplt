local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    components = {
      layers = { { background={} } },
      audios = { },
      groups = { },
      timers = { },
      variables = { },
      page = { }
    },
    commands = { },
    onInit = function(scene) print("onInit") end
})
--
return scene
