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
  {
    en = { 
      class={  }  }
  },
   
  {
    ja = { 
      class={  }  }
  },
   
  {
    pt = { 
      class={  }  }
  },
   
  {
    sp = { 
      class={  }  }
  },
   
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
