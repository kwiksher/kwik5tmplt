local M = {}
local json = require("json")
local util = require("lib.util")
local editorUtil = require("editor.util")
local scripts = require("editor.scripts.commands")
local harness = require("server.harness")
local layerTable = require("editor.parts.layerTable")
local controller = require("editor.controller.index")

function M.get(args)
  local ret = nil
  --
  print("args[3]=", args[3])

  local layerTable = require("editor.parts.layerTable")
  for i = 1, #layerTable.objs do
    local obj = layerTable.objs[i]
    if obj.layer == args[3] and obj.class == "" then
      print("####", i, obj.layer)
      harness:selectLayer(args[3])
      --
      local propsTable = require("editor.parts.propsTable")
      ret = {}
      ret.type = "layer"
      ret.props = propsTable:getValue()
      ret.class = {}
      if obj.classEntries then
        for j = 1, #obj.classEntries do
          local classObj = obj.classEntries[j]
          table.insert(ret.class, classObj.class)
        end
      end
      --
      if args[4] ~= nil then
        --look for class
        for j = 1, #obj.classEntries do
          local classObj = obj.classEntries[j]
          print("@@@", classObj.class, j) -- linear
          --local toolName = harness.UI.editor:getTool(classObj.class)
          if classObj.class == args[4] then
            classObj:touch({phase = "ended"}) -- animation
            --
            -- how to fetch animation props
            --
            local tool = harness.UI.editor:getTool(args[4])
            ret.props = tool.controller:useClassEditorProps()
            ret.type = "class"
            break
          end
        end
        -- look for children
        if obj.childEntries and ret.type == "layer" then -- not find a class for arg[4]
          for j = 1, #obj.childEntries do
            local childObj = obj.childEntries[j]
            if childObj.layer == args[4] then
              childObj:touch({phase = "ended"}) -- animation
              --
              -- how to fetch animation props
              ret.type = "layer"
              --
              ret.props = propsTable:getValue()
              --
              -- we need recursively selecting class or child
              --
              ret.class = {}
              for j = 1, #childObj.classEntries do
                local classObj = childObj.classEntries[j]
                table.insert(ret.class, classObj.class)
              end
              break
            end
          end
        end
      end
    end
  end

  -- /bookX/pageX/layerX/classX
  -- /bookX/pageX/layerX/childrenX
  --
  -- layer's children must be handled
  -- {
  --   type = "class", -- "layer"
  --   props = {},
  --   childern = {},
  --   classes = {}
  -- }
  -- ret = {}
  return ret
end
--
local function save (book, page, layer, class, data, index, isNew)
  local tool = harness.UI.editor:getTool(class)
  local decoded = tool.controller:read(book, page, layer, class, isNew)
    --
  local props = decoded[index]
  -- merge with data
  if type(data) == 'table' then
    for k, v in pairs(data) do
      if data[k] then
        props[k] = data[k]
      end
    end
  end
  --
  UI.scene.app:dispatchEvent {
    name = "editor.classEditor.save",
    UI = harness.UI,
    decoded = decoded,
    props = props
  }
end
--
--
-- GUI layerTable must be loaded before using put()
--
function M.put(args, queries)
  local book = args[1]
  local page = args[2]
  local layer = nil -- args[#args]
  local class = queries["class"]
  local obj = layerTable.findObj(layerTable.objs, args, 3)
  if class == nil then
    -- create layer props
    -- isFind?
    if obj == nil then
      layer = args[3]
      for i=4, #args do -- for layer group page1/group1/child1
        layer = layer.."/"..args[i]
      end
      --
      local props = {
        x        = display.contentCenterX,
        y        = display.contentCenterY,
        color    = {r=1, g=1, b=1, a=1},
        text     = layer,
        width    = 128,
        font     = "native.systemFont",
        fontSize = 18,
        align    = "center"  -- Alignment parameter
      }
      --
      local scene = require("App."..book..".components."..page..".index")
      local updatedModel = editorUtil.createIndexModel(scene.model, layer)
      -- TODO weight for ordering layers
      table.insert(updatedModel.components.layers, {name=layer})
      print(json.encode(updatedModel))
      --
      local files = {}
      files[#files + 1] = editorUtil.renderIndex(book, page, updatedModel)
      files[#files + 1] = editorUtil.saveIndex(book, page, layer, class, updatedModel)
      -- layer
      files[#files + 1] = controller:render(book, page, layer, "layers", class, props)
      files[#files + 1] = controller:save(book, page, layer, class, props)
      --
      return scripts.copyFiles(files)
    else
      return nil
    end
  else
    --
    -- attaching class to obj
    --
    if obj == nil then
      return nil
    else
      local index = (layerTable.findClassObj(obj, class) or {}).index or 1
      save(book, page, obj.layer, class, data, index, isNew)
      return props
    end
  end
end
--
M.save = save
--
return M
