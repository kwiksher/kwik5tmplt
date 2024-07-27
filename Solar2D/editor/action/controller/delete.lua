local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  local book = UI.editor.currentBook
  local page = UI.page
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
            local path =  "App/"..book.."/commands/"..page.."/"..v..".lua"
            files[#files+1] = path
            targets[#targets+1] = path
            break
          end
        end
        if not isDelete then
          actions[#actions + 1] = v
        end
      end
    end
    updatedModel.commands = actions
    -- save index lua
    local indexFile = util.renderIndex(book, page,updatedModel)
    files[#files+1] = indexFile
    -- save index json
    local indexJson = util.saveIndex(book, page, nil, nil, updatedModel)
    files[#files+1] = indexJson

    scripts.saveSelection(book, page, {{name = "action deleted", class= class}})
    scripts.backupFiles(files)
    scripts.copyFiles({indexFile})
    scripts.delete(targets)
  elseif params.class == "actionCommand" then
    local name = UI.editor.currentAction.name
    local model = require("App."..book..".commands."..page.."."..name).model
    local actions = json.decode(model.actions)
    table.sort(UI.editor.selections, function(a,b) return a.index > b.index end)
    for i, v in next, UI.editor.selections do
      table.remove(model.actions, v.index)
    end

    scripts.saveSelection(book, page, {{name = "actionCommand deleted", acion= name}})

    files[#files+1] = controller:render(book, page, name, actions)
    -- save json
    files[#files+1] = controller:save(book, page, name, {name=name, actions = actions})

    scripts.backupFiles(files)
    scripts.copyFiles({indexFile})

  end
  ---
--
end
--
local instance = AC.new(command)
return instance
