local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local actionTable = require("editor.action.actionTable")

--local toolbar  = require("editor.parts.toolbar")

function selectLayer(name)
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

function selectAction(name)
  for i, v in next, actionTable.objs do
    print("###", v.text)
    if v.text == name then
      -- v:dispatchEvent{name="touch", pahse="ended", target=v}
      v:tap{target=v}
      return
    end
  end
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
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book="book"}, nil,  true)
  pageTable.commandHandler({page="page1"},nil,  true)
  selectors.componentSelector.iconHander()
end

function M.setup()
end

function M.teardown()
end

--[[
function M.test_select_layer()
  local name = "gotoBtn"
  for i, entry in next,layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- layer props
      break
    end
  end
end
--]]
--[[
  function M.test_select_button()
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
--]]

local function selectIcon(toolGroup, tool)
  local toolbar = UI.editor.toolbar
  local obj = toolbar.layerToolMap[toolGroup]
  obj.callBack{target=obj}
  if tool then
    local obj = toolbar.toolMap[obj.id.."-"..tool]
    obj.callBack{target=obj}
  end
end

local function selectCancel()
  local button = "cancel"
  local obj = require("editor.parts.buttons").objs[button]
  obj.rect:tap()
end

---[[
  function M.test_new_button()
    selectors.componentSelector:onClick(true,  "layerTable")

    local name = "cat"
    for i, entry in next,layerTable.objs do
      print("", i, entry.text)
      if entry.text == name then
        entry:touch({phase="ended"}) -- gotoBtn
        break
      end
    end
    --print("-----------------")
    -- for k, v in pairs(toolbar.layerToolMap.Interactions) do print(k, v) end
    -- for k, v in pairs(toolbar.toolMap) do print(k, v) end
    -- selectTool{class="button", isNew=true}

    selectIcon("Interactions", "Button")
    -- selectCancel()
    --selectIcon("Interactions", "Button")


  -- selectors.componentSelector:onClick(true,  "actionTable")
  -- selectAction("eventOne")

  --  select an over-layer
    -- click "over" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

  -- select a mask
    -- click "mask" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

  -- selet an action
    -- click "over" of the prop's name to make it active
    --   layerTable is displayed
    --   select a layer

    -- --
    -- local button = "save"
    -- local obj = require("editor.parts.buttons").objs[button]
    -- obj:tap()
  end
--]]

--[[
function M.test_new_button_cancel()
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
--]]


--[[
  function M.test_add_second_button()
    local name = "gotoBtn"
    for i, entry in next,layerTable.objs do
      print("", i, entry.text)
      if entry.text == name then
        entry.classEntries[1]:touch({phase="ended"}) -- animation
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

    local button = "save"
    local obj = require("editor.parts.buttons").objs[button]
    obj:tap()

  end
--]]


return M
