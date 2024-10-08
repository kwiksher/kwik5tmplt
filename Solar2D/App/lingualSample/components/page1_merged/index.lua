local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    --name = "page1",
    components = {
      layers = {

             {
               kwkcover = { 
                 class={  }  }
             },
             
             {
               kwkwitch = { 
                 class={  }  }
             },
             
             {
               readMe = { 
                 class={  }  }
             },
             
             {
               Candice = { 
                 class={  }  }
             },
             
             {
               langTxt = { 
                 class={  }  }
             },
                       },
      audios = {
      },
      groups = {  },
      timers = {  },
      variables = {  },
      page = {  }
    },
    commands = {  },
    onInit = function(scene) print("onInit") end
})
--
return scene
