local name = ...
local parent,root = newModule(name)
local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    UI.editor.currentTool:hide()
    local toolbar = require("editor.parts.toolbar")
    toolbar:hideToolMap()
    toolbar.selection = nil
    UI.editor.currentTool = nil
  end
)
--
return instance