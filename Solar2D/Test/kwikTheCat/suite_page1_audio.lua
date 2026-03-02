local M = require("Test.base_suite").new({
  book = "book",
  page = "portrait"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"

function M.test_readAssets()
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
---[[
function M.xtest_radioGroup()
  timer.performWithDelay( 1000, function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "audioTable")
    local audioTable = require("editor.audio.audioTable")

    M.UI.scene.app:dispatchEvent {
      name = "editor.selector.selectAudio",
      UI = M.UI,
      class = "audio",
      isNew = true, --(name ~= "Trash-icon"),
      isDelete =false -- (name == "Trash-icon")
    }
    -- timer.performWithDelay( 1000,
    -- function()
      local assetbox = require("editor.parts.assetbox")
      assetbox.triangle:tap()
      assetbox.onSwitchPress{target = {isOn = true, id="audiolong"}}
      local obj = assetbox.objs[2]
      obj:tap({numTaps = 1})
      assetbox:scrollToPosition()
    -- end )

    -- local buttons = require("editor.audio.buttons")
    -- buttons.objs["save"].tap{eventName="save"}
  end)
end
--]]

function M.xtest_newAction()

  timer.performWithDelay( 1000, function()

    -- UI.scene.app:dispatchEvent {
    --   name = "editor.action.selectAction",
    --   isNew = true, -- isNew?
    --   UI = UI
    -- }

    -- click UI.editor.actionIcon
    --  it dispatches
    local editor = require("editor.action.index")

    M.selectors.componentSelector:onClick(true,  "actionTable")
    M.actionTable.newButton:tap{target=editor.newButton}
    -- selectAction("eventOne")

    -- Audio is muiIcon. This shows audioTable too
    M.actionController.commandGroupHandler{target={muiOptions={name=muiName.."Audio"}}}

    --select play
    local commandEntry = M.commandbox.objs[3] -- should we change 'objs' to 'objs'?
    commandEntry:dispatchEvent{name="tap", target=commandEntry}
    -- select _target
    local objEntry = M.actionCommandPropsTable.objs[1]
     objEntry:dispatchEvent{name="tap", target=objEntry}

    -- select an audio from audio table
    local audioTable = require("editor.audio.audioTable")
    local obj = audioTable.objs[1]
    obj:touch{phase="ended"}

     -- TBI select _trigger
     --  objEntry = actionCommandPropsTable.objs[2]
     --  objEntry:dispatchEvent{name="tap", target=objEntry}

  end)
end

---[[
function M.xtest_action()
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
