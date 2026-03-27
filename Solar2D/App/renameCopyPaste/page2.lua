local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    components = {
      layers = {
        { background = {} },
        { name = {} },
        { cat = {} },
        { cat_face1 = {} },
        { title_base = {} },
        { title3 = {} },
        { title2 = {} },
        { title1 = {} },
        { starfish = {} },
        { fish = {} },
      },
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
