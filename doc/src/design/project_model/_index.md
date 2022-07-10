---
title: "Project Model"
chapter: true
weight: 10
---

## project Model

sandbox/Ps/react-uxp-styles/Project/Solar2D/src

```
.
├── App
│   ├── contentX // See Content X Structure
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
