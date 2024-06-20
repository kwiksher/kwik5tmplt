local M = {}

local selectors
local UI
local bookTable
local pageTable
local layerTable
local bookName = "book" -- "bookTest01"
local pageName = "page2"
local listbox = require("editor.replacement.listbox")
local listPropsTable = require("editor.replacement.listPropsTable")

local helper = require("editor.tests.helper")
local classProps = require("editor.parts.classProps")
local assetTable = require("editor.asset.assetTable")
local listButtons = require("editor.replacement.listButtons")

function M.init(props)
  selectors = props.selectors
  UI = props.UI
  bookTable = props.bookTable
  pageTable = props.pageTable
  layerTable = props.layerTable
end

function M.suite_setup()
  selectors.projectPageSelector:show()
  selectors.projectPageSelector:onClick(true)
  selectors.componentSelector.iconHander()
  selectors.componentSelector:onClick(true, "layerTable")
end

function M.setup()
end

function M.teardown()
end

function M.test_new_sync()

  helper.selectLayer("text1")
  helper.selectIcon("Replacements", "Sync")

  -- helper.clickProp(classProps.objs, "_filename")
  -- helper.clickAsset(assetTable.objs, "sprites/SpriteTiles/sprites.png")
  -- helper.setProp(classProps.objs, "numFrames", 64)
  -- -- this calculates w, h of sprite
  -- helper.clickProp(classProps.objs, "_filename")

  -- local obj = helper.getObj(listbox.objs, "default")
  -- listbox.singleClickEvent(obj)
  -- helper.setProp(listPropsTable.objs, "loopCount", "")


  -- obj = helper.getObj(listButtons.objs, "Preview")
  -- obj:tap()

end

function M.xtest_new_sync_add_save()
  UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = UI,
      class = "sync", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )

  UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.add",
      UI = UI,
      type = "line", -- for sync,
      index = 3 -- number of entries
    }
  )

  local listPropsTable = require("editor.replacement.listPropsTable")
  -- name props
  listPropsTable.objs[1].field.text = "myName"
  -- start
  listPropsTable.objs[2].field.text = "3000"

  UI.scene.app:dispatchEvent(
    {
      name = "editor.replacement.list.save",
      UI = UI,
      class = "sync", -- obj.class,
      index = 4
    }
  )
end

return M
