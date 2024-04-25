local name = ...
local parent, root = newModule(name)
local util         = require("editor.util")
local controller   = require(root.."index").controller
local scripts = require("editor.scripts.commands")
--
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local args = {
      UI            = params.UI,
      book          = params.book or  UI.editor.currentBook,
      page          = params.page or params.UI.page,
      updatedModel  = util.createIndexModel(params.UI.scene.model),
      settings      = params.settings or controller.classProps:getValue(),
      completebox   = params.actionbox or controller.actionbox,
      isNew         = params.isNew
    }
    local selectbox     = params.selectbox or controller.selectbox
    args.selected      =  selectbox.selection or {}
    --
    args.class         = "timer"
    args.name          = args.selected.timer
    args.append        = function(value, index)
        local dst = args.updatedModel.components.timers or {}
        if index then
          dst[index] = value
        else
          dst[#dst + 1] = value
        end
    end

    scripts.publish(UI, args, controller)
   end
)
--[[
components
  ├── timers
  │     ├── timerOne.lua
  │     └── timerTwo.lua
  ├── index.lua

  models
  ├── timers
  │     ├── timerOne.json
  │     └── timerTwo.json

index.json
  {
  "commands": [],
  "name": "page3",
  "pageNum": 3,
  "components": {
    "layers": [
    ],
    "groups": [],
    "page": [],
    "timers": ["timerOne", "timerTwo"]
  }
}

timerOne.json
{
  "name": "timerOne",
  "actionName": "variableAction",
  "delay": 0,
  "iterations": 1
}
]]
--
return instance