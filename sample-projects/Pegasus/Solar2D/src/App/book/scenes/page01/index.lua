local sceneName = ...


--
local scene = require('controller.scene').new(sceneName, {
    name = "page01",
    layers = {{bg = {}}},
    components = {
        audios = {},
        groups = {},
        others = {},
        timers = {},
        variables = {}
    },
    events = {},
    onInit = function(scene) print("onInit") end
})

return scene
