local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("editor.util")

local name = ...
local parent = name:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

local actionCommandButtons = require(root.."actionCommandButtons")
local buttons = require(root.."buttons")
local commandbox = require(root.."commandbox")
local commandModel = require(root.."model").commands
local selectors = require("editor.parts.selectors")
--
local command = function (params)
	local UI    = params.UI

  local commandClass = params.commandClass
  UI.editor.currentActionCommandIndex = params.index

  local type = ""
  local entries = {}
  local model = {}
  local index = params.index  or 1

  print("selectActionCommand", commandClass)

  local Layer = table:mySet { "animation", "image", "button" }

  if Layer[commandClass] then
      selectors:selectComponent("Layer")
  elseif commandClass == "audio" then
    selectors:selectComponent("Audio")
  elseif commandClass == "group" then
    selectors:selectComponent("Group")
  elseif commandClass == "timer" then
    selectors:selectComponent("Timer")
  elseif commandClass == "variables" or commandClass == "conditions" then
    selectors:selectComponent("Var")
  elseif commandClass == "action" then
    selectors:selectComponent("Action")
  end

  if params.isNew then
    type = commandClass
    --
    for k, v in pairs(commandModel[commandClass]) do
      model[#model+1] = {name=k, params=v}
    end
    --
    local function compare(a,b)
      return a.name < b.name
    end
    --
    table.sort(model,compare)
    --
    commandbox:setValue(UI, commandClass, model, index)
    --
    for k, v in pairs(model[index].params) do
      -- print("", k, v)
      local prop = {name=k, value=v}
      entries[#entries+1] = prop
    end
    -- commandbox.group.y = display.actualContentHeight- #entries * 20 -40
    --
  else
    print("",  UI.page.."/commands/"..UI.editor.currentAction.name..".json", UI.editor.currentActionCommandIndex)
    for k, v in pairs(commandClass) do print("###",k, v) end
    --
    local out = util.split(commandClass.command, '.')
    type = out[1]
    commandbox:setValue(UI, out[2])
    --commandbox.selectedObj.text  = out[2]

    for k, v in pairs(commandClass.params) do
      -- print("", k, v)
      local prop = {name=k, value=v}
      entries[#entries+1] = prop
    end
  end

  commandbox:setPosition(entries, model)

  UI.editor.actionCommandPropsStore:set{type = type, entries=entries, isNew = params.isNew}

  buttons:hide()
  commandbox:show()
  actionCommandButtons:show()

end
--
local instance = AC.new(command)
return instance
