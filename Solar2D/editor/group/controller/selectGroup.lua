local BC          = require("commands.kwik.baseCommand")
local json        = require("json")
local editor      = require("editor.group.index")
local util        = require("editor.util")
--
local command = function (params)
	local UI    = params.UI
  local name =  params.group or ""

  -- print (params.class)
  -- print("selectGroup", name, path, params.show)

  --print(debug.traceback())

  local tableData

  UI.editor.currentTool = editor

  if params.isNew then
    local boxData = util.read( UI.editor.currentBook, UI.page)
    --
    tableData = {
      name = "(new-group)",
      layers = {},
      children = {},
      alpha =  nil,
      xScale =  nil,
      yScale =  nil,
      rotation =  nil,
      isLuaTable = nll
    }

    UI.editor.groupLayersStore:set(tableData) -- layersTable
    UI.editor.layerJsonStore:set(boxData.layers) -- layersbox

  elseif params.isDelete then
    print(params.class, "delete")
  elseif name:len() > 0 then
    --
    -- layersTable
    --
    local path = system.pathForFile( "App/"..UI.editor.currentBook.."/models/"..UI.page .."/groups/"..name..".json", system.ResourceDirectory)
    tableData, pos, msg = json.decodeFile( path )
    if not tableData then
      print( "Decode failed at "..tostring(pos)..": "..tostring(msg), path )
      tableData = {}
    end
    --
    -- layersbox
    --
    local boxData = util.read( UI.editor.currentBook, UI.page, function(parent, name)
      -- let's remove entries of tableData from boxData
      --    layers = ["GroupA.Ellipse", "GroupA.SubA.Triangle"]
      for i=1, #tableData.layers do
        local _name = tableData.layers[i]
        if parent then
          if parent .."."..name == _name then
            return true
          end
        elseif name == _name then
          return true
        end
      end
      return false
    end)

    UI.editor.layerJsonStore:set(boxData.layers) -- layersbox
    UI.editor.groupLayersStore:set(tableData) -- layersTable

  end

  --
  editor:show()
  --
  UI.editor.editPropsLabel = name
  --
  UI.editor.rootGroup:dispatchEvent{name="labelStore",
    currentBook= UI.editor.currentBook,
    currentPage= UI.page,
    currentLayer = name}
--
end
--
local instance = BC.new(command)
return instance
