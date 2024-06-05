local name = ...
local layersTable = require("editor.group.layersTable")
local util = require("editor.util")
local controller = require("editor.group.controller")
local scripts = require("editor.scripts.commands")
local json = require("json")

local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    UI.editor.currentTool = nil
    local props = controller:useClassEditorProps()
    print(name)
    -- for i, v in next, layersTable.objs do print(i, v.text) end


    local updatedModel = util.createIndexModel(UI.scene.model)
    if props.isNew then
      print("new group")
      local index = params.index or #updatedModel.components.groups + 1
      local newGroup = {name=props.name}
      table.insert(updatedModel.components.groups, index, newGroup)
      print(json.prettify(updatedModel))
    elseif not props.isMove then
    end

    print("properties")
    for i, v in next, props.properties do
      print("", i ,v.name, v.value)
    end

    print("layerTable")
    for k, v in pairs(props.layersTable) do print("", k ,v.text) end
    -- scripts.publish(UI, {
    --   book=UI.editor.currentBook, page=UI.editor.currentPage or UI.page,
    --   updatedModel = updatedModel,
    --   layer = props.name,
    --   class = "group",
    --   props = props},
    --   controller)

  end
)
--
return instance