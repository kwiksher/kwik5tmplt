local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("action.delete", params.action)
  if UI.editor.selections then
    for i, obj in next, UI.editor.selections do
      if obj.command then
        print("", obj.index, obj.action)
      else
        if type(obj.action) == "table" then
          print("", obj.index, obj.action.command)
        else
          print("", obj.action)
        end
      end
    end
  end
  --
  local files, targets = {}
  local updatedModel = util.createIndexModel(UI.scene.model)
  local actions = {}
  if params.class == "action" then
    if params.selections then
      for i, v in next, updatedModel.commands do
        print(i, v)
        local isDelete = false
        for ii, vv in next, UI.editor.selections do
          if vv.action == v then
            isDelete = true
            files[#files+1] = "App/"..book.."/commands/"..page.."/"..v..".lua"
            break
          end
        end
        if not isDelete then
          actions[#actions + 1] = v
        end
      end
    end
    updatedModel.commands = actions
  elseif params.class == "actionCommand" then
  end

  -- save index lua
  local indexFile = util.renderIndex(UI.editor.currentBook, page,updatedModel)
  files[#files+1] = indexFile
  -- save index json
  local deleteFile = util.saveIndex(UI.editor.currentBook, page, nil, nil, updatedModel)
  files[#files+1] = deleteFile
  targets[#targets] = deleteFile
  ---
  scripts.backupFiles(files)
  scripts.copyFiles({indexFile})
  scripts.delete(targets)
--
end
--
local instance = AC.new(command)
return instance
