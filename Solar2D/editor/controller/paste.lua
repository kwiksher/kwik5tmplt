local name = ...
local parent, root = newModule(name)
local util = require("editor.util")
local scripts = require("editor.scripts.commands")

local instance = require("commands.kwik.baseCommand").new(
function(params)
  local UI = params.UI
   print(name)

  local layer = UI.editor.currentLayer
  local selections = UI.editor.selections or { layer }

  local data = UI.editor.clipboard:read()
  -- clipboard.actions = {}
  -- clipboard.actionCommands = {}
  -- --
  local files = {}
  local indexModel =  util.createIndexModel(UI.scene.model)
  local updatedModel = UI.scene.model
  -- UI.scene.model
  local namesMap = {}

  local classFolder = UI.editor:getClassFolderName(data.class)
  local book, page, class = UI.book, UI.page, data.class
  local isLayerClass = false
  --
  if params.selections then
  else
    local mod, entries, indexEntries
    if class == "audio" then
      mod = require("editor.audio.index")
      entries = data.components.audios
      indexEntries = indexModel.components.audios
    elseif class == "group" then
      mod = require("editor.group.index")
      entries = data.components.groups
      indexEntries =indexModel.components.groups
    elseif class == "timer" then
      mod = require("editor.timer.index")
      entries = data.components.timers
      indexEntries = indexModel.components.timers
    elseif class == "variable" then
      mod = require("editor.variable.index")
      entries = data.components.variables
      indexEntries = indexModel.components.variables
    elseif class == "joint" then
      mod = require("editor.physics.index")
      entries = data.components.joints
      indexEntries = indexModel.components.joints
    elseif class == "page" then
    elseif class then
      mod = UI.editor:getClassModule(class) or {}
      entries = data.components.layers
      indexEntries = indexModel.components.layers
      isLayerClass = #entries == 1
    else --class==nil
      mod = {controller=require("editor.control.index")}
      entries = data.components.layers
      indexEntries = indexModel.components.layers
    end

    local controller = mod.controller

    if not isLayerClass then
      for i, v in next, indexEntries do
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
    else
      print("-- copy a class model to selected layers --")
      local model = entries[1]
      for i, v in next, selections do
        local layer = v.layer
        model.name = "button"
        model.layer = layer
        if model.properties.target then
          model.properties.target = layer
        end
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
    scripts.executeCopyFiles(files)
  end
end)
--
return instance
