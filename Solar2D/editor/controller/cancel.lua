local name = ...
local parent,root = newModule(name)

local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    UI.editor.currentTool:hide()
    local toolbar = require("editor.parts.toolbar")
    toolbar:hideToolMap()
  end
)
--
return instance