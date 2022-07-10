---
title: "Tools"
chapter: true
weight: 10
---

## Tools

Exporrter plugin for PS, XD

  - UXP

    - export images
    - export source code
      1. traverse photoshop layers

          scenes/pageX/**/*.lua 

          > kwik-exporter\src\photoshop\publishCode.ts

      1. traverse App/contentX/
         - commands/pageX/ for envets
         - components/pageX for components such as audios,groups ..
         - scenes/pageX for layers from Photoshop and attached animation, button
      
          > generate_scene_index\generate_models.lua

      1. merge the both results to ouput scenes/pageX/index.lua ⭐️


          ```lua
          local sceneName = ...
          --
          local scene = require('controller.scene').new(sceneName, {
              name = "page01",
              layers = {{bg = {}}, {layerX = {types={button}}}},
              components = {
                  audios = {},
                  groups = {},
                  others = {},
                  timers = {},
                  variables = {}
              },
              events = {"bg.clickLayer"},
              onInit = function(scene) print("onInit") end
          })

          return scene
          ```

  - develop/UXP/kwik-exporter
     
     A layer set is exported as one single image if assets/images/pageX has the foler with the same name of the layer set.
    
    - export images

    - export props
      -  output .json/.lua

      develop\UXP\kwik-exporter\plugin\kwik\templates\components\
      
      - layer_image.json
      - layer_image.lua

      (TODO) Update develop\Solar2D\template to sync with the two files.

      (TODO) UXP/plugin/kwik/template is a clone of template/App/contentX

  ```
  ├─Solar2D
  │  ├─robotlegs
  │  │  ├─App
  │  │  │  ├─book
  │  │  │  │  ├─assets
  │  │  │  │  │  ├─images
  │  │  │  │  │  │  └─page01
  │  │  │  │  ├─models
  │  │  │  │  │  └─page01
  │  │  │  │  │      └─layers
  │  │  │  │  └─scenes
  │  │  │  │      └─page01
  │  ├─template
  │  │  ├─App
  │  │  │  └─contentX
  │  │  │      ├─assets
  │  │  │      ├─commands
  │  │  │      │  └─pageX
  │  │  │      ├─components
  │  │  │      │  ├─pageX
  │  │  │      │  │  ├─audios
  │  │  │      │  │  ├─groups
  │  │  │      │  │  ├─interactions
  │  │  │      │  │  │  └─page
  │  │  │      │  │  ├─others
  │  │  │      │  │  │  ├─ext_lib_codes
  │  │  │      │  │  │  ├─page
  │  │  │      │  │  │  └─store
  │  │  │      │  │  ├─timers
  │  │  │      │  │  └─variables
  │  │  │      │  └─store
  │  │  │      ├─models
  │  │  │      │  └─pageX
  │  │  │      │      ├─events
  │  │  │      │      └─layers
  │  │  │      └─scenes
  │  │  │          └─pageX
  │  │  │              ├─animations
  │  │  │              ├─images
  │  │  │              ├─interactions
  │  │  │              ├─physics
  │  │  │              └─replacements
  │  │  │                  ├─particles
  │  │  │                  ├─sprites
  │  │  │                  ├─syncAudioText
  │  │  │                  ├─videos
  │  │  │                  └─www
  │  └─tools
  │      ├─kwik-editor
  └─UXP
      └─kwik-exporter
          ├─plugin
          │  ├─icons
          │  └─kwik
          │      ├─templates
          │      │  ├─components
          │      │  │  └─kwik
          │      │  ├─model
          │      │  │  ├─components
          │      │  │  ├─events
          │      │  │  └─layers
          │      │  └─scenes

  ```


Editor

  - Web App (React)

    {{TBI}}

  - Solar2D Desktop App

  - /develop/Solar2D/tools/kwik-editor

REST Server

  - receives Props and Commands and then renders .lua/.json

    /develop/Solar2D/tools/pegasus-harness
  
    /develop/Solar2D/tools/pegasus-launcher


Utilities

  - generating scene/pageX/index.lua
  
    the table in the index.lua is created by interating files in App/bookX/components and bookX/commands
  
  - scafolding (optional)
  
    it outputs .lua files to components and commands folder by reading scene/pageX/index.lua
  
    /develop/Solar2D/tools/generate_scene_index