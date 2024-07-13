local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

local helper = require("editor.tests.helper")
local json = require("json")

function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true,  "layerTable")
end

function M.setup()
end

function M.teardown()
end

function M.xtest_new_animation()

  local actionbox = require("editor.parts.actionbox")
  helper.actionTable = require("editor.action.actionTable")

  helper.selectLayer("ball")
  helper.selectIcon("Animations", "Linear")
  -- helper.selectIcon("Animations", "Blink")
  -- helper.selectIcon("Animations", "Bounce")
  -- helper.selectIcon("Animations", "Pulse")
  -- helper.selectIcon("Animations", "Rotation")
  -- helper.selectIcon("Animations", "Tremble")

  -- select an action
  --helper.clickProp(actionbox.objs, "onComplete")
  --helper.touchAction("eventOne")

end

function M.xtest_new_switch()
  local classProps = require("editor.parts.classProps")
  local actionbox = require("editor.parts.actionbox")
  helper.actionTable = require("editor.action.actionTable")

  helper.selectLayer("ball")

  helper.selectIcon("Animations", "Switch")
  -- helper.selectIcon("Animations", "Path")
  -- helper.selectIcon("Animations", "Filter")

  -- select a layer
  helper.clickProp(classProps.objs, "to")
  helper.selectLayer("fish")

end

function M.test_new_path()
  local classProps = require("editor.parts.classProps")
  local pathProps = require("editor.animation.pathProps")
  local actionbox = require("editor.parts.actionbox")
  helper.actionTable = require("editor.action.actionTable")

  helper.selectLayer("ball")
  helper.selectIcon("Animations", "Path")
  -- helper.selectIcon("Animations", "Filter")
  helper.setProp(pathProps.objs, "_filename", "path1_Shape_Path_closed.json")


end

function M.xtest_new_multi_animation()
  local name = "cat"
  --
  layerTable.controlDown = true
  --
  local names = {"name", "cat", "fish"}
  local class = nil
  for i, name in next, names do
    helper.selectLayer(name, class)
    --helper.selectLayer(name, nil, true) -- isRightClick true
  end
  layerTable.controlDown = false
  helper.clickIcon("Animations", "Linear")

  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj.rect:tap()

end

function M.xtest_easing()
  local easing = require("editor.easing.index")
  easing:create(UI)
  easing.listener = function(name)
    print(name)
    easing:destroy()
  end
  easing:show(UI)
end

return M
