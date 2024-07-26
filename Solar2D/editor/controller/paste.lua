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
  local updatedModel = UI.scene.model
  local namesMap = {}

  local classFolder = UI.editor:getClassFolderName(data.class)
  local book, page, class = UI.book, UI.page, data.class

  if params.selections then
  else
    local mod, entries
    if class == "audio" then
      mod = require("editor.audio.index")
      entries = data.components.audios
    elseif class == "group" then
      mod = require("editor.group.index")
      entries = data.components.groups
    elseif class == "timer" then
      mod = require("editor.timer.index")
      entries = data.components.timers
    elseif class == "variable" then
      mod = require("editor.variable.index")
    elseif class == "joint" then
      mod = require("editor.physics.index")
      entries = data.components.joints
    elseif class == "page" then
    elseif class then
      mod = class and UI.editor:getClassModule(class) or {}
      entries = data.componets.layers
    else --class==nil
      mode = {controller=require("editor.control.index")}
      entries = data.componets.layers
    end


    for i, model in next, entries do
      local layer = model.name
      --
      -- TODO if name is duplicated, add "_copied"
      --
      updatedModel = util.updateIndexModel(updatedModel, layer, class)
      -- save lua
      files[#files+1] = controller:render(book, page, layer, classFolder, class, model)
          -- save json
      files[#files+1] = controller:save(book, page, layer, classFolder, model)
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
