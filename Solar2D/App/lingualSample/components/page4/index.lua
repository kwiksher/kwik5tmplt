local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    --name = "page4",
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
               namekwik = {
  {
    en = {
      class={  }  }
  },

  {
    ja = {
      class={  }  }
  },

                 class={  }  }
             },

             {
               iamcat = {
  {
    en = {
      class={  }  }
  },

  {
    ja = {
      class={  }  }
  },

                 class={  }  }
             },

             {
               cat = {
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
