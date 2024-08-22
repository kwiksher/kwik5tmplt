local AC                 = require("commands.kwik.actionCommand")
local util               = require("editor.util")
local controller         = require("editor.action.controller.index")
local actionCommandTable = require("editor.action.actionCommandTable")
local scripts = require("editor.scripts.commands")
local picker             = require("editor.picker.name")
local actionTable        = require("editor.action.actionTable")
--
local command = function (params)
	local UI    = params.UI
  local page = params.page or UI.page
  --local updatedModel = util.createIndexModel(UI.scene.model, "", "")
  local updatedModel = util.createIndexModel(UI.scene.model)
  local nameText     = picker.obj.field.text

  print("action.save", nameText)

  -- if UI.editor.actionEditor.selectbox.selectedObj then
  --   nameText = UI.editor.actionEditor.selectbox.selectedObj.text
  -- end
  -- printTable(UI.editor,currentAction)
  if UI.editor.currentAction.isNew then
    for i, v in next, updatedModel.commands do
      if v == nameText then
        nameText = nameText..math.random()
        break
      end
    end
    table.insert(updatedModel.commands, nameText)
  elseif nameText ~= UI.editor.currentAction.name then
    local updated = {}
    for i, v in next, updatedModel.commands do
      if UI.editor.currentAction.name ~= v then
        updated [#updated+1] = v
      else
        updated [#updated+1] = nameText
      end
    end
    updatedModel.commands = updated
  end

  local currentIndex = UI.editor.currentActionCommandIndex
  local files = {}
  --
  local actions = actionCommandTable.actions

  --for i=1, #actions do print(i, actions[i].command) end

  local newAction = {
    name= nameText,
    actions = actions
  }
  UI.editor.currentAction = newAction

  if actionTable.actionbox then
    --
    newAction.controller = controller
    UI.editor.currentActionForSave = function() return newAction.name, newAction.actions, newAction.controller end
    local partsButtons       = require("editor.parts.buttons")
    local classProps    = require("editor.parts.classProps")
    local actionEditor  = require("editor.action.index")
    actionTable.actionbox:setActiveProp(newAction.name)
    actionEditor:hide()
    partsButtons:show()
    classProps:show()
  else
    -- save index lua
    files[#files+1] = util.renderIndex(UI.editor.currentBook, page,updatedModel)
    -- save index json
    files[#files+1] = util.saveIndex(UI.editor.currentBook, page, nil, nil, updatedModel)
    -- save lua
    files[#files+1] = controller:render(UI.editor.currentBook, page, nameText, actions)
    -- save json
    files[#files+1] = controller:save(UI.editor.currentBook, page, nameText, {name=nameText, actions = actions})
    scripts.backupFiles(files)
    scripts.executeCopyFiles(files)
  end
--
end
--
local instance = AC.new(command)
return instance
