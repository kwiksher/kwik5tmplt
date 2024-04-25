local AC                 = require("commands.kwik.actionCommand")
local util               = require("editor.util")
local controller         = require("editor.action.controller.index")
local actionCommandTable = require("editor.action.actionCommandTable")
local scripts = require("editor.scripts.commands")
--
local command = function (params)
	local UI    = params.UI
  local page = params.page or UI.page
  print("action.save")
  --local updatedModel = util.createIndexModel(UI.scene.model, "", "")
  local updatedModel = util.createIndexModel(UI.scene.model)
  local nameText     = UI.editor.actionEditor.selectbox.selectedObj.text
  local currentIndex = UI.editor.currentActionCommandIndex
  local files = {}
  --
  local actions = actionCommandTable.actions
  for i=1, #actions do print(i, actions[i].command) end
  local newAction = {
    name= nameText,
    actions = actions
  }
  UI.editor.currentAction = newAction
  -- save index lua
  files[#files+1] = util.renderIndex(UI.editor.currentBook, page,updatedModel)
  -- save index json
  files[#files+1] = util.saveIndex(UI.editor.currentBook, page, nil, nil, updatedModel)
  -- save lua
  files[#files+1] = controller:render(UI.editor.currentBook, page, nameText, actions)
  -- save json
  files[#files+1] = controller:save(UI.editor.currentBook, page, nameText, {name=nameText, actions = actions})

  scripts.copyFiles(files)
--
end
--
local instance = AC.new(command)
return instance