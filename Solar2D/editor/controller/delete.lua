local name = ...
local parent, root = newModule(name)

local types = {"page", "timer", "group", "variables", "layer"}

local instance =
  require("commands.kwik.baseCommand").new(
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

  local files, targets = {}
  local indexModel =  util.createIndexModel(UI.scene.model)
  local updatedModel = scene.model
  -- UI.scene.model
  local namesMap = {}

  local classFolder = UI.editor:getClassFolderName(data.class)
  local book, page, class = UI.book, UI.page, data.class

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
  elseif class then
    entries = indexModel.componets.layers
  else --class==nil
    entries = indexModel.componets.layers
  end

  for i, v in next, entries do
    namesMap[v.name] = i
  end

  for i, v in next, UI.editor.selections do
    local path, entries
    if class == "audio" then
      path = "App."..UI.book..".components."..UI.page..".audios."..v.subclass.."."..v.audio
    elseif class == "group" then
      path = "App."..UI.book..".components."..UI.page..".groups."..v.group
    elseif class == "timer" then
      path = "App."..UI.book..".components."..UI.page..".timers."..v.timer
    elseif class == "variable" then
      path = "App."..UI.book..".components."..UI.page..".variables."..v.variable
    elseif class == "joint" then
      path = "App."..UI.book..".components."..UI.page..".joints."..v.joint
    elseif class == "page" then
    elseif class then
      path = "App."..UI.book..".components."..UI.page..".layers."..v.layer.."_"..v.class
    else --class==nil
      path = "App."..UI.book..".components."..UI.page..".layers."..v.layer
    end

    local name = v[class]
    local index = namesMap[name]
    --
    if index then
      targets[#targets] = {index=index, path = path}
    end
 end
--
  table.sort(targets, function(a,b) return a.index > b.index end)

  local targetsDelete = {}
  for i, v in next, targets do
    if class == nil then
      table.remove(indexModel,v.index)
    else
    end
    files[#files+1] = v.path
    targetsDelete[#targetsDelete + 1] = v.path
  end
  --
  files[#files+1] = indexFile
  --
  scripts.saveSelection(book, page, {{name = "deleted", class= class}})
  scripts.backupFiles(files)
  scripts.copyFiles({indexFile})
  scripts.delete(targetsDelete)

end
)
--
return instance
