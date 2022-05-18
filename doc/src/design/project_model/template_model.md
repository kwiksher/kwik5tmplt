---
title: "Template Model"
chapter: true
weight: 10
---

### Code Template Model

assets/model/schema

embedded in codes -- TBI to be extracted

* external codes - export it to .lua or can be imported directly
* physics path
* read2me -
    * timecodes
* spritesheet info


TODO:add ext codes

extCodes
    libs
    p1
        user_codes.lua
        ext_001.lua
        ext_002.lua

        commands/
            button_name_001.lua
            action_name_001.lua
            user_codes.lua
    p2/

=> build4/

    ```lua
    function ActionCommand:new()
        local command = {}
        --
        function command:execute(params)
            local UI         = params.UI
            local sceneGroup = UI.scene.view
            local layer      = UI.layer
            local phase     = params.event.phase
            local event     = params.event
            {{#vvar}}
                {{vvar}}
            {{/vvar}}
            {{#arqCode}}
                {{arqCode}}
            {{/arqCode}}
        end
        return command
    end
    ```

    or

    ext_lib_codes.lua
    ```
    local _K = require "Application"
    {{#extLib}}
        local {{name}} = requireKwik("{{libname}}")
    {{/extLib}}
    --
    {{#TV}}
    local kInputDevices = require("extlib.tv.kInputDevices")
    {{/TV}}

    function _M:localVars(UI)
        local sceneGroup  = UI.scene.view
        local layer       = UI.layer
        {{#extCodeTop}}
        {{ccode}}
        {{arqCode}}
        {{/extCodeTop}}
    end
    ```


model.json

```json
{
    "page":1,"alias":"title","isTmplt":false,
    "audios":[null],
    "read2me":[null],
    "videos":[null],
    "PNGs":[null],
    "sprites":[null],
    "particles":[null],
    "WWW":[null],
    "thumbnails":[null],
    "images":[
                 "bg@4x.png", "bg@2x.png", "bg.png",
        null
    ],
    "shared":[
        null
    ]
}
```
```json

{
    "page":{{page}},"alias":"{{alias}}","isTmplt":{{isTmplt}},
    {{#layers}}
        "{{layer}}":{
            "x":{{x}}, "y":{{y}},
            "width":{{width}}, "height":{{height}},
            "alpha":{{alpha}}, "ext":"{{ext}}" },
    {{/layers}}
    "audios":[
        {{#audios}}"{{filename}}",{{/audios}} null],
    "read2me":[
        {{#read2me}}{"foldername":"{{foldername}}", "filenames":[{{#filenames}}"{{.}}",{{/filenames}} null] },{{/read2me}} null],
    "videos":[
        {{#videos}}"{{filename}}",{{/videos}} null],
    "PNGs":[
        {{#PNGs}}"{{foldername}}",{{/PNGs}} null],
    "sprites":[
        {{#sprites}}"{{filename}}",{{/sprites}} null],
    "particles":[
        {{#particles}}{"filename":"{{filename}}","PNG":"{{PNG}}"},{{/particles}} null],
    "WWW":[
        {{#WWW}}{"filename":"{{filename}}","foldername":"{{foldername}}"},{{/WWW}} null],
    "thumbnails":[
        {{#thumbnails}}{{#filenames}}"{{.}}",{{/filenames}} {{/thumbnails}}null],
    "images":[
        {{#images}}
         "{{filename}}@4x.{{filetype}}", "{{filename}}@2x.{{filetype}}", "{{filename}}.{{filetype}}",
        {{/images}}
        null
    ],
    "shared":[
        {{#shared}}
         "{{filename}}@4x.{{filetype}}", "{{filename}}@2x.{{filetype}}", "{{filename}}.{{filetype}}",
        {{/shared}}
        null
    ]
}
```

