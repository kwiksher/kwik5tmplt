local name = ...
local parent, root = newModule(name)

local listPropsTable = require(root.."listPropsTable")
local listButtons = require(root.."listButtons")
local buttons       = require("editor.parts.buttons")

local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    listButtons:hide()
    listPropsTable:hide()
    buttons:show()
  end
)
--
return instance
