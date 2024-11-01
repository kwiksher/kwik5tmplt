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

local helper = require("editor.tests.helper")
local classProps = require("editor.parts.classProps")
local assetTable = require("editor.asset.assetTable")
local listButtons = require("editor.replacement.listButtons")
local libUtil = require("lib.util")
local util = require("editor.util")
local json = require("json")
--local actionTable = require("editor.action.actionTable")
local actionbox = require("editor.parts.actionbox")
local actionTable = require("editor.action.actionTable")


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

function M.test_createDynmicText()
  helper.selectLayer("Texto")
  helper.selectIcon("Replacements", "DynamicText")
end

return M
