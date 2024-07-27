local name = ...
local parent, root = newModule(name)

local instance = require("commands.kwik.baseCommand").new(
function(params)
  local UI = params.UI
   print(name)

  local data = UI.editor.clipboard:read()
  -- clipboard.actions = {}
  -- clipboard.actionCommands = {}
  -- --
  local files = {}
  local indexModel =  util.createIndexModel(UI.scene.model)
  local updatedModel = scene.model
  -- UI.scene.model
  local namesMap = {}

  local classFolder = UI.editor:getClassFolderName(data.class)
  local book, page, class = UI.book, UI.page, data.class
  local isLayerClass = false
  --
  if params.selections then
  else
    local mod, entries, entriesMap
    if class == "audio" then
      mod = require("editor.audio.index")
      entries = data.components.audios
      entriesMap = indexModel.components.audios
    elseif class == "group" then
      mod = require("editor.group.index")
      entries = data.components.groups
      entriesMap =indexModel.components.groups
    elseif class == "timer" then
      mod = require("editor.timer.index")
      entries = data.components.timers
      entriesMap = indexModel.components.timers
    elseif class == "variable" then
      mod = require("editor.variable.index")
      entries = data.components.variables
      entriesMap = indexModel.components.variables
    elseif class == "joint" then
      mod = require("editor.physics.index")
      entries = data.components.joints
      entriesMap = indexModel.components.joints
    elseif class == "page" then
    elseif class then
      mod = class and UI.editor:getClassModule(class) or {}
      entries = data.componets.layers
      entriesMap = indexModel.componets.layers
      isLayerClass = #indexModel.componets.layers == 1
    else --class==nil
      mod = {controller=require("editor.control.index")}
      entries = data.componets.layers
      entriesMap = indexModel.componets.layers
    end

    if not isLayerClass then
      for i, v in next, entriesMap do
        namesMap[v.name] = i
      end

      for i, model in next, entries do
        local layer = model.name
        local index = namesMap[model.name]
        --
        if index then
          model.name = util.uniqueName(model.name)
        end
        --
        updatedModel = util.updateIndexModel(updatedModel, layer, class)
        -- save lua
        files[#files+1] = controller:render(book, page, layer, classFolder, class, model)
            -- save json
        files[#files+1] = controller:save(book, page, layer, classFolder, model)
      end
    else -- copy a class model to selected layers
      local model = entries[1]
      for i, v in next, UI.editor.selections do
        local layer = v.layer
        updatedModel = util.updateIndexModel(updatedModel, layer, class)
        -- save lua
        files[#files+1] = controller:render(book, page, layer, classFolder, class, model)
            -- save json
        files[#files+1] = controller:save(book, page, layer, classFolder, model)

      end
    end
    local renderdModel = util.createIndexModel(updatedModel)
    -- save index lua
    files[#files+1] = util.renderIndex(book,page,renderdModel)
    -- save index json
    files[#files+1] = util.saveIndex(book,page, nil, nil, renderdModel)

    scripts.saveSelection(book, page, {{name = "pasted", class= class}})
    scripts.backupFiles(files)
    scripts.copyFiles(files)

  end
end)
--
return instance
