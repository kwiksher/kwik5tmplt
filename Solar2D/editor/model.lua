local model = {
  layerTools = {
    {
      name = "Layer",
      icon = "toolPage",
      tools = {
        -- {name = "addPage", icon = "newPage"},
        {name = "Properties", icon = "layerProp"},
        -- {name = "Language", icon = "Lang"},
        {name = "setLanguage", icon = "setLang"}
      },
      id = "layer"
    },
    {
      name = "Replacements",
      icon = "toolLayer",
      tools = {
        {name = "Counter", icon = "repCounter"},
        {name = "DynamicText", icon = "repDyn"},
        {name = "InputText", icon = "repInput"},
        {name = "Map", icon = "repMap"},
        {name = "Mask", icon = "repMask"},
        {name = "Multiplier", icon = "repMultiplier"},
        {name = "Particles", icon = "repParticles", id = "particles"}, -- relacement.particles.index is selected
        {name = "Sprite", icon = "repSprite"},
        {name = "Sync", icon = "repSync"},
        {name = "Text", icon = "repText"},
        {name = "Vector", icon = "repVector"},
        {name = "Video", icon = "repVideo"},
        {name = "Web", icon = "repWeb"}
      },
      id = "replacement"
    },
    {
      name = "Animations",
      icon = "toolAnim",
      tools = {
        {name = "Linear", icon = "animLinear"},
        {name = "Blink", icon = "animBlink"},
        {name = "Bounce", icon = "animBounce"},
        {name = "Pulse", icon = "animPulse"},
        {name = "Rotation", icon = "animRotation"},
        {name = "Shake", icon = "animShake"},
        {name = "Switch", icon = "animSwitch"},
        {name = "Filter", icon = "animFilter"},
        {name = "Path", icon = "animPath"}
      },
      id = "animation"
    },
    {
      name = "Interactions",
      icon = "toolInter",
      tools = {
        {name = "Button", icon = "intButton"},
        {name = "Canvas", icon = "intCanvas"},
        {name = "Drag", icon = "intDrag"},
        {name = "Pinch", icon = "intPinch"},
        {name = "Parallax", icon = "intParallax"},
        {name = "Scroll", icon = "intScroll"},
        {name = "Spin", icon = "intSpin"},
        {name = "Shake", icon = "intShake"},
        {name = "Swipe", icon = "intSwipe"}
      },
      id = "interaction"
    },
    {
      name = "Physics",
      icon = "toolPhysics",
      tools = {
        {name = "Physics", icon = "phyProp"},
        {name = "Body", icon = "phyBody"},
        {name = "Collision", icon = "phyColl"},
        {name = "Force", icon = "phyForce"},
        {name = "Joint", icon = "phyJoint"}
      },
      id = "physics"
    },
    {
      name = "Shapes",
      icon = "",
      tools = {
        {name = "new_rectangle", icon = ""},
        {name = "new_text", icon = ""},
        {name = "new_ellipse", icon = ""},
        {name = "new_image", icon = ""},
      },
      id = "shape"
    },
    {
      name = "Trash",
      icon = "toolTrash",
      tools = {},
      id = "trash",
      command = "delete"
    }
  },
  pageTools = {
    audio = {
      name = "Audio",
      id = "audio"
    },
    group = {
      name = "Group",
      id = "group"
    },
    timer = {
      name = "Timer",
      id = "timer"
    },
    variable = {
      name = "Variable",
      id = "variable"
    },
    -- joint = {
    --   name = "Joint",
    --   id = "joint"
    -- },
  },
  bookTools = {
    book = {
      name = "add Book",
      id = "book"
    },
    properties = {
      name = "Properties",
      icon = "ProjProp",
    }
  },
  assetTool = {
    name = "Assets",
    id = "asset"
  }
}

return model
