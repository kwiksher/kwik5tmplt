local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    --name = "page3",
    components = {
      layers = {

             {
               kwkcover = { 
                 class={  }  }
             },
             
             {
               roof = { 
                 class={  }  }
             },
             
             {
               cat = { 
                 class={  }  }
             },
             
             {
               kwikTxt = { 
                 class={  }  }
             },
             
             {
               catTxt = { 
                 class={  }  }
             },
                       },
      audios = {
      },
      groups = {
      },
      timers = {  },
      variables = {  },
      joints    = {  },
      page = {  }
    },
    commands = {  },
    onInit = function(scene) print("onInit") end
})
--
return scene
