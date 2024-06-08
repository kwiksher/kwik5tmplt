local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    --name = "{{name}}",
    components = {
      layers = {
          {{#layers}}
           {{>recursive}}
           {{/layers}}
          },
      audios = {
        {{#audios}}
          long={ {{#long}} "{{.}}", {{/long}} }, short={ {{#short}}"{{.}}", {{/short}}  }
        {{/audios}}
      },
      groups = {
      {{#groups}}
      {
        {{name}} ={
          class={ {{#class}}"{{.}}",{{/class}} }
        }
      },
      {{/groups}} },
      timers = { {{#timers}} "{{.}}", {{/timers}} },
      variables = { {{#variables}} "{{.}}", {{/variables}} },
      page = { {{#page}}"{{.}}", {{/page}} }
    },
    commands = { {{#events}}  "{{.}}", {{/events}} },
    onInit = function(scene) print("onInit") end
})
--
return scene
