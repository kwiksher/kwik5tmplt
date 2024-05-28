local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable

local groupTable = require("editor.group.groupTable")
local buttons = require("editor.group.buttons")

local helper = require("editor.tests.helper")

function M.init(props)
  selectors = props.selectors
  UI        = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
  --
  props.groupTable = groupTable
  props.buttons = buttons
  helper.init(props)

end

local book = "book"
local page = "page1"

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  -- --
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectApp",
  --   UI = UI
  -- }
  -- appFolder = system.pathForFile("App", system.ResourceDirectory) -- default
  -- useTinyfiledialogs = false -- default
  ---
  bookTable.commandHandler({book=book}, nil,  true)
  pageTable.commandHandler({page=page},nil,  true)
  selectors.componentSelector.iconHander()
end

function M.setup()
end

function M.teardown()
end

function M.test_click_group()
    UI.testCallback = function()
      UI.page = "page1"
      selectors.componentSelector:onClick(true,  "groupTable")
       -- click the icon for creatign a new group
      UI.scene.app:dispatchEvent {
        name = "editor.selector.selectGroup",
        UI = UI,
        isNew = true, --(name ~= "Trash-icon"),
        isDelete =false -- (name == "Trash-icon")
      }

    end
end

return M
