local name = ...
local tool      = require("editor.group.index")

local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    -- print(name)
    -- print(UI.editor.currentTool.model.id)
    tool.controller:hide()
    UI.editor.focusGroup:removeSelf()
    UI.editor.currentTool = nil

  end
)
--
return instance