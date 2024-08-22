local name = ...
local parent, root = newModule(name)
local util = require("editor.util")
local scripts = require("editor.scripts.commands")

local types = {"page", "timer", "group", "variables", "layer"}

local instance =require("commands.kwik.baseCommand").new(
  function(params)
    local UI = params.UI
    print(name)
    if UI.editor.selections then
      for i, obj in next, UI.editor.selections do
        if obj.page then
          print("", obj.page)
        elseif obj.layer then
          print("", obj.layer, obj.class)
        end
      end
    end

    local book = UI.book
    local page = UI.page

    local selections = UI.editor.selections or {UI.editor.currentLayer}
    --
    local files, targets = {}, {}
    local indexModel =  util.createIndexModel(UI.scene.model)
    local updatedModel = UI.scene.model
    -- UI.scene.model
    local namesMap = {}

    --local classFolder = UI.editor:getClassFolderName(data.class)
    local book, page = UI.book, UI.page

    if class == "audio" then
      entries = indexModel.components.audios
    elseif class == "group" then
      entries =indexModel.components.groups
    elseif class == "timer" then
      entries = indexModel.components.timers
    elseif class == "variable" then
      entries = indexModel.components.variables
    elseif class == "joint" then
      entries = indexModel.components.joints
    elseif class == "page" then
      -- TODO
    else
      entries = indexModel.components.layers
    end

    for i, v in next, entries do
      namesMap[v.name] = i
    end

    for i, v in next, selections do
      local class = params.class or v.class
      local name
      local path, entries
      if class == "audio" then
        path = "App/"..book.."/components/"..page.."/audios/"..v.subclass.."."..v.audio
        name = v.subclass.."."..v.audio
      elseif class == "group" then
        path = "App/"..book.."/components/"..page.."/groups/"..v.group
        name = v.group
      elseif class == "timer" then
        path = "App/"..book.."/components/"..page.."/timers/"..v.timer
        name = v.timer
      elseif class == "variable" then
        path = "App/"..book.."/components/"..page.."/variables/"..v.variable
        name = v.variable
      elseif class == "joint" then
        path = "App/"..book.."/components/"..page.."/joints/"..v.joint
        name = v.joint
      elseif class == "page" then
      elseif class then
        path = "App/"..book.."/components/"..page.."/layers/"..v.layer.."_"..v.class
        name = v.layer
      else --class==nil
        path = "App/"..book.."/components/"..page.."/layers/"..v.layer
        name = v.layer
      end

      local index = namesMap[name]
      -- print(name)
      -- printTable(namesMap)
      --
      if index then
        targets[#targets+1] = {index=index, path = path, class = class}
      end
    end
    --
    table.sort(targets, function(a,b) return a.index > b.index end)

    local targetsDelete = {}
    for i, v in next, targets do
      if v.class == nil then
        -- table.remove(indexModel,v.index) -- delete from index
      elseif v.class == "audio" then
      elseif v.class == "group" then
      elseif v.class == "timer" then
      elseif v.class == "variable" then
      elseif v.class == "joint" then
      else
        local updated = {}
        for ii, vv in next, entries[v.index].class do
          if vv ~=v.class then
            updated[#updated + 1] = vv
          end
        end
        entries[v.index].class = updated
      end
      files[#files+1] = v.path
      targetsDelete[#targetsDelete + 1] = v.path
    end
    --
    scripts.saveSelection(book, page, {{name = "deleted", class= class}})
    --
    local indexFile =  util.renderIndex(book,page, indexModel)
    files[#files+1] = indexFile
    --
    scripts.backupFiles(files)
    scripts.executeCopyFiles({indexFile})
    scripts.delete(targetsDelete)
  end)
--
return instance
