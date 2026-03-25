local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"
--
-- get_started/copy_paste_component/
-- copied in page1 layerTable, then pasted in page2 pageTable or layerTable
--
--
-- one layer or class is copied in page1, and pasted in page1 layerTable
--
function M.xtest_copy_layers() -- classes are included
  local name = "cat"
  -- layerTable.altDown = true
  helper.selectLayer(name)
  helper.selectLayer(name, nil, true) -- isRightClick true
  helper.clickButton("copy")

  -- layerTable.altDown = false

  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- helper.selectAction("eventOne")
end

--
-- muliple actions are copied in page1 actionTable
--
function M.xtest_copy_paste_actions()
  helper.selectIcon("action")
    -- brushBlack, brushRed, brushBlue ...
  if not helper.hasObj(M.actionTable, "brushRed") then
    helper.clickAction("brushBlack")
    M.actionTable.editButton:tap()
    helper.clickButton("copy",   M.actionButtons) -- editor.action.buttons
    helper.clickButton("cancel", M.actionButtons) -- editor.action.buttons
    M.actionTable.newButton:tap()
    helper.clickButton("paste", M.actionButtons) -- editor.action.buttons
    -- M.picker.obj.field.text = "brushRed"
    -- helper.singelClick(M.actionCommandTable, "canvas.brush")
    -- use eyedropper(M.picker)?
    -- helper.setProp(M.actionCommandPropsTable.objs, "color", "1,0,0,1")
    -- helper.clickButton("save", M.actionCommandButtons)
    -- helper.clickButton("save") -- editor.action.buttons
  end
end

function M.xtest_copy_paste_actionCommands()
end

---
--- group timer ..
---
function M.xtest_copy_paste_groups()
end

function M.xtest_copy_paste_timers()
end

function M.xtest_copy_paste_joints()
end

function M.xtest_copy_paste_vars()
end

function M.xtest_copy_paste_audios()
end

function M.xtest_copy_paste_pages()
end

function M.xtest_copy_paste_books() -- not supported
end

return M
