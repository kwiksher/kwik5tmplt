local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local actionTable = require("editor.action.actionTable")
local actionCommandTable = require("editor.action.actionCommandTable")
local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
local actionEditor = require("editor.action.index")
local colorPicker = require("extlib.colorPicker")
local classProps = require("editor.parts.classProps")
local actionbox = require("editor.parts.actionbox")
----
local buttons = require("editor.action.buttons")
local actionCommandButtons = require("editor.action.actionCommandButtons")
----
local helper = require("editor.tests.helper")
local picker = require("editor.picker.name")
local buttonContext = require("editor.action.buttonContext")


function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  props.actionTable = actionTable
  props.buttons = buttons
  helper.init(props)
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  selectors.componentSelector.iconHander()
end

function M.setup()
end

function M.teardown()
end

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
  helper.clickProp(actionbox.objs, "onTap")
  --
  local buttonContext = require("editor.parts.buttonContext")
  buttonContext.objs.New.rect:tap()
  --
  -- picker:continue("tapHandler")
  --
  picker.obj.field.text = "tapHandler"
  --
  helper.clickObj(picker.buttonObjs, "Continue")
  --
  helper.selectActionGroup("Interactions")
  helper.selectActionCommand("canvas", "brush")
  helper.setProp(actionCommandPropsTable.objs, "color", "0,0,0,1")
  helper.clickButton("save", actionCommandButtons)
  helper.clickButton("save") -- editor.action.buttons
  -- helper.clickButton("save", require("editor.parts.buttons")
end

function M.xtest_modify_button_with_brush_color_new_action()
 helper.selectLayerProps("color8", "button") -- altDown
end


function M.xtest_new_brush_color()
  layerTable.controlDown = true
  helper.selectLayer("color8")
  helper.selectLayer("color7")
  helper.selectLayer("color6")
  helper.selectLayer("color5")
  helper.selectLayer("color4")
  helper.selectLayer("color3")
  helper.selectLayer("color2")
  helper.selectLayer("color1")
  helper.selectIcon("Interactions", "Button")
  layerTable.controlDown = false
  helper.setProp(actionbox.objs, "onTap", "colorHandler")
  -- each onTap is attached with action brush{Black, Blue, Red, ...}
end

function M.xtest_new_buttons()
  helper.selectLayer("save1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(classProps.objs, "over")
  helper.selectLayer("save2")
  -- onTap save(screen shot)

  helper.selectLayer("reload1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(classProps.objs, "over")
  helper.selectLayer("reload2")
  -- onTap reload

  helper.selectLayer("back1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(classProps.objs, "over")
  helper.selectLayer("back2")
  -- onTap goto previous page
end

function M.xtest_new_action_for_buttons()
  --
  if not helper.hasObj(actionTable, "brushBlack") then
    helper.selectIcon("action")
    actionTable.newButton:tap()
    picker:continue("brushBlack")
    helper.selectActionGroup("Interactions")
    helper.selectActionCommand("canvas", "brush")
    helper.setProp(actionCommandPropsTable.objs, "color", "0,0,0,1")
    -- helper.clickButton("save", actionCommandButtons)
  end

  if not helper.hasObj(actionTable, "brushErase") then
    helper.selectIcon("action")
    actionTable.newButton:tap()
    picker:continue("brushErase")
    helper.selectActionGroup("Interactions")
    helper.selectActionCommand("canvas", "erase")
    -- helper.clickButton("save", actionCommandButtons)
  end

  -- helper.selectActionCommand("canvas", "erase")
  -- helper.selectActionCommand("canvas", "redo")
  -- helper.selectActionCommand("canvas", "undo")
end
--
function M.xtest_get_action()
  helper.selectIcon("action")
  if helper.hasObj(actionTable, "brushBlack") then
    helper.clickAsset(actionTable.objs, "brushBlack")
    actionTable.editButton:tap()
  end
end

function M.xtest_modify_action()
  helper.selectIcon("action")
  if helper.hasObj(actionTable, "brushBlack") then
    helper.clickAsset(actionTable.objs, "brushBlack")
    actionTable.editButton:tap()
    helper.singelClick(actionCommandTable, "canvas.brush")
  end
end

function M.xtest_copy_paste_actions()
  helper.selectIcon("action")
    -- brushBlack, brushRed, brushBlue ...
  if not helper.hasObj(actionTable, "brushRed") then
    helper.clickAsset(actionTable.objs, "brushBlack")
    actionTable.editButton:tap()
    helper.clickButton("copy") -- editor.action.buttons
    helper.clickButton("cancel") -- editor.action.buttons
    actionTable.newButton:tap()
    helper.clickButton("paste") -- editor.action.buttons
    -- picker.obj.field.text = "brushRed"
    -- helper.singelClick(actionCommandTable, "canvas.brush")
    -- use eyedropper(picker)?
    -- helper.setProp(actionCommandPropsTable.objs, "color", "1,0,0,1")
    -- helper.clickButton("save", actionCommandButtons)
    -- helper.clickButton("save") -- editor.action.buttons
  end
end

function M.xtest_copy_brush_action()
  helper.selectLayerProps("color8", "button") -- altDown
end

function M.xtest_copy_paste()
  helper.selectIcon("action")
  helper.touchAction("brushBlack")
  -- helper.selectAction("brushBlack", true)
  --helper.clickButton("Copy", buttonContext)
  --helper.clickButton("Paste", buttonContext)
  -- helper.clickButton("Edit", buttonContext)
end

function M.test_delete_action()
  helper.selectIcon("action")
  helper.touchAction("brushBlack_copied")
  helper.selectAction("brushBlack", true)
  --helper.clickButton("Delete", buttonContext)

end

return M
