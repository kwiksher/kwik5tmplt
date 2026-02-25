local M = require("Test.base_suite").new({
  page = "page1",
})

local bookName = "keyboard" -- "bookTest01"
local pageName = "page1"

local helper = require("Test.helper")
--local actionTable = require("editor.action.actionTable")
--

function M.xtest_creteVariable()
  M.selectors.componentSelector:onClick(true,  "variableTable")
  -- for k, v in pairs(varaibleTable.iconObjs[1]) do print(k, v) end
  local obj = M.variableTable.iconObjs[1]
  obj.callBack({target={muiOptions={name="varaibles-icon"}}})
end

function M.xtest_modifyVariable()
  M.selectors.componentSelector:onClick(true,  "variableTable")
  M.variableTable.altDown = true
  helper.selectVariable("LED")
  M.variableTable.altDown = false
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
  helper.selectLayer("N01")
  helper.selectIcon("Interactions", "Button")

  helper.clickProp(M.actionbox.objs, "onTap")
  helper.clickButton("New", M.actionboxButtonContext)

  --[[
    new action: onButton1
       action setVar
       controls > variables
  --]]

  M.picker:continue("onN01")
  helper.selectActionGroup("Controls")
  helper.selectActionCommand("variable", "editVar")
  helper.clickProp(M.actionCommandPropsTable.objs, "_target")
  helper.selectVariable("LED")

  helper.setProp(M.actionCommandPropsTable.objs, "type", "function")
  helper.setProp(M.actionCommandPropsTable.objs, "value", "M.UI.mycode.checkLCD(value..'1')")

  helper.clickButton("save", M.actionCommandButtons)
end

function M.xtest_buttonOK_action()
  -- if isEqual("LCD", "numDica") then
  --    show("Win")
  helper.selectLayer("ok")
  helper.selectIcon("Interactions", "Button")

  helper.clickProp(M.classProps.objs, "over") -- M.classProps
  helper.selectLayer("OkDown")

  helper.clickProp(M.actionbox.objs, "onTap") -- M.actionbox
  helper.clickButton("New", M.actionboxButtonContext)

  M.picker:continue("onOK")
  helper.selectActionGroup("Controls")
  helper.selectActionCommand("condition", "__if")
  helper.setProp(M.actionCommandPropsTable.objs, "A1_", "M.UI:getVariable('LCD')")
  helper.setProp(M.actionCommandPropsTable.objs, "A2_Operand", "==")
  helper.setProp(M.actionCommandPropsTable.objs, "A3_", "M.UI:getVariable('numDica')")
  helper.setProp(M.actionCommandPropsTable.objs, "AB_Condition", "")
  helper.clickButton("save", M.actionCommandButtons)
  --
  helper.selectActionGroup("Layer")
  helper.selectActionCommand("Layer", "showHide")
  helper.clickProp(M.actionCommandPropsTable.objs, "_target")
  helper.selectLayer("Win")
  helper.setProp(M.actionCommandPropsTable.objs, "hide", "false")
  helper.setProp(M.actionCommandPropsTable.objs, "toggle", "false")
  helper.clickButton("save", M.actionCommandButtons)

  helper.selectActionGroup("Controls")
  helper.selectActionCommand("condition", "_end")
  helper.clickButton("save", M.actionCommandButtons)
end

function M.xtest_buttonClear_action()
  -- editVar("LCD", "")
  helper.selectLayer("Clear")
  helper.selectIcon("Interactions", "Button")

  -- helper.clickProp(classProps.objs, "over") -- classProps
  -- helper.selectLayer("OkDown")

  helper.clickProp(M.actionbox.objs, "onTap") -- M.actionbox
  helper.clickButton("New", M.actionboxButtonContext)

  M.picker:continue("onClear")

  helper.selectActionGroup("Controls")
  helper.selectActionCommand("variable", "editVar")
  helper.clickProp(M.actionCommandPropsTable.objs, "_target")
  helper.selectVariable("LED")

  helper.setProp(M.actionCommandPropsTable.objs, "type", "string")
  helper.setProp(M.actionCommandPropsTable.objs, "value", "")

  helper.clickButton("save", M.actionCommandButtons)

end

return M
