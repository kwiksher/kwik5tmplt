local BC          = require("commands.kwik.baseCommand")
local json        = require("json")
local editor      = require("editor.group.index")
local util        = require("editor.util")
--
local command = function (params)
	local UI    = params.UI
  local name =  params.group or ""

  print ("@@@@",params.group, params.class)
  -- print("selectGroup", name, path, params.show)

  --print(debug.traceback())

  local tableData

  UI.editor.currentTool = editor

  if params.isNew then
    --local boxData = util.read( UI.editor.currentBook, UI.page)
    --print(json.encode(boxData))
    --
    tableData = require("editor.template.components.pageX.group.defaults.group")

    UI.editor.groupLayersStore:set(tableData) -- layersTable
    local model = util.createIndexModel(UI.scene.model)
    -- print(json.encode(model))
    UI.editor.layerJsonStore:set(model.components.layers) -- layersbox

  elseif params.isDelete then
    print(params.class, "delete")
  elseif name:len() > 0 then
    --
    -- layersTable (group members)
    -- --
    -- local path = system.pathForFile( "App/"..UI.editor.currentBook.."/models/"..UI.page .."/groups/"..name..".json", system.ResourceDirectory)
    -- tableData, pos, msg = json.decodeFile( path )
    -- if not tableData then
    --   print( "Decode failed at "..tostring(pos)..": "..tostring(msg), path )
    --   tableData = {}
    -- end

    tableData = require("App."..UI.editor.currentBook..".components."..UI.page ..".groups."..name)
    for i, v in next, tableData.members do
      print("", i, v)
    end
    --
    -- layersbox
    --
    local model = util.createIndexModel(UI.scene.model)

    -- let's remove entries of tableData from boxData
    --    members = ["GroupA.Ellipse", "GroupA.SubA.Triangle"]

    local function iterator(entries, parent)
      for i, v in next, entries do
        local parent = nil
        local name = v.name

        local function check(parent, name)
          for i=1, #tableData.members do
            local _name = tableData.members[i]
            if parent then
              if parent .."."..name == _name then
                return true
              end
            elseif name == _name then
              return true
            end
          end
        end
        v.isFiltered = check(parent, name)
        if v.children then
            iterator(v.children, name)
        end
      end
    end

    iterator(model.components.layers)

    -- local boxData = util.read( UI.editor.currentBook, UI.page, function(parent, name)
    --   for i=1, #tableData.layers do
    --     local _name = tableData.layers[i]
    --     if parent then
    --       if parent .."."..name == _name then
    --         return true
    --       end
    --     elseif name == _name then
    --       return true
    --     end
    --   end
    --   return false
    -- end)


    UI.editor.layerJsonStore:set(model.components.layers) -- layersbox
    UI.editor.groupLayersStore:set(tableData) -- layersTable


  end

  editor.controller.classProps:setValue{name="group-2"}
  editor.controller.classProps:destroy(UI)
  editor.controller.classProps:create(UI)
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
