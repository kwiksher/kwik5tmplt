local sceneName = ...
--
local scene = require('controller.scene').new(sceneName, {
    name = "kwik4_1280x1920",
    layers = {
          {  GroupA={
                { Ellipse = {  } },{ SubA = { {Triangle ={}} } },            } },
          {  bg={
                            } },
          {  copyright={
                            } },
          {  star={
                            } },
          {  hello={
                            } },
          {  mycircle={
                            } },
          {  myrect={
                            } },
    },
    components = {
      audios = {  },
      groups = {  },
      timers = {  },
      variables = {  },
      others = {  }
     },
    events = { "myAction","myEvents.testHandler" },
    onInit = function(scene) print("onInit") end
})
--
return scene
