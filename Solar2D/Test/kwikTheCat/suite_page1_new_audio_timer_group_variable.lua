local M = require("Test.base_suite").new({
  component = "iconOnly"
})

local helper = require("Test.helper")

local book = "book"
local page = "portrait"

function M.xtest_new_audio()

  local controller = require("editor.controller.index")
  controller.view = {UI = M.UI}
  M.selectors.componentSelector:onClick(true,  "audioTable") --isVisible = true

  -- click the icon for creatign a new audio
  M.UI.scene.app:dispatchEvent {
    name = "editor.selector.selectAudio",
    UI = M.UI,
    class = "audio",
    isNew = true, --(name ~= "Trash-icon"),
    isDelete =false -- (name == "Trash-icon")
  }

  M.selectors.assetsSelector:show()
  M.selectors.assetsSelector:onClick(true, "audios") --isVisible = true
    -- local audio_index = 1
    -- local target = selectors.assetsSelector.objs[audio_index]
    -- print(target.text)
    -- target:dispatchEvent({name="tap", target=target})

  local assetTable = require("editor.asset.assetTable")
  assetTable.objs[2]:touch({phase="ended"})

  -- local fileInSandbox = controller:renderAssets(book, page)

  --[[
    M.selectors.componentSelector:onClick(true,  "audioTable")
  --]]

end

--[[
  function M.test_new_group()
    M.selectors.componentSelector:onClick(true,  "groupTable")
  end
--]]

function M.xtest_new_timer()
  M.selectors.componentSelector:onClick(true,  "timerTable")
  helper.clickIconObj(M.timerTable, "timers-icon")
  M.picker:continue("timer1")

  -- timer.performWithDelay(3000, function()
  --   helper.clickProp(actionbox.objs, "onComplete")
  --   helper.clickButton("New", actionboxButtonContext)
  -- end)

--  helper.selectActionGroup("Controls")
end

function M.test_select_timer()
  M.selectors.componentSelector:onClick(true,  "timerTable")
  -- helper.clickIconObj(timerTable, "timers-icon")
  -- picker:continue("timer1")
end
--[[
  function M.test_new_variable()
    M.selectors.componentSelector:onClick(true,  "variableTable")
  end
--]]

--[[
  function M.test_new_action()
    M.selectors.componentSelector:onClick(true,  "actionTable")
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
