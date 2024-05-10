local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

local helper = require("editor.tests.helper")


function helper.selectLayer(name)
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- animation
      -- entry.classEntries[1]:touch({phase="ended"}) -- animation
      break
    end
  end
end

function selectTool(args)
  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = args.class, -- obj.class,
      -- toolbar = self,
      isNew = args.isNew
    }
  )
end

function selectComponent(name)
  for i, v in next, selectors.componentSelector.objs do
    if v.text == name then
      v:dispatchEvent{name="tap", target=v}
      return
    end
  end
end

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
  --
  UI.scene.app:dispatchEvent {
    name = "editor.selector.selectApp",
    UI = UI
  }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book="book"}, nil,  true)
  pageTable.commandHandler({page="page1"},nil,  true)
  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true,  "layerTable")
end

function M.setup()
end

function M.teardown()
end

function M.xtest_select()
  local name = "title"
  helper.selectLayer(name)
  -- selectTool{class="linear", isNew=true}
  --selectComponent("Action")
end

function M.test_select_for_editing()
  local name = "title"
  layerTable.altDown = true
  print("------------------")
  helper.selectLayer(name)
  layerTable.altDown = false

  -- selectTool{class="linear", isNew=true}
  --selectComponent("Action")
end


function M.xtest_select_animation()
    local name = "title"
    --
    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
    --
end

function M.test_new_animation()
  local name = "gotoBtn"
  helper.selectLayer(name)

  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = "blink", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  -- local button = "save"
  -- local obj = require("editor.parts.buttons").objs[button]
  -- obj:tap()

end

function M.xtest_add_animation()
  local name = "title"
  helper.selectLayer(name)

  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = "blink", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  local button = "save"
  local obj = require("editor.parts.buttons").objs[button]
  obj:tap()

end

function M.xtest_action()
  UI.scene.app:dispatchEvent {
    name = "editor.action.selectLayer",
    action = "eventOne",
    UI = UI
  }
end

return M
