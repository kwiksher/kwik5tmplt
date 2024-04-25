local name = ...
local parent,root = newModule(name)
local shape = require("editor.shape.index")
local util = require("lib.util")
---
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    local options = params.options
    local options = params.props.options
    --
    local selection = UI.editor.selections[1]
    -- for k, v in pairs(selection) do print(k, v) end
    local obj = util.getLayer(UI, selection.layer)
    if obj then
      print(name, obj.name)
      shape.rotate(UI, obj)
    end
    --
  end
)
--
return instance