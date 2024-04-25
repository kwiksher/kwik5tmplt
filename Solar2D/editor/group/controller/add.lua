local AC = require("commands.kwik.actionCommand")
local json = require("json")
local App = require("Application")

local util        = require("editor.util")
local controller = require("editor.group.index").controller
--
local useJson = false
--
local command = function (params)
	local UI    = params.UI
  print("----- group.add ----")

  local props = controller:useClassEditorProps(UI)
  for k, v in pairs(props) do print("", k, v) end

  local workTable = {}
  for i=1, #props.layersboxSelections do
    -- add them to layersTable
    local obj = props.layersboxSelections[i]
    if obj.parentObj then
      print("#", util.getParent(obj))
      local parentText = util.getParent(obj):gsub("/",".") --  "- GroupA.Ellipse"
      workTable[#workTable + 1] = parentText ..obj.text
    else
      workTable[#workTable + 1] = obj.text
    end
  end

  local newLayersTable = {}
  for i=1, #props.layersTable do
    -- remove them from layersTableSelections
    local value = props.layersTable[i].text
    print(i, value) -- 1, hello
    newLayersTable[#newLayersTable+1] = value
  end

  for i, v in next, workTable do
    newLayersTable[#newLayersTable + 1] = v
  end

  --remove them from layersbox
  local filterFunc = function(parent, name)
    -- let's remove entries of tableData from boxData
    --    layers = ["GroupA.Ellipse", "GroupA.SubA.Triangle"]
    --print(#workTable)
    for i=1, #workTable do
      local _name = workTable[i]
      if parent then
        if parent .."."..name == _name then
          return true
        end
        print("@", parent, name, _name)
      elseif name == _name then
        print("@", name, _name)
        return true
      end
    end
    return false
  end
  --
  local boxData = util.read( UI.editor.currentBook, UI.page, filterFunc)


  UI.editor.layerJsonStore:set(boxData.layers) -- layersbox

  for i=1, #boxData.layers do
    print(i, boxData.layers[i].name, boxData.layers[i].isFiltered)
  end

  UI.editor.groupLayersStore:set({layers = newLayersTable}) -- layersTable

--
end
--
local instance = AC.new(command)
return instance
