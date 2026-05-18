local M = require("Test.base_suite").new()

local helper = require("Test.helper")

local muiName = "action.commandView-"


-- function M.test_component()
--     selectors.projectPageSelector:show()
-- end

function M.xtest_new_action()
  helper.selectComponent("actionTable")
  helper.clickButton("create", M.actionButtons)
end

function M.xtest_select_action()
  M.UI.testCallback = function()
    --
    M.UI.editor.actionEditor.iconHander()

    M.actionTable.altDown = true
    helper.selectAction("previousPage")
    M.actionTable.altDown = false
  end
end

function M.xtest_select_actionCommand()
  M.UI.testCallback = function()
    --
    M.UI.editor.actionEditor.iconHander()

    M.actionTable.altDown = true
    helper.selectAction("previousPage")
    M.actionTable.altDown = false

   --- select a command
   local commandsTable = require("editor.action.actionCommandTable")
   if commandsTable.objs then
    print("commandsTable.objs", #commandsTable.objs)
    local obj = commandsTable.objs[1]
    commandsTable:singleClickEvent(obj)
   else
    print("not found a actionCommand")
   end
  end
end

function M.test_copy_paste_action()
  M.UI.testCallback = function()
    --
    M.UI.editor.actionEditor.iconHander()
    -- M.actionTable.altDown = true
    -- helper.selectAction("previousPage")
    -- M.actionTable.altDown = false
  end

  -- copy action
  -- paste in actionTable, an action is selected
  --
  -- result previoousPage_copied
  --
end

function M.xtest_copy_paste_actionCommand()
  M.UI.testCallback = function()
    --
    M.UI.editor.actionEditor.iconHander()

    M.actionTable.altDown = true
    helper.selectAction("previousPage")
    M.actionTable.altDown = false

   --- select a command
   local commandsTable = require("editor.action.actionCommandTable")
   if commandsTable.objs then
    print("commandsTable.objs", #commandsTable.objs)
    local obj = commandsTable.objs[1]
    commandsTable:singleClickEvent(obj, {showContextMenu = true})
   else
    print("not found a actionCommand")
   end

    -- copy actionCommand
    -- paste in actionCommandTable, an acitonCommand is selected
    --
    -- result another duplicated actionCommand
    --
  end
end

function M.xtest_select_multi_actions()
  -- UI.testCallback = function()
  --
  M.UI.editor.actionEditor.iconHander()
  M.actionTable.controlDown = true
  helper.selectAction("previousPage")
  helper.selectAction("nameAct")
  M.actionTable.controlDown = false
  -- end

  local buttons = require("editor.action.buttons")
  buttons.objs.cancel.tap{eventName="delete"}
end

function M.xtest_select_multi_actionCommands()
  -- UI.testCallback = function()
  --
  M.UI.editor.actionEditor.iconHander()
  helper.selectAction("previousPage")
  -- end

  local buttons = require("editor.action.actionCommandButtons")
  buttons.objs.cancel.tap{eventName="delete"}

end


function M.xtest_selectAction()
  assert(truee, "show selected action name and set a focus (text color) in selector")
end

function M.xtest_save()
  --just save eventOne
end

function M.xtest_cancel()
  -- 1. cancel to close it
end

function M.xtest_commandEditorShow()
  -- show
  -- 1.0 click an command entry in commands Table
  -- 1.1 open commandEditor with the command
  -- 1.2 cancel to close it
  local editor = require("editor.action.actionCommandTable")
  timer.performWithDelay(1000, function()
    for k, v in pairs(editor) do print(k, v) end
    local obj = M.actionTable.objs[1]
    editor.singleClickEvent(obj)
    --
    local buttons = require("editor.action.buttons")
    buttons.objs["cancel"].tap{eventName="cancel"}
  end)
  --
end

function M.xtest_modifyActionCommnad()
  -- click UI.editor.actionIcon
  --  it dispatches
    M.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = "act01",
      UI = M.UI
    }
   --- select a command
   local commandsTable = require("editor.action.actionCommandTable")
   local obj = commandsTable.objs[1]
    commandsTable.singleClickEvent(obj)

    -- select a layer
    -- local propsTable = require("editor.action.actionCommandPropsTable")
    -- local linkbox = propsTable.linkbox
    -- local obj = linkbox.objs[1]
    -- obj:tap({numTaps = 1})

   -- save command props
      -- UI.scene.app:dispatchEvent {
      --   name = "editor.actionCommand.save",
      --   UI = UI,
      -- }

end

function M.xtest_newActionButton()
  local editor = require("editor.action.index")

  helper.selectComponent("actionTable")
  if M.actionButtons and M.actionButtons.objs then
    helper.clickButton("create", M.actionButtons)
  elseif M.actionTable and M.actionTable.newButton then
    M.actionTable.newButton:tap{target=M.actionTable.newButton}
  end

  if editor.selectbox and editor.selectbox.objs and editor.selectbox.objs[1] then
    editor.selectbox.selectedObj = editor.selectbox.objs[1]
    editor.selectbox.selectedObj.field.text = "act01"
    editor.selectbox:textListener(nil, {phase = "ended"})
  end

  helper.selectActionCommand("animation", "play")

  helper.clickProp(M.actionCommandPropsTable.objs, "_target")
  helper.selectLayer("cat", "linear")

  helper.clickButton("save", M.actionCommandButtons)
end

function M.xtest_newActionAnimation()
  -- click UI.editor.actionIcon
  --  it dispatches
    M.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      isNew = true, -- isNew?
      UI = M.UI
    }
    -- action name
    local editor = require("editor.action.index")
    editor.selectbox.selectedObj = editor.selectbox.objs[1]
    editor.selectbox.selectedObj.field.text = "act01"
    editor.selectbox:textListener(nil, {phase = "ended"})
    -- select animation
    M.UI.scene.app:dispatchEvent {
      name = "editor.action.selectActionCommand",
      UI = M.UI,
      value = "animation", -- obj.model.commandClass
      isNew = true
    }
    --
    --
    -- should we add it to actionCommandTable?
    --
    -- select animation > play
    local obj = M.commandbox.objs[2]
    obj:tap({numTaps = 1})

      -- save command props
      M.UI.scene.app:dispatchEvent {
        name = "editor.actionCommand.save",
        UI = M.UI,
        page = "page1"
      }
    --
    --
    -- TODO actionCommand.save
    --   close the command props
    --   add the command to the table
    --   the buttons of action editor are displayed
    --
    -- save action
    -- UI.scene.app:dispatchEvent {
    --   name = "editor.save",
    --   UI = UI
    -- }

    -- local actionCommandTable = require("editor.action.actionCommandTable")
      --print("###", #actionCommandTable.objs)
      -- local obj = actionCommandTable.objs
      -- actionCommandTable.singleClickEvent(obj)

  -- TODO) inputText for action name
  --  create a command
    -- 2.0 click a new command
      -- 2.0.1 open it in command editor
    -- 2.1 save button in commandEditor
      -- 2.1.1 save it in memory
      -- 2.1.2 add it to commands table
    -- 2.2 save button of actionEditor
       -- 2.2.1 render/save lua & json
end

function M.xtest_commandEditor()
  --  create a command
    -- 2.0 click a new command
      -- 2.0.1 open it in command editor
    -- 2.1 save button in commandEditor
      -- 2.1.1 save it in memory
      -- 2.1.2 add it to commands table
    -- 2.2 save button of actionEditor
       -- 2.2.1 render/save lua & json
  -- delete a command
    -- 3.0 click delete button
    -- 3.1 show OK? dialog
      -- 3.1.1 remove it in memory
      -- 3.1.2 remove it commands table
      -- 3.1.3 close commandEditor
    -- 3.2 save button
  -- update a command
    -- commands editor
      -- modify values of props
      --  save button
        --  update commands Table
      --  close
    --  save button
end

return M
