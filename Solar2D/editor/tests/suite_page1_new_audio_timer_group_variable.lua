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

local book = "bookFree"
local page = "page1"

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
  bookTable.commandHandler({book=book}, nil,  true)
  pageTable.commandHandler({page=page},nil,  true)
  selectors.componentSelector.iconHander()
  -- selectors.componentSelector:onClick(true,  "layerTable") --isVisible = true
end

function M.setup()
end

function M.teardown()
end

function M.xtest_new_audio()

  local controller = require("editor.controller.index")
  controller.view = {UI = UI}
  selectors.componentSelector:onClick(true,  "audioTable") --isVisible = true

  -- click the icon for creatign a new audio
  UI.scene.app:dispatchEvent {
    name = "editor.selector.selectAudio",
    UI = UI,
    class = "audio",
    isNew = true, --(name ~= "Trash-icon"),
    isDelete =false -- (name == "Trash-icon")
  }

  selectors.assetsSelector:show()
  selectors.assetsSelector:onClick(true, "audios") --isVisible = true
    -- local audio_index = 1
    -- local target = selectors.assetsSelector.objs[audio_index]
    -- print(target.text)
    -- target:dispatchEvent({name="tap", target=target})

  local assetTable = require("editor.asset.assetTable")
  assetTable.objs[2]:touch({phase="ended"})


  -- local fileInSandbox = controller:renderAssets(book, page)

  --[[
    selectors.componentSelector:onClick(true,  "audioTable")
  --]]


end

--[[
  function M.test_new_group()
    selectors.componentSelector:onClick(true,  "groupTable")
  end
--]]

--[[
  function M.test_new_timer()
    selectors.componentSelector:onClick(true,  "timerTable")
  end
--]]

--[[
  function M.test_new_variable()
    selectors.componentSelector:onClick(true,  "variableTable")
  end
--]]

--[[
  function M.test_new_action()
    selectors.componentSelector:onClick(true,  "actionTable")
  end
--]]

--[[
  function M.test_cacnel()
    timer.performWithDelay(1000, function()
     local button = "cancel"
      local obj = require("editor.parts.buttons").objs[button]
      obj:tap()
    end)
  end
--]]

return M
