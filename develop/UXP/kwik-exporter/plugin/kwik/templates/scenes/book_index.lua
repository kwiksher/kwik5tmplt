local sceneName = ...
--
local model = {
    name = "{{name}}",
    layers = {
        {{#layers}}
            {{name}}={
                {{>recursive}}
            },
        {{/layers}}
    },
    components = { {{components}} },
    events = { {{events}} },
    onInit = function(scene) print("onInit") end
}


--
local scene = require('components.kwik.scene').new(sceneName, model)

return scene
