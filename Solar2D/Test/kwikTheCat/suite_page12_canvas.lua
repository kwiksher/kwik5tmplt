local M = require("Test.base_suite").new({
  component = "iconOnly"
})

local helper = require("Test.helper")

function M.xtest_new_canvas()
  helper.selectLayer("canvas")
  helper.selectIcon("Interactions", "Canvas")
end

function M.xtest_new_brush_size()
  helper.selectLayer("brush1")
  helper.selectIcon("Interactions", "Button")
  -- onTap small

  helper.selectLayer("brush2")
  helper.selectIcon("Interactions", "Button")
  -- onTap middle

  helper.selectLayer("brush3")
  helper.selectIcon("Interactions", "Button")
  -- onTap large
end

function M.xtest_new_button_with_brush_color_new_action()
  helper.selectLayer("color8")
  helper.selectIcon("Interactions", "Button")
  --
  helper.clickProp(M.actionbox.objs, "onTap")
  --
  -- local M.actionButtonContext = require("editor.parts.actionButtonContext")
  -- M.actionButtonContext.objs.New.rect:tap()
  helper.clickButton("New", M.actionButtonContext)
  --
  -- M.picker:continue("tapHandler")
  --
  M.picker.obj.field.text = "tapHandler"
  --
  helper.clickObj(M.picker.buttonObjs, "Continue")
  --
  helper.selectActionGroup("Interactions")
  helper.selectActionCommand("canvas", "brush")
  helper.setProp(M.actionCommandPropsTable.objs, "color", "0,0,0,1")
  helper.clickButton("save", M.actionCommandButtons)
  helper.clickButton("save", M.actionButtons) -- editor.action.buttons
  -- helper.clickButton("save", require("editor.parts.buttons")
end

function M.xtest_modify_button_with_brush_color_new_action()
 helper.selectLayerProps("color8", "button") -- altDown
end

function M.xtest_new_buttons()
  helper.selectLayer("save1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(M.classProps.objs, "over")
  helper.selectLayer("save2")
  -- onTap save(screen shot)

  helper.selectLayer("reload1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(M.classProps.objs, "over")
  helper.selectLayer("reload2")
  -- onTap reload

  helper.selectLayer("back1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(M.classProps.objs, "over")
  helper.selectLayer("back2")
  -- onTap goto previous page
end

function M.xtest_new_action_for_buttons()
  --
  if not helper.hasObj(M.actionTable, "brushBlack") then
    helper.selectIcon("action")
    M.actionTable.newButton:tap()
    M.picker:continue("brushBlack")
    helper.selectActionGroup("Interactions")
    helper.selectActionCommand("canvas", "brush")
    helper.setProp(M.actionCommandPropsTable.objs, "color", "0,0,0,1")
    -- helper.clickButton("save", M.actionCommandButtons)
  end

  if not helper.hasObj(M.actionTable, "brushErase") then
    helper.selectIcon("action")
    M.actionTable.newButton:tap()
    M.picker:continue("brushErase")
    helper.selectActionGroup("Interactions")
    helper.selectActionCommand("canvas", "erase")
    -- helper.clickButton("save", M.actionCommandButtons)
  end

  -- helper.selectActionCommand("canvas", "erase")
  -- helper.selectActionCommand("canvas", "redo")
  -- helper.selectActionCommand("canvas", "undo")
end

function M.xtest_modify_action_add_extcode()
  helper.selectIcon("action")
  if helper.hasObj(M.actionTable, "brushBlack") then
    helper.clickAction("brushBlack")
    M.actionTable.editButton:tap()
    helper.selectActionGroup("Controls")
    helper.selectActionCommand("externalcode", "code")
  end
end

function M.test_modify_action_back()
  helper.selectIcon("action")
  if helper.hasObj(M.actionTable, "back") then
    helper.clickAction("back")
    M.actionTable.editButton:tap()
    -- helper.singelClick(M.actionCommandTable, "canvas.brush")
  end
end

--
function M.xtest_get_action()
  helper.selectIcon("action")
  if helper.hasObj(M.actionTable, "brushBlack") then
    helper.clickAction("brushBlack")
    M.actionTable.editButton:tap()
  end
end

function M.xtest_modify_action()
  helper.selectIcon("action")
  if helper.hasObj(M.actionTable, "brushBlack") then
    helper.clickAction("brushBlack")
    M.actionTable.editButton:tap()
    helper.singelClick(M.actionCommandTable, "canvas.brush")
  end
end

function M.xtest_modify_action_undo()
  helper.selectIcon("action")
  if helper.hasObj(M.actionTable, "undo") then
    helper.clickAction("undo")
    M.actionTable.editButton:tap()
    helper.selectActionGroup("Interactions")
    helper.selectActionCommand("canvas", "redo")
  end
end

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

function M.xtest_delete_button()
  helper.selectLayer("color7", "button", false) -- isRightClick
  helper.selectLayer("color7", "button", true) -- isRightClick
  -- local M.actionButtonContext = require("editor.parts.actionButtonContext")
  --
  -- then delete it manually

end

function M.xtest_copy_paste()
  helper.selectIcon("action")
  helper.clickAction("brushBlack")
  -- helper.selectAction("brushBlack", true)
  --helper.clickButton("Copy", M.actionButtonContext)
  --helper.clickButton("Paste", M.actionButtonContext)
  -- helper.clickButton("Edit", M.actionButtonContext)
end

function M.xtest_delete_action()
  helper.selectIcon("action")
  helper.clickAction("brushBlack_copied")
  helper.selectAction("brushBlack_copied", true)
  -- helper.clickButton("Delete", M.actionButtonContext)

end

function M.xtest_copy_paste_button()
  helper.selectLayer("color8", "button", false) -- isRightClick
  helper.selectLayer("color8", "button", true) -- isRightClick
  --
  -- local M.actionButtonContext = require("editor.parts.actionButtonContext")
  -- helper.clickButton("Copy", M.actionButtonContext)
  --
  -- helper.selectLayer("color7", "button", false) -- isRightClick
  -- helper.selectLayer("color6", "button", false) -- isRightClick
  -- helper.selectLayer("color5", "button", false) -- isRightClick
  -- helper.selectLayer("color4", "button", false) -- isRightClick
  -- helper.selectLayer("color3", "button", false) -- isRightClick
  -- helper.selectLayer("color2", "button", false) -- isRightClick
  -- helper.selectLayer("color1", "button", false) -- isRightClick
  --
  -- then paste it manually
end

function M.xtest_new_brush_color_buttons_at_once()
  M.layerTable.controlDown = true
  helper.selectLayer("color8")
  helper.selectLayer("color7")
  helper.selectLayer("color6")
  helper.selectLayer("color5")
  helper.selectLayer("color4")
  helper.selectLayer("color3")
  helper.selectLayer("color2")
  helper.selectLayer("color1")
  helper.selectIcon("Interactions", "Button")
  M.layerTable.controlDown = false
  helper.setProp(M.actionbox.objs, "onTap", "colorHandler")
  -- each onTap is attached with action brush{Black, Blue, Red, ...}
end

function M.xtest_edit_button_color8()
  helper.selectLayer("color8", "button", false) -- isRightClick
  helper.selectLayer("color8", "button", true) -- isRightClick

  local objs = require("editor.parts.buttons").objs
  objs.modify.rect:tap()

  helper.clickProp(M.actionbox.objs, "onTap")
  objs = require("editor.parts.buttonContext").objs
  objs.Select.rect:tap()

  helper.clickAction("brushBlack")
end

function M.xtest_copy_paste_delete_actions()
end

function M.xtest_copy_paste_delete_actionCommands()
end

return M
