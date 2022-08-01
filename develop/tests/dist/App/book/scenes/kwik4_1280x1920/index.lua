local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "kwik4_1280x1920",
    -- layers = {
    --       {  bg={
    --                         } },
    --       {  copyright={
    --                         } },
    --       {  star={
    --                         } },
    --       {  GroupA={
    --             { Ellipse = {  } },{ SubA = { { Triangle = {  } }, } },            } },
    --       {  hello={
    --                         } },
    -- },
    layers = {
      {  GroupA={
            { SubA = { { Triangle = {  } }, } },            } },
    },
components = {
      audios = {  },
      groups = {  },
      timers = {  },
      variables = {  },
      others = {  }
     },
    events = {   "myAction",   "myEvents.testHandler",  },
    onInit = function(scene) print("onInit") end
})
--
return scene
