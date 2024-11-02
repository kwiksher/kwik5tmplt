local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local variableTable = require("editor.variable.variableTable")

local bookName = "keyboard" -- "bookTest01"
local pageName = "page1"
local listbox = require("editor.replacement.listbox")
local listPropsTable = require("editor.replacement.listPropsTable")

local helper = require("test.helper")
local classProps = require("editor.parts.classProps")
local assetTable = require("editor.asset.assetTable")
local listButtons = require("editor.replacement.listButtons")
local libUtil = require("lib.util")
local util = require("editor.util")
local json = require("json")
--local actionTable = require("editor.action.actionTable")
local actionbox = require("editor.parts.actionbox")
local actionTable = require("editor.action.actionTable")
local actionButtonContext = require("editor.action.buttonContext")
local picker = require("editor.picker.name")


function M.init(props)
  selectors = props.selectors
  UI = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  --
  props.variableTable = variableTable
  helper.init(props)

end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  pageTable.commandHandler({page="page1"},nil,  true)
  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true, "layerTable")
end

function M.setup()
end

function M.teardown()
end

function M.xtest_creteVariable()
  selectors.componentSelector:onClick(true,  "variableTable")
  -- for k, v in pairs(varaibleTable.iconObjs[1]) do print(k, v) end
  local obj = variableTable.iconObjs[1]
  obj.callBack({target={muiOptions={name="varaibles-icon"}}})
end

function M.xtest_modifyVariable()
  selectors.componentSelector:onClick(true,  "variableTable")
  variableTable.altDown = true
  helper.selectVariable("LED")
  variableTable.altDown = false
  -- for k, v in pairs(varaibleTable.iconObjs[1]) do print(k, v) end
  --local obj = variableTable.iconObjs[1]
  --obj.callBack({target={muiOptions={name="varaibles-icon"}}})
end

function M.xtest_createDynmicText()
  helper.selectLayer("textodica")
  helper.selectIcon("Replacements", "DynamicText")
end

function M.xtest_createDynmicText()
  helper.selectLayer("Texto")
  helper.selectIcon("Replacements", "DynamicText")
end

function M.xtest_extLib()
  -- extLib icon to open App/uiHandler in vscode
  --  require "keyboard.mycode"
end

function M.xtest_extCode()
  -- extCode icon to open App/uiHandler in vscode
  --   ```
  --   UI.mycode:createDica(UI)
  --   ```
  -- or create an action and set it timer with delay 0
  --
  --   editVar("numDica", function(value) return math.random(1.3) ..math.random(1,3) end)
  --    hide("Win")
  --
  -- TODO
  --   action option to execute at init, create, didShow, didHide, destroy
end

function M.xtest_button123_action()
  helper.selectLayer("No1")
  helper.selectIcon("Interactions", "Button")
  helper.clickProp(actionbox.objs, "onTap")
  helper.clickButton("New", actionButtonContext)
  -- new action: onButton1
  --   action setVar
  --   controls > variables

  -- picker:continue("button1")
  --helper.selectActionGroup("Controls")
  --helper.selectActionCommand("variables", "editVar")
  --helper.setProp(actionCommandPropsTable.objs, "color", "0,0,0,1")
  -- helper.clickButton("save", actionCommandButtons)



-- editVar("LCD", function (value) return UI.mycode.checkLCD(value..'1')end)
-- editVar("LCD", function (value) return UI.mycode.checkLCD(value..'2')end)
-- editVar("LCD", function (value) return UI.mycode.checkLCD(value..'3')end)
end

function M.xtest_buttonOK_action()
  -- if isEqual("LCD", "numDica") then
  --    show("Win")
end

function M.xtest_buttonClear_action()
-- editVar("LCD", "")
end

return M
