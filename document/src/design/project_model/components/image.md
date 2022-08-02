---
title: "Image"
chapter: true
weight: 10
---

### Image

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
