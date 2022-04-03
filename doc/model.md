# project structure

sandbox/Ps/react-uxp-styles/Project/Solar2D/src

```
.
├── App
│   ├── album01
|
├── Images.xcassets
├── LaunchScreen.storyboardc
├── assets
|   └── kwik
├── build.settings
├── commands
│   ├── album01
│   │   └── page01
│   │       └── handmadeAction.lua
│   ├── app
│   └── kwik
├── components
│   ├── album01
│   │   └── page01
│   │       └── handmadeCommand.lua
│   ├── tiledmap
│   ├── crossword
│   └── store
│   └── kwik
├── config.lua
├── controller
│   ├── Application.lua
│   ├── contexts
|   |     ├── ApplicationContext.lua
|   |     ├── ApplicationMediator.lua
|   |     ├── ApplicationUI.lua
|   |     ├── componentEventHandler.lua
|   |     ├── mediator.lua
|   |     ├── scene.lua
|   |     └── sceneEventHandler.lua
│   ├── mediators
│   └── index.lua ⭐️
├── en.lproj
├── extlib
├── jp.lproj
└── main.lua  ⭐️
```

> main.lua in App/bookXXX is removed. src/controller handles to load an App context
# templates

```
├── App
    ├── albumX
        ├── assets
        │   ├── audios
        │   │   ├── sounds
        │   │   ├── streams
        │   │   └── sync
        │   ├── images
        │   └── model.json
        ├── commands
        │   └── pageX
        ├── components
        │   ├── pageX
        │   │   ├── audios
        │   │   ├── groups
        │   │   ├── interactions
        │   │   │   └── page
        │   │   ├── others
        │   │   ├── timers
        │   │   └── variables
        │   └── store?
        ├── defaults
        │   ├── audio_properties.xml
        │   ├── layer_properties.xml
        │   ├── linear_anim_properties.xml
        │   └── spritesheet_properties.xml
        ├── mediators
        ├── models
        │   ├── assets
        │   │   ├── audios
        │   │   │   ├── sounds
        │   │   │   ├── streams
        │   │   │   └── sync
        │   │   ├── index.json
        │   │   ├── particles
        │   │   ├── sprites
        │   │   ├── videos
        │   │   └── www
        │   ├── lproj
        │   └── pageX
        │       ├── components
        │       │   ├── audios
        │       │   ├── groups
        │       │   ├── others
        │       │   ├── timers
        │       │   └── variables
        │       ├── events
        │       ├── index.json
        │       └── layers
        ├── scenes
            └── pageX
                ├── animations
                ├── images
                ├── interactions
                ├── physics
                └── replacements

```

# alubmn01
sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/album01

```
.
├── assets
│   ├── audios
│   │   ├── sounds
│   │   │   └── ballsCollide.mp3
│   │   ├── streams
│   │   │   ├── Gentle-Rain.mp3
│   │   │   └── Tranquility.mp3
│   │   └── sync
│   │       ├── en
│   │       │   ├── cat.mp3
│   │       │   ├── kwik.mp3
│   │       │   └── narration.mp3
│   │       ├── jp
│   │       │   ├── cat.mp3
│   │       │   ├── kwik.mp3
│   │       │   └── narration.mp3
│   │       ├── page01_Text1.mp3
│   │       ├── page01_Text1.txt
│   │       ├── page02_Text1.mp3
│   │       └── page02_Text1.txt
│   ├── images
│   │   └── page01
│   │       ├── Loading.png
│   │       ├── Loading@2x.png
│   │       ├── Loading@4x.png
│   │       ├── bg.png
│   │       ├── bg@2x.png
│   │       ├── bg@4x.png
│   │       └── sidepanel
│   │           ├── layersList.png
│   │           ├── layersList@2x.png
│   │           ├── layersList@4x.png
│   │           ├── topbar.png
│   │           ├── topbar@2x.png
│   │           └── topbar@4x.png
│   ├── kwik
│   │   ├── kAudio.png
│   │   ├── kAudioHi.png
│   │   ├── shutter.mp3
│   │   └── thumbnails
│   ├── particles
│   │   ├── kaboom_393.json
│   │   └── kaboom_393.png
│   ├── sprites
│   │   └── butflysprite.png
│   ├── videos
│   │   └── kwikplanet.mp4
│   └── www
├── components
│   └── pag01
│       ├── audios
│       ├── groups
│       ├── others
│       │   ├── page_IAP.lua
│       │   ├── page_ads.lua
│       │   ├── page_ext_lib_code.lua
│       │   ├── page_navigation.lua
│       │   ├── page_parallax.lua
│       │   └── page_shake.lua
│       ├── timers
│       └── variables
├── models
│   ├── assets
│   │   ├── audios
│   │   │   ├── sounds
│   │   │   ├── streams
│   │   │   └── sync
│   │   ├── index.json
│   │   ├── particles
│   │   ├── sprites
│   │   ├── videos
│   │   └── www
│   ├── page01
│       ├── components
│       │   └── audios
│       ├── events
│       │   └── doDistanceModel.json
│       ├── index.json
│       └── layers
│           ├── Loading.json
│           ├── Loading_animation.json
│           ├── Loading_button.json
│           ├── Loading_properties.json
│           ├── bg.json
│           └── sidepanel
│               ├── layersList.json
│               └── topbar.json
└── scenes
    └── page01
        ├── Loading.lua
        ├── Loading_animation.lua
        ├── Loading_button.lua
        ├── bg.lua
        ├── index.lua
        └── sidepanel
            ├── index.lua
            ├── layersList.lua
            └── topbar.lua

```

# solar2D playground in kwik

* In XD css and icons for vue
* localization

---
Solar2D

* iOS
* macOS
* tvOS
* Android Google, Amazon
* Windows
* HTML5

---
Kwik

```
_k    -> app
UI    -> data ???
layer -> layerList
```




* Command
    * File
        * Project New
        * Project Open
        * Project Recent
        * Page    New
    * Edit
        * Paste/Copy components
        * Delete
            * pages
            * components
    * Publish
        * Compress PNGs -- TBI notarized compress.app in Kwik
        * Assemble PNGs
            * A-Gif or A-PNG
        * Publish
            * Images
            * One page or Selected pages
            * Open Solar2D simulator
            * options
                * Enable child components -- TBI as layerSet as a group or independent option
                * Debug
                    * show memory
                    * (trace/print control)
                * Spritsheet @2x

    * Importer for a Kwik3 project

* License
    * Perpetual or Subscription
    * Activate
    * Transfer
    * Proxy Settings

* Template -- TBI as auto update from kwiksher.com and store it as global
    * Copy global to local for customization

* Auto update - TBI
    * notarization and store updater.app in kwik5

* Language
    * English or Japanese

---
Samples

* Afraid (Get Started)
* Actions
* Animations
* Canvas
* Multi Lingual
* Layer Replacements
* Physics
* Project And Pages

----
Structure

* Project Properties
    * Icon
    * Splash screen
    * Letter/ZoomEven/ZoomStretch
    * Navigation Thumbnail
    * Auto Bookmark
    * Admob
    * (Rating)
    * IAP
        * simple unlock
        * bookshelf
    * Bookshelf
        * pages
        * template
        * embedded
            * normal or versions
    * Languages -- TBI as State in kwik5, global
    * Upate Template

* Extended
    * Normal or Component
    * Page Properties
        * Context -- load the page images using the context page
        * Scale
        * Enable page swipe
        * Show in navigation
        * Loading option
            * Preload
            * Template -- bookshelf template page
            * Comic    -- enable comic rendering for  -panels, balloons, background
            * Alias    -- bookshelf: the page alias for a master template page
        * IAP Unlock
        * Show Ad
        * Record screen
    * Page components
        * Audios
            * Audio
                * global or local
        * Groups
            * Group
                * Change order
                * Hide a group
            *  Simple Camera Frame
            * Set
                * Group with
                * Audio with
                * Variable with
            * Common
                * Hide
                * Simple Responsive
                * Random Position
                * Scale
                * Infinity Scroll
        * States local
            * State
        * Actions
            * Action
        * Timers
            * Timers
        * Variables
            * Variable
                * global or local
                * keep track
        * Physics
            * Environment
            * (Joints)
            * (Collisions)
        * External codes -- global, local, self,  ace editor?
            * libraries
            * codes
                * onInit
                * onCreate
                * onShow
                * onHide

    * Layer Properties
        * Common
            * Hide
            * Simple Responsive
            * Random Position
            * Scale
            * Export
                * as Jpeg
                * save as Shared Asset
            * Render as
            * Infinity Scroll
            * Set
                * Group with
                * Audio with
                * Variable with
            * States
                * Gloabl
                * Local
                * Object
            * Extenal Code - self

        * Set Language -- TBI as State function gloal, local, object
        * Animation
            * Linear
            * Path
            * Switch Image to
            * Rotation
            * Pulse
            * Bounce
            * Blink
            * Shake
            * Filter
        * Replacements
            * Spritesheet
                * Simple
                * Texture Packer
                * Adobe Animate
                * (Spine)
            * Sync Text Audio
                * (Lip Sync - Spine and Papagayo)
            * Video
                * normal or PNGs
            * Web
            * Vector
            * Map
            * Multiplier
            * Particles
                * Importer
                * Editor
            * Text
                * Dynamic
                * Static
                * Input
            * Countdown
            * Mask
        * Interactions
            * Button
            * Drag
            * Swipe
            * Pinch
            * Spin
            * Shake
            * Scroll
            * Parallax (Accelerometer)
            * Canvas
            * (Snapeshot Eraser)
            * (Push -  OneSignal)
        * Physics
            * Body
            * Set Force
            * Set Joint with
            * Set Collision with
----

----
Solar2D API to be included

* Audio
    * seek
    * rewind
    * cross fade function

* Social
    * twitter
    * facebook
    * instagram

* transition.*
    * chaining them

* mesh
* 2.5D — Perspective and Depth

* game controllers


-----
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

