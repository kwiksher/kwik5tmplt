local sceneName = ...
--
local model = {
    name = "page01",
    layers = {sidepanel = {layersList = {}, topbar = {}}, Loading = {}, bg = {}},
    components = {
        audios = {},
        groups = {},
        others = {},
        timers {},
        variables = {}
    },
    events = {},
    onInit = function(scene) print("onInit") end
}

--
local scene = require('components.kwik.scene').new(sceneName, model)

return scene
