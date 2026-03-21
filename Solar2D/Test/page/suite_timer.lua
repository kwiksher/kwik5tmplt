local M = require("Test.base_suite").new({
  book = "page",
  page = "timer"
})

local helper = require("Test.helper")

--[[
  function M.test_readAssets()
    local util = require("editor.util")
    util.readAssets("page", "timer")
  end
--]]

--[[
function M.test_completeBox()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "timerTable")
    local view = require("editor.timer.timerTable")

    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectTimer",
      UI = M.UI,
      class = "timer",
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

    -- list actions in completeBox
    -- select one of them
    -- save

  end)
end
--]]

---[[
function M.xtest_new_component()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "timerTable")
    local view = require("editor.timer.timerTable")

    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectTimer",
      UI = M.UI,
      class = "timer",
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }

    -- list actions in completeBox
    -- select one of them
    -- save
    local buttons = require("editor.timer.buttons")
    buttons.objs["save"].tap{eventName="save"}
  end)
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

function M.xtest_select_timer()
  M.selectors.componentSelector:onClick(true,  "timerTable")
  -- helper.clickIconObj(timerTable, "timers-icon")
  -- picker:continue("timer1")
end


--[[
function M.test_component()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "timerTable")
    local view = require("editor.timer.timerTable")
    local obj = view.objs[1]
    obj:touch{phase="ended"}
    ---
    local buttons = require("editor.timer.buttons")
    buttons.objs["save"].tap{eventName="save"}
  end)
end
--]]

--[[
function M.test_action()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "actionTable")
    M.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = "onComplete",
      UI = M.UI
    }
  end)
end
--]]
return M
