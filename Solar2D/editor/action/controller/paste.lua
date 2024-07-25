local AC   = require("commands.kwik.actionCommand")
local util = require("editor.util")
local controller = require("editor.action.controller.index")
local json = require("json")
local scripts = require("editor.scripts.commands")

--
local command = function (params)
	local UI    = params.UI
  print("action.paste at", params.action, params.class)

  local data = UI.editor.clipboard:read()
  -- clipboard.actions = {}
  -- clipboard.actionCommands = {}
  -- --
  local files = {}
  local updatedModel = util.createIndexModel(UI.scene.model)
  local namesMap = {}
  for i, v in next, updatedModel.commands do
      namesMap[v] = i
  end
  ---
  if params.class == "action" then
    if params.selections then
    else
      if #data.actions > 0 then
        for i, contents in next, data.actions do
            local decoded = json.decode(contents)
            local index = namesMap[decoded.name]
            if index then
              decoded.name = decoded.name.."_copied"
            end
            table.insert(updatedModel.commands, decoded.name)
            -- save lua
            files[#files+1] = controller:render(UI.editor.currentBook, UI.page, decoded.name, decoded.actions)
            -- save json
            files[#files+1] = controller:save(UI.editor.currentBook, UI.page, decoded.name, decoded)
        end
      end
      -- save index lua
      files[#files+1] = util.renderIndex(UI.editor.currentBook, UI.page,updatedModel)
      -- save index json
      files[#files+1] = util.saveIndex(UI.editor.currentBook, UI.page, nil, nil, updatedModel)

      scripts.backupFiles(files)
      scripts.copyFiles(files)
    end
  elseif params.class =="actoinCommand" then
  end
--
end
--
local instance = AC.new(command)
return instance
