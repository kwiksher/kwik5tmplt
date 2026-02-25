local M = require("Test.base_suite").new({
  selectApp = true,
  book = "bookFree",
  page = "page_protrait",
})

local helper = require("Test.helper")

local bookName = "bookFree"
local pageName = "page_protrait"

-- video
--  spritesheet
--  particles
--  canvas
--  sync

function M.xtest_select_layer_gotoBtn()
  local name = "gotoBtn"
  for i, entry in next,M.layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      entry:touch({phase="ended"}) -- gotoBtn
      break
    end
  end
end

function M.xtest_new_video()
  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = M.UI,
      class = "video", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )
end

function M.test_select_layer_video()
  local name = "imageOne"
  for i, entry in next,M.layerTable.objs do
    print("", i, entry.text)
    if entry.text == name then
      for j, e in next, entry.classEntries do
        if e.text == "video" then
          print("", "touched", e.text)
          e:touch({phase="ended"})
          break
        end
      end
      break
    end
  end
  --
  -- local button = "save"
  -- local obj = require("editor.parts.buttons").objs[button]
  -- obj:tap()
end

function M.test_new_spritesheet()
  M.UI.scene.app:dispatchEvent(
    {
      name = "editor.selector.selectTool",
      UI = M.UI,
      class = "spritesheet", -- obj.class,
      -- toolbar = self,
      isNew = true
    }
  )
end

---[[
  function M.xtest_new_sync()
    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.selector.selectTool",
        UI = M.UI,
        class = "sync", -- obj.class,
        -- toolbar = self,
        isNew = true
      }
    )
  end
--]]

---[[
  function M.xtest_new_sync_add_save()
    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.selector.selectTool",
        UI = M.UI,
        class = "sync", -- obj.class,
        -- toolbar = self,
        isNew = true
      }
    )

    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.replacement.list.add",
        UI = M.UI,
        type = "line", -- for sync,
        index = 3 -- number of entries
      }
    )

    local listPropsTable = require("editor.replacement.listPropsTable")
    -- name props
    listPropsTable.objs[1].field.text = "myName"
    -- start
    listPropsTable.objs[2].field.text = "3000"

    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.replacement.list.save",
        UI = M.UI,
        class = "sync", -- obj.class,
        index = 4
      }
    )

  end
--]]

---[[
  function M.xtest_new_canvas()
    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.selector.selectTool",
        UI = M.UI,
        class = "canvas", -- obj.class,
        -- toolbar = self,
        isNew = true
      }
    )
  end
--]]

---[[
  function M.xtest_new_particles()
    M.UI.scene.app:dispatchEvent(
      {
        name = "editor.selector.selectTool",
        UI = M.UI,
        class = "particles", -- obj.class,
        -- toolbar = self,
        isNew = true
      }
    )
  end
--]]

return M
