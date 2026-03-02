local M = require("Test.base_suite").new()

local bookName = "book" -- "bookTest01"
local pageName = "page1"

local helper = require("Test.helper")

-- video
--  spritesheet
--  particles
--  canvas
--  sync

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

function M.xtest_new_spritesheet()
  local function steps()
    helper.selectLayer("starfish")
    helper.selectIcon("Replacements", "Sprite")

    coroutine.yield()

    helper.clickProp(M.classProps.objs, "_filename")
    helper.clickAsset(M.assetTable.objs, "sprites/SpriteTiles/sprites.png")
    helper.setProp(M.classProps.objs, "numFrames", 64)
    -- this calculates w, h of sprite
    helper.clickProp(M.classProps.objs, "_filename")

    coroutine.yield()

    local obj = helper.getObj(M.listbox.objs, "default")
    M.listbox.singleClickEvent(obj)

    coroutine.yield()

    -- local rnd = math.random(1, 16)
    local rnd = 1
    helper.setProp(M.listPropsTable.objs, "start", (rnd * 4) - 3)
    helper.setProp(M.listPropsTable.objs, "count", 4)
    helper.setProp(M.listPropsTable.objs, "time", 600)
    helper.setProp(M.listPropsTable.objs, "loopCount", "")

    coroutine.yield()

    --
    rnd = string.format("%02d", rnd)
    helper.setProp(M.listPropsTable.objs, "name", "tile_" .. rnd)

    coroutine.yield()

    obj = helper.getObj(M.listButtons.objs, "Preview")
    obj:tap()

    coroutine.yield()

    -- obj = helper.getObj(listButtons.objs, "Save")
    -- obj:tap()
  end

  local co = coroutine.create(steps)
  timer.performWithDelay(
    1000,
    function()
      coroutine.resume(co)
    end,
    7
  )
end

function M.xtest_new_spritesheet_sheetInfo_Animate()
  local cnt = 0

  local function steps()
    helper.selectLayer("starfish")
    helper.selectIcon("Replacements", "Sprite")

    coroutine.yield()

    helper.clickProp(M.classProps.objs, "sheetInfo")
    helper.clickAsset(M.assetTable.objs, "sprites/girlBicyle.png")
    --helper.setProp(classProps.objs, "numFrames", 64)
    -- this calculates w, h of sprite
    --helper.clickProp(classProps.objs, "_filename")
    coroutine.yield()

    local obj = helper.getObj(M.listbox.objs, "default")
    M.listbox.singleClickEvent(obj)

    coroutine.yield()

    -- local rnd = math.random( 1,16 )
    -- helper.setProp(listPropsTable.objs, "start",  (rnd * 4) - 3)
    helper.setProp(M.listPropsTable.objs, "count", 48)

    coroutine.yield()

    -- helper.setProp(listPropsTable.objs, "time", 600)
    helper.setProp(M.listPropsTable.objs, "loopCount", "")

    coroutine.yield()
    -- --
    -- rnd = string.format( "%02d", rnd )
    -- helper.setProp(listPropsTable.objs, "name", "tile_"..rnd)

    obj = helper.getObj(M.listButtons.objs, "Preview")
    -- obj = helper.getObj(listButtons.objs, "Save")
    obj:tap()
  end

  local co = coroutine.create(steps)

  timer.performWithDelay(
    1000,
    function()
      coroutine.resume(co)
    end,
    6
  )
end

function M.xtest_new_spritesheet_sheetInfo()
  helper.selectLayer("starfish")
  helper.selectIcon("Replacements", "Sprite")

  helper.clickProp(M.classProps.objs, "sheetInfo")
  helper.clickAsset(M.assetTable.objs, "sprites/slots.png")
  --helper.setProp(classProps.objs, "numFrames", 64)
  -- this calculates w, h of sprite
  --helper.clickProp(classProps.objs, "_filename")

  local obj = helper.getObj(M.listbox.objs, "default")
  M.listbox.singleClickEvent(obj)

  -- local rnd = math.random( 1,16 )
  -- helper.setProp(listPropsTable.objs, "start",  (rnd * 4) - 3)
  helper.setProp(M.listPropsTable.objs, "count", 16)
  -- helper.setProp(listPropsTable.objs, "time", 600)
  -- helper.setProp(listPropsTable.objs, "loopCount", "")
  -- --
  -- rnd = string.format( "%02d", rnd )
  -- helper.setProp(listPropsTable.objs, "name", "tile_"..rnd)

  --obj = helper.getObj(listButtons.objs, "Preview")
  obj = helper.getObj(M.listButtons.objs, "Save")
  obj:tap()

  local controller = require("editor.replacement.controller.index")
  local props = controller:useClassEditorProps(M.UI)
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

  -- name props
  M.listPropsTable.objs[1].field.text = "myName"
  -- start
  M.listPropsTable.objs[2].field.text = "3000"

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

function M.xtest_util()
  local json = require("json")
  local scene = {
    components = {
      layers = {
        {
          back = {}
        },
        {butBlue = {class = {"button"}}},
        {
          groupOne = {}
        }
      },
      audios = {},
      groups = {
        {groupC = {}}
      },
      timers = {},
      variables = {},
      others = {}
    },
    commands = {"blueBTN"},
    onInit = function(scene)
      print("onInit")
    end
  }

  local util = require("editor.util")
  local updatedModel = util.updateIndexModel(scene, "back", "sprite")
  print(json.encode(updatedModel))

  local renderdModel = util.createIndexModel(updatedModel)
  print(json.encode(renderdModel))

  local controller = require("editor.controller.index")
  controller:renderIndex("book", "page1", renderdModel)
end

return M
