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
    args.class         = "variable"
    args.name          = args.selected.variable
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
  ├── variables
  │     ├── varOne.lua
  │     └── varTwo.lua
  ├── index.lua

  models
  ├── variables
  │     ├── varOne.json
  │     └── varTwo.json

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
    "variables": ["varOne", "varTwo"]
  }
}

varOne.json
{
  "_type": "false",
  "_name": "newVar",
  "value": "",
  "isSave": "",
  "isAfter": "true",
  "isLocal": "true"
}
]]
--
return instance