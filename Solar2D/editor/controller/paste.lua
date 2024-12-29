local name = ...
local parent, root = newModule(name)
local util = require("editor.util")
local scripts = require("editor.scripts.commands")
local json = require("json")

local instance = require("commands.kwik.baseCommand").new(
function(params)
  local UI = params.UI
  --  print(name)

  local layer = UI.editor.currentLayer
  local selections = UI.editor.selections or { layer }

  local data = UI.editor.clipboard:read()
  -- clipboard.actions = {}
  -- clipboard.actionCommands = {}
  -- --

  -- print(json.prettify(data))

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
  elseif class == "page" then
    -- print("paste page")
    local src = "App/" .. book .. "/index.lua"
    scripts.backupFiles(src)
    scripts.copyPage(book, page, page.."_copied") -- _dst == Solar2D
  else
    local mod, entries, indexEntries
    if class == "audio" then
      mod = require("editor.audio.index")
      entries = data.components.audios
      indexEntries = indexModel.components.audios
    elseif data.type == "group" then
      mod = require("editor.group.index")
      entries = data.components.groups
      indexEntries =indexModel.components.groups
      if class and class:len() > 0 then
        isLayerClass = true
      end
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
      -- print(json.prettify(indexEntries))
      for i, v in next, indexEntries do
        namesMap[v.name] = i
      end

      for i, model in next, entries do
        -- local layer = model.name
        local index = namesMap[model.name]
        --
        if index and (data.class == nil or data.class:len() ==0) then
          model.name = util.uniqueName(model.name)
          layer = model.name
          if data.type == "group" then
            local entry = {}
            entry[layer] = {}
            table.insert(updatedModel.components.groups, entry)
          elseif data.type == "timer" then
            table.insert(updatedModel.components.timers, layer)
          elseif data.type == "variable" then
            table.insert(updatedModel.components.variables, layer)
          elseif data.type == "joint" then
            table.insert(updatedModel.components.joints, layer)
          end
        end

        if data.type == "group" then
          model.type = "group"
          classFolder = "group"
          if class and class:len() > 0 then
            classFolder = UI.editor:getClassFolderName(data.class)
            --
            -- pasting a buton class of animations or interactions
            --

          end
        end
        --
        -- print ("@@@", layer, class)
        -- print(json.prettify(model))

        updatedModel = util.updateIndexModel(updatedModel, layer, class, model.type)
        -- save lua
        files[#files+1] = controller:render(book, page, layer, classFolder, class, model)
            -- save json
        files[#files+1] = controller:save(book, page, layer, classFolder, model)
      end
    else
      -- print("-- copy a class model to selected layers or groups --")
      local model = entries[1]
      for i, v in next, selections do
        local layer = v.layer
        model.name = layer
        model.layer = layer
        if model.properties.target then
          model.properties.target = layer
        end
        if data.type == "group" then
          -- classFolder = "group"
          model.type  = "group" -- is a linear/button copied from a normal layer instead of a group?
        end
        -- print ("@@@", layer, class, data,type)
        -- print(json.prettify(model))

        updatedModel = util.updateIndexModel(updatedModel, layer, class, data.type) -- data.type for group
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
