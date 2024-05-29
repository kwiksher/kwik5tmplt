local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

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
  -- selectors.componentSelector:onClick(true,  "layerTable")
end

local function selectIcon(toolGroup, tool)
  local toolbar = UI.editor.toolbar
  local obj = toolbar.layerToolMap[toolGroup]
  obj.callBack{target=obj}
  if tool then
    local obj = toolbar.toolMap[obj.id.."-"..tool]
    obj.callBack{target=obj}
  end
end

function M.setup()
end

function M.teardown()
end

function M.test_settings()
  selectIcon("Physics", "Physics")
  -- selectIcon("Physics", "Body")
  -- selectIcon("Physics", "Collision")
  --selectIcon("Physics", "Force")
  --selectIcon("Physics", "Joint")

end

return M