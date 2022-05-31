local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "{{name}}",
    layers = {
        {{#layers}}
          {  {{name}}={
                {{>recursive}}
            } },
        {{/layers}}
    },
    components = { {{components}} },
    events = { {{events}} },
    onInit = function(scene) print("onInit") end
})
--
return scene
