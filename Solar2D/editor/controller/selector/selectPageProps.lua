local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
local App = require("controller.Application")
--
local useJson = false
local propsButtons = require("editor.parts.propsButtons")
local settingsTable = require("editor.parts.settingsTable")

--
local command = function (params)
	local UI    = params.UI
  local path = system.pathForFile( "App/"..UI.editor.currentBook.."/models/settings.json", system.ResourceDirectory)
  print("selectPageProps", params.icon, params.isNew, params.isDelete, path)

  local rootGroup = UI.editor.rootGroup
  if params.icon == "newPage-icon" then --params.isNew == true
    print("new page")
  elseif params.isDelete then
    print("delete page")
  elseif params.show~=nil and rootGroup.settingsTable then
    if settingsTable.isVisible then
      settingsTable:hide()
    else
      settingsTable:show()
    end
  else
    UI.editor.editPropsLabel = "Settings"
    local decoded, pos, msg = json.decodeFile( path )
    if not decoded then
      print( "Decode failed at "..tostring(pos)..": "..tostring(msg), path )
    elseif (params.class =="animation") then
      print( "animation is decoded!" )
      --UI.editor.propsStore:set(decoded)
    else
      print( "props is decoded!" )
      settingsTable:didHide(UI)
      settingsTable:destroy(UI)
      settingsTable:init(UI)
      --
      settingsTable:setValue(decoded)
      settingsTable:create(UI)
      settingsTable:didShow(UI)
      settingsTable:show()
      --
      propsButtons:show()
      UI.useClassEditorProps = settingsTable.useClassEditorProps
    end
    --
    --
    UI.editor.rootGroup:dispatchEvent{name="labelStore",
      currentBook= UI.editor.currentBook,
      currentPage= "Settings",
      currentLayer = ""}
  end
--
end
--
local instance = AC.new(command)
return instance
