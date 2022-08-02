---
title: "Workflow"
chapter: true
weight: 10
---

## Workflow

Overview

1. put .png/.jpg into App/contentX/assets/images manually or use kwik-export plugin for Ps/XD to publish images to App folder

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
