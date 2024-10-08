local sceneName = ...
--
local scene =
  require("controller.scene").new(
  sceneName,
  {
    --name = "page2",
    components = {
      layers = {
        {
          kwkcover = {
            class = {}
          }
        },
        {
          witch = {
            {
              en = {
                class = {}
              }
            },
            {
              ja = {
                class = {}
              }
            },
            {
              pt = {
                class = {}
              }
            },
            {
              sp = {
                class = {}
              }
            },
            class = {"lang"}
          }
        },
        {
          flyOver = {
            {
              en = {
                class = {}
              }
            },
            {
              jp = {
                class = {}
              }
            },
            {
              pt = {
                class = {}
              }
            },
            {
              sp = {
                class = {}
              }
            },
            class = {}
          }
        },
        {
          fly = {
            {
              en = {
                class = {}
              }
            },
            {
              ja = {
                class = {}
              }
            },
            {
              pt = {
                class = {}
              }
            },
            {
              sp = {
                class = {}
              }
            },
            class = {}
          }
        },
        {
          father = {
            {
              en = {
                class = {}
              }
            },
            {
              ja = {
                class = {}
              }
            },
            {
              pt = {
                class = {}
              }
            },
            {
              sp = {
                class = {}
              }
            },
            class = {}
          }
        }
      },
      audios = {},
      groups = {},
      timers = {},
      variables = {},
      joints = {},
      page = {}
    },
    commands = {},
    onInit = function(scene)
      print("onInit")
    end
  }
)
--
return scene
