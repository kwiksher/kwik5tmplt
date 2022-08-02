---
title: "Audio"
chapter: true
weight: 10
---

### Audio

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
