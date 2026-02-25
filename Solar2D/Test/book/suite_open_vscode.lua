local M = require("Test.base_suite").new({
  selectApp = true,
  book = "bookFree"
})

local helper = require("Test.helper")

local muiName = "editor.action.commandView-"

--

----
---
function M.xtest_vscode_layer_index()
  local page = "page4"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    -- UI.page = "page4"
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    --
    -- commands.openEditorForLayer("bookFree", "page1", "index")
    --
    for i, obj in next, M.selectors.componentSelector.objs do
      if obj.text == "Layer" then
        obj:dispatchEvent{name= "mouse", target=obj, isSecondaryButtonDown=true, x = obj.x, y = obj.y}
        break
      end
    end

    helper.clickButton("openEditor")

    -- selectorBase.lua createSelection to have mouse hover handler
    --
  end
end

function M.xtest_vscode_layer()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    --
    -- commands.openEditorForLayer("bookFree", "page1", "title")
    --
    -- parts/layerTableCommands.lua
    --
    local name = "title"
    -- layerTable.altDown = true
    helper.selectLayer(name)
    helper.selectLayer(name, nil, true) -- isRightClick true
    helper.clickButton("openEditor")
  end
end

function M.xtest_vscode_class()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    --
    -- commands.openEditorForLayer("bookFree", "page1", "title", "linear")
    --
    -- parts/layerTableCommands.lua
    --
    local name = "title"
    local class = "linear"
    -- layerTable.altDown = true
    helper.selectLayer(name, class, false) -- isRightClick false
    helper.selectLayer(name, class, true) -- isRightClick true
    helper.clickButton("openEditor")
    -- layerTable.altDown = false
  end
end

function M.xtest_multi_edit()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "layerTable")
    ---
    M.layerTable.controlDown = true
    ---
    local names = {"title", "gotoBtn", "bg"}
    for i, name in next, names do
      helper.selectLayer(name)
      helper.selectLayer(name, nil, true) -- isRightClick true
    end
    M.layerTable.controlDown = false
    ---
    helper.clickButton("openEditor")
  end
end

function M.xtest_vscode_command()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "actionTable")
    ---
    -- commands.openEditorForCommand("bookFree", "page1", "eventOne")
    --
    -- action/actionTable.lua
    --
    helper.selectAction("eventOne")
    helper.selectAction("eventOne", true) -- isRightClick
    helper.clickButton("openEditor")
  end
end

function M.xtest_vscode_command_multi()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "actionTable")
    ---
    -- commands.openEditorForCommand("bookFree", "page1", "eventOne")
    --
    -- action/actionTable.lua
    --
    M.actionTable.controlDown = true
    helper.selectAction("eventOne")
    helper.selectAction("eventTwo")
    helper.selectAction("eventOne", true) -- isRightClick
    M.actionTable.controlDown = false
    helper.clickButton("openEditor")
  end
end

function M.xtest_vscode_audio()
  local page = "page3"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "audioTable")
    --
    -- commands.openEditor("bookFree", "page3", "audios/long", "GentleRain")
    --
    -- audio/audioTable.lua newAudio()
    --
    M.audioTable.controlDown = true
    helper.selectAudio("GentleRain")
    helper.selectAudio("Tranquility")
    helper.selectAudio("Tranquility", true) -- isRightClick
    M.audioTable.controlDown = false
    helper.clickButton("openEditor")
  end
end

--
-- To be specified
--
-- group/timer/variable uses baseTable.lua
--   baseTable is used for assetTable and pageTable too,
--     vscode to open asset folder, and App/components?
-- multi sections?
--

function M.xtest_vscode_group()
  local page = "page4"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "groupTable")
    -- commands.openEditor("bookFree", "page4", "groups", "myGroup")
  end
end

function M.xtest_vscode_timer()
  local page = "pageTimer"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "timerTable")
    -- commands.openEditor("bookFree", "pageTimer", "timers", "timerOne")
  end
end

function M.xtest_vscode_variable()
  local page = "pageVariable"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.componentSelector:onClick(true,  "variableTable")
    -- commands.openEditor("bookFree", "pageVariable", "variables", "varOne")
    M.variableTable.controlDown = true
    helper.selectVariable("varOne")
    helper.selectVariable("varTwo")
    helper.selectVariable("varTwo", true) -- isRightClick
    M.variableTable.controlDown = false
    helper.clickButton("openEditor")
  end
end
--
-- assets folder is opened in Finder
--- multi select and new from assetTable, edit/delete/vscode are not supported so it opens asset folder in Finder instead
--
function M.xtest_finder_asset()
  local page = "page1"
  M.pageTable.commandHandler({page=page},nil,  true)
  M.UI.testCallback = function()
    M.selectors.componentSelector.iconHander()
    M.selectors.assetsSelector:show()

    -- local video_index = 5
    -- local target = selectors.assetsSelector.objs[video_index]
    -- target:dispatchEvent({name="tap", target=target})

    local audio_index = 1
    local target = M.selectors.assetsSelector.objs[audio_index]
    target:dispatchEvent({name="tap", target=target})

    M.assetTable.controlDown = true
    helper.selectAsset("alphabet/a.mp3")
    helper.selectAsset("alphabet/b.mp3")
    helper.selectAsset("alphabet/b.mp3", true) -- isRightClick
    M.assetTable.controlDown = false
    helper.clickButton("openEditor")

  end

end

function M.xtest_vscode_pageTable()
end

function M.xtest_vscode_bookTable()
end
------
return M
