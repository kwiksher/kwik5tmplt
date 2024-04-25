local name = ...
local parent, root = newModule(name)
local listPropsTable = require(root.."listPropsTable")
local listbox = require(root.."listbox")
local listButtons = require(root.."listButtons")
local buttons       = require("editor.parts.buttons")
local json = require("json")
--
local instance =
  require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    local type = listPropsTable.model.type
    print(name, params.index)
    local ret = listPropsTable:getValue()
    print (type, json.encode(ret))
    -- update
    print ("@@", json.encode(listbox.value[params.index]))
    listbox.value[params.index] = ret
    listbox:destroy()
    listbox:setValue()
    listButtons:hide()
    listPropsTable:hide()
    buttons:show()

  end
)
--
return instance
