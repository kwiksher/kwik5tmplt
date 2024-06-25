local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local actionTable
local helper = require("editor.tests.helper")

function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  actionTable = props.actionProps
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  bookTable.commandHandler({book="book"}, nil,  true)
  pageTable.commandHandler({page="page3"},nil,  true)
  selectors.componentSelector.iconHander()
end

function M.setup()
end

function M.teardown()
end

function M.test_rectTool()
  local rectTool = require("editor.shape.rectTool")

  helper.selectLayer("ball")
  helper.selectLayer("fish")
  helper.selectIcon("Interactions", "Drag")

  local classProps = require("editor.parts.classProps")
  local obj = classProps.objs[2] -- boundaries
  -- rectTool:setActiveEntry(obj)
  rectTool:setActiveEntry({text="0,0,0,0"})
  rectTool:drawRect()

end

function M.xtest_new_drag()
  helper.selectLayer("ball")
  helper.selectLayer("fish")
  helper.selectIcon("Interactions", "Drag")

-- selectors.componentSelector:onClick(true,  "actionTable")
-- selectAction("eventOne")

  -- --
  -- local button = "save"
  -- local obj = require("editor.parts.buttons").objs[button]
  -- obj:tap()
end

function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end

function M.xtest_new_button_cancel()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- gotoBtn
      break
    end
  end

  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = "button", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  -- Canel
  local button = "cancel"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
end

function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end

function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end
function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end
function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end
function M.xtest_select_button()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
  --
  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()
  --
end

return M
