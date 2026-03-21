local M = require("Test.base_suite").new({
  book = "page",
  page = "audio"
})

local muiName = "editor.action.commandView-"
local helper = require("Test.helper")

function M.xtest_readAssets()
  M.selectors.componentSelector.iconHander()
  M.selectors.assetsSelector:iconHander()
  M.selectors.assetsSelector:onClick(true, "audios")
end

function M.xtest_select_audio()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "audioTable")
    local audioTable = require("editor.audio.audioTable")
    local obj = audioTable.objs[1]
    obj:touch{phase="ended"}
end

function M.xtest_new_component()
  M.selectors.componentSelector.iconHander()
  M.selectors.componentSelector:onClick(true,  "audioTable")
  local audioTable = require("editor.audio.audioTable")
  local obj = audioTable.objs[1]
  obj:touch{phase="ended"}
  ---
  -- local buttons = require("editor.audio.buttons")
  -- buttons.objs["save"].tap{eventName="save"}

    -- local assetbox = require("editor.parts.assetbox")
    -- local obj = assetbox.objs[2]
    -- obj:tap({numTaps = 1})
    -- assetbox:scrollToPosition()

    -- TODO input new Name
    -- local obj = audioTable.objs[1]
    -- obj:touch{phase="ended"}
    -- ---
    -- local buttons = require("editor.audio.buttons")
    -- buttons.objs["save"].tap{eventName="save"}
end

function M.xtest_new_component_from_asset()
  M.selectors.componentSelector.iconHander()

  M.selectors.assetsSelector:show()
  M.selectors.assetsSelector:onClick(true, "audios")

  timer.performWithDelay( 1000, function()
    local assetTable = require("editor.asset.assetTable")
    local obj = assetTable.objs[1]
    obj:touch{phase="ended"}

    -- local buttons = require("editor.asset.buttons")
    -- buttons.objs["save"].tap{eventName="save"}
  end)

end

function M.xtest_new_action()
  M.UI.editor.actionEditor.iconHander()
  M.actionTable.newButton:tap{target=M.UI.editor.newButton}
end

function M.xtest_select_action()
  local actionName = "eventAudio"
  local actionCategory = "Audio"
  --
  local editor = require("editor.action.index")
  M.selectors.componentSelector:onClick(true,  "actionTable")
  helper.actionTable = M.actionTable
  M.actionTable.altDown = true
  helper.clickAction(actionName)
  M.actionTable.altDown = false

  local muiName = "action.commandView-"
-- local actionTable = require("editor.action.actionTable")
  local controller = require("editor.action.controller.index")
  -- Action is muiIcon
  controller.commandGroupHandler{target={muiOptions={name=muiName..actionCategory}}}
end

return M
