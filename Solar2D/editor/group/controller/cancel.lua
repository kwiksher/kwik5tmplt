local name = ...
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    -- print(name)
    -- print(UI.editor.currentTool.model.id)
    UI.editor.currentTool.controller:hide()
    UI.editor.currentTool = nil

  end
)
--
return instance