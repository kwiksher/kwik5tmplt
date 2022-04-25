# workflow

Overview

1. put .png/.jpg into App/contentX/assets/images manually or kwik-export plugin for Ps/XD

    - images without coordinates
    - images with coordinates from Ps, XD with kwik-export plugin
        - models/assets/images/*.json

1. kwik-editor traverses the assets folder to output .json for models and .lua for scenes/pageX and components/pageX

    - kwik-generate-model
    - kwik-generate-index
    - kwik-scaffold-lua

    you can edit props or positions of images or attach a type of class such as animation, button ...

    you can creat an event and a corresponding action of code such as playAnimation, hideLayer, playAudio ...

    > if you manually add a .lua file, you need to update scenes/pageX/index.lua too. You can use kwik-generate-index that traverses pageX folder of commands, components and scenes for synclonizing the lisf of .lua for pageX context defined in the index.lua.

## 1. assets

```
├── App
    ├── contentX
        ├── assets
            ├── audios
            │   ├── sounds
            │   ├── streams
            │   └── sync
            ├── images
            │   └── pageX
            │       ├── bg.png
                    ├── folder
                    |      ├─  .png
                    |      └── .png
                    └── .png

```
### 1-1 images

- Manually put images in App/contentX/images/pageX folder

    - **kwik-generate-model**

        it creates .json under models folder

Alternatively

- Photoshop
    - select .psd files to export
    - **kwik-export plugin**
        -  create folders for a layer group in order to export each image of the group
        - the plugin exports index.json too
            - assets/images/.png
            - models/scenes/pageX/index.json

            ```
            ├── models
            │   ├── assets
            │   │   ├── audios
            │   │   │   ├── sounds
            │   │   │   ├── streams
            │   │   │   └── sync
            │   │   ├── index.json
            │   │   ├── images
            |   |         ├── pageX
            |   |               ├── layerX.json (ReadOnly)
            │   ├── pageX
            │       ├── index.json
            │       └── layers
            │           ├── layerX.json (RW from KwikLiveEditor)
            ```

    later you edit it with KwikLiveEditor, then layerX.json is created under models/pageX/layers folder. images/pageX/layerX.json is readonly.

### 1-2 audios

put audio files under assets/audios folder

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
│   │       ├── pageX_Text1.mp3
│   │       ├── pageX_Text1.txt
│   │       ├── page02_Text1.mp3
│   │       └── page02_Text1.txt
```

- **kwik-generate-model**

    creates .json under models/assets/audios

    ```
    ├── models
    │   ├── assets
    │   │   ├── audios
    │   │   │   ├── sounds
    |   |   |   |     ├── audioX.json
    │   │   │   ├── streams
    │   │   │   └── sync
    │   │   ├── index.json
    │   │   ├── images
    │   ├── pageX
    │       ├── index.json
    ```


- **kwik-editor**

    audio files are not subjected to a page yet. So you can assign an audio to any pages with the tool.

    1. edit audio properties
        - auto play
        - channnel
        - ...

        models/assets/audios/sounds/audioX.json
        ```
        {
            "name":"audioX",
            "autoPlay":false,
            "channel":2,
            "type":"sound"
        }
        ```

    2. you assign an audio entry to a page with kwik-editor. Then the tool adds the entry in models/pageX/index.json

    **pageX**/index.json
    ```
    {
        "components": [
            {
                "audios": [
                    {"name":"audioX", "type":"sound"},
                ]
            }
        ],
        "events": [],
        "layers": []
    }
    ```

# Lua

you don't need to use kwik-generate-model nor kwik-editor to output lua files. You can skip making .json files of these tools, and you create each lua file and edit index.lua for scenes/pageX/ directly.


- commands/pageX/**/*.lua
- components/pageX/**/*.lua
- scenes/pageX/**/*.lua

At runtime, Kwik Code Framework reads scenes/pageX/index.lua to load each .lua files of pageX. The object names for commands, compnents, scenes are defined in the index.lua

- scenes/pageX/index.lua

kwik-genereate-index is a tool to generate the index.lua from traversing the folders above.

1. create .lua for commands, components, layers of pageX,
1. run the tool to generate scenes/pageX/index.lua

> you don't need to use kwik-generate-index tool. You can manually edit it but it would be better to generate the index.lua with the tool.

> Alternatively, there is another tool named **kwik-scaffold-lua**. This tool scafolds .lua files from scenes/pageX/index.lua. The tool does not overwrite .lua if exists, and may delete .lua if not defined in index.lua

Which Workflow do you like?

- A

    use kwik-generate-index everytime after you update commands, components, senes lua files.

- B

    use kwik-scaffold-lua to create a lua for commands, components, scenes then edit the lua file.

> I like A because thinking about files/folders strcure with a file explorer, and coping/pasting an exsiting file could be easier when coding is in progress.

> To initiate a project, B would work quicky to make a skelton structure.
## Image

- scenes/pageX/background.lua

    ```lua
    local _K = require "Application"
    local _M = require("components.kwik.layer_image").new()
    _M.weight = 1

    local Props = {
    blendMode = "normal",
    height    = 520,
    width     = 1000,
    kind      = pixel,
    name      = "bg",
    x         = 1000  -1000/2,
    y         = 520/2,
    alpha     = 100/100,
    }

    --
    _M.imageWidth  = Props.width/4
    _M.imageHeight = Props.height/4
    _M.mX, _M.mY   = _K.ultimatePosition(Props.x, Props.y, "")
    _M.randXStart  = _K.ultimatePosition()
    _M.randXEnd    = _K.ultimatePosition()
    _M.dummy, _M.randYStart = _K.ultimatePosition(0, )
    _M.dummy, _M.randYEnd   = _K.ultimatePosition(0, )
    _M.infinityDistance = (parseValue() or 0)/4

    ....
    ....
    ....
    --
    function _M:localVars(UI)
    end
    --
    function _M:localPos(UI)
    end
    --
    function _M:didShow(UI)
    end
    --
    function _M:toDispose(UI)
    end
    --
    function  _M:toDestory()
    end
    --
    return _M
    ```

    > '_M.weight = num' controlls the order of display objects for  **kwik-genereate-index** tool that outputs scenes/pageX/index.lua

- scenes/pageX/groupOne/index.lua

    ```lua
    _M = {}
    _M.weight = 1
    --
    -- this index.lua is for kwik-generate-model
    -- you may put additional code here
    --
    return _M
    ```

- scenes/pageX/groupOne/imageOne.lua

    ```lua
    local _K = require "Application"
    local _M = require("components.kwik.layer_image").new()
    _M.weight = 1

    local Props = {
        ...
        ....
    }
    ```
- scenes/pageX/groupOne/imageTwo.lua

    ```lua
    local _K = require "Application"
    local _M = require("components.kwik.layer_image").new()
    _M.weight = 2

    local Props = {
        ...
        ....
    }
    ```


- scenes/pageX/index.lua

    > Bottom to Top order

    ```
    {
        name = "pageX",
        layers = {
            {background={}},
            {groupOne = {
                {imageTwo},
                {imageOne},
            }},
        },
        components = {},
        events = {},
    }
    ```

## Audio
- components/pageX/audios

    - sounds/soundOne.lua
    - streams/songOne.lua

    ```.lua
    local Props = {
        name     = "soundOne",
        type     = "sound",
        autoPlay = true,
        channel  = 2
    }
    return Props
    ```

- scenes/pageX/index.lua

    ```
    {
        name = "pageX",
        layers = {
            {background={}},
        },
        components = {
            {audios = {
                {name="soundOne", type="sound"},
                {name="songOne", type="stream"}
            }},
            {others = {
                {nanostores={}}
            }}
        },
        events = {},
    }
    ```

# project structure

sandbox/Ps/react-uxp-styles/Project/Solar2D/src

```
.
├── App
│   ├── contentX
|
├── Images.xcassets
├── LaunchScreen.storyboardc
├── assets
|   └── kwik
├── build.settings
├── commands
│   ├── contentX
│   │   └── pageX
│   │       └── injectedAction.lua
│   ├── app
│   └── kwik
├── components
│   ├── contentX
│   │   └── pageX
│   │       └── injectedLayer.lua
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
    ├── contentX
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

# contentX
sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/contentX

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
│   │       ├── pageX_Text1.mp3
│   │       ├── pageX_Text1.txt
│   │       ├── page02_Text1.mp3
│   │       └── page02_Text1.txt
│   ├── images
│   │   └── pageX
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
│   ├── pageX
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
    └── pageX
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

