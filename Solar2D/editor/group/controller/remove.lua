local AC = require("commands.kwik.actionCommand")
local json = require("json")
local controller = require("editor.group.index").controller
local util        = require("editor.util")

--
local useJson = false
--
local command = function (params)
	local UI    = params.UI
  print("--- group.remove ----")

  local props = controller:useClassEditorProps(UI)

  local workMap = {}
  for i, entry in next, props.layersTableSelections do
    print(i, entry.obj.text)
    -- for k, v in pairs(entry) do
    --   print(k, v)
    -- end
    workMap[entry.obj.text] = true
  end

  local newLayersTable = {}
  for i=1, #props.layersTable do
    -- remove them from layersTableSelections
    local value = props.layersTable[i].text
    print(i, value) -- 1, hello

    if workMap[value] == nil then
      newLayersTable[#newLayersTable+1] = value
    end
  end

  --remove them from layersbox
  local filterFunc = function(parent, name)
    -- let's remove entries of tableData from boxData
    --    layers = ["GroupA.Ellipse", "GroupA.SubA.Triangle"]
    for i=1, #newLayersTable do
      local _name = newLayersTable[i]
      -- print("@", _name)
      if parent then
        if parent .."."..name == _name then
          return true
        end
      elseif name == _name then
        return true
      end
    end
    return false
  end
  --
  local boxData = util.read( UI.editor.currentBook, UI.page, filterFunc)

  -- layersbox
  UI.editor.layerJsonStore:set(boxData.layers)
  -- layersTable
  UI.editor.groupLayersStore:set({layers = newLayersTable})

  --
end
--
local instance = AC.new(command)
return instance
