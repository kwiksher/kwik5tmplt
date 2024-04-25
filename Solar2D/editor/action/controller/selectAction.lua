local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
local App = require("controller.Application")

--
local command = function (params)
	local UI         = params.UI
  local decoded, pas, msg
  if params.isNew then
    decoded = {name="", actions={}}
  else
    local path =system.pathForFile( "App/"..App.get().name.."/models/"..UI.page.."/commands/"..params.action..".json", system.ResourceDirectory)
    -- print(path)
    decoded, pos, msg = json.decodeFile( path )
    if not decoded then
      print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
      return
    end
    UI.editor.actionEditor.selectbox:updateValue(decoded.name)
  end
  UI.editor.currentAction  = decoded
  --
  -- if UI.editor.actionEditor.isVisible then
  --   UI.editor.actionEditor:hide()
  -- else
    UI.editor.actionEditor:show()
    --UI.editor.editPropsLabel = UI.editor.currentAction.name
    UI.editor.actionCommandStore:set(decoded)
  -- end
  --
end
--
local instance = AC.new(command)
return instance
