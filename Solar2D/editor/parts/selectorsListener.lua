local name = ...
local parent,root, M = newModule(name)

local bt = require(root .. "controller.BTree.btree")
local tree = require(root .. "controller.BTree.selectorsTree")
local buttons  = require("editor.parts.buttons")

local function componentHandler(UI, storeTable)
  -- each table will be reset
  --
  UI.editor.layerStore:set({})
  UI.editor.audioStore:set(nil)
  UI.editor.actionStore:set(nil)
  UI.editor.groupStore:set(nil)
  UI.editor.timerStore:set(nil)
  UI.editor.variableStore:set(nil)

  tree:setConditionStatus("select audio", bt.FAILED)
  tree:setConditionStatus("select group", bt.FAILED)
  tree:setConditionStatus("select timer", bt.FAILED)
  tree:setConditionStatus("select variable", bt.FAILED)

  --
  --
  if storeTable then
    -- should we show the last secection?
    if storeTable == "layerTable" then
      UI.editor.layerStore:set(UI.scene.model.components.layers)
    elseif storeTable == "audioTable" then
      UI.editor.audioStore:set(UI.scene.model.components.audios)
    elseif storeTable == "groupTable" then
      UI.editor.groupStore:set(UI.scene.model.components.groups or {})
    elseif storeTable == "timerTable" then
      print(storeTable, #UI.scene.model.components.timers)
      UI.editor.timerStore:set(UI.scene.model.components.timers)
    elseif storeTable == "variableTable" then
      UI.editor.variableStore:set(UI.scene.model.components.variables)
    elseif storeTable == "actionTable" then
      UI.editor.actionStore:set(UI.scene.model.commands)
    end
    -- UI.editor.groupStore:set(UI.scene.model.components.groups)
    -- UI.editor.timerStore:set(UI.scene.model.components.timers)
    -- UI.editor.variableStore:set(UI.scene.model.components.variables)
  else
    UI.editor.layerStore:set(UI.scene.model.components.layers)
  end
  --
end
--
-- these OnClick functions are called back from the icons
--
function M:addListener(UI, buttons, propsTable)
  local projectPageSelector = self.projectPageSelector
  local componentSelector   = self.componentSelector
  local assetsSelector      = self.assetsSelector
  -- The icon click callback
  function self.componentSelector:onClick(isVisible, storeTable)
    -- print("componentSelector", isVisible)
    -- for i=1, #UI.scene.model.components.layers do
      -- for k, v in pairs(UI.scene.model.components.layers[i]) do print(k, v) end
    -- end
    --
    buttons:hide()
    if isVisible then
      projectPageSelector:hide()
      assetsSelector:hide()
      assetsSelector.iconObj.isVisible = true
      propsTable:hide()
      -- for k, tool in pairs(UI.editor.editorTools) do
      --   -- print("hiding", k)
      --   tool:hide()
      -- end
      componentHandler(UI, storeTable, tree)
      if not UI.editor.toolbar.isVisible  then
          UI.editor.toolbar:show()
        UI.editor.actionIcon.isVisible = true
        -- local width = UI.editor.toolbar:getWidth()
        -- self.assetsSelector.iconObj:move(width)
      end
    end
    --
  end

  -- The icon click callback
  function self.projectPageSelector:onClick(isVisible, storeTable)
    -- print("projectPageSelector", isVisible)
    buttons:hide()
    if isVisible then
      componentSelector:hide()
      assetsSelector:hide()
      assetsSelector.iconObj.isVisible = false
      for k, tool in pairs(UI.editor.editorTools) do
        --print(k, tool.id)
        tool:hide()
      end
      if UI.editor.toolbar.isVisible then
        UI.editor.toolbar:hide()
        -- UI.editor.actionIcon.isVisible = false
        -- local width = UI.editor.toolbar:getWidth()
        -- self.assetsSelector.iconObj:reset(width)
      end
      UI.scene.app:dispatchEvent {
            name = "editor.selector.selectApp",
            UI = UI,
            appFolder = system.pathForFile("App", system.ResourceDirectory), -- default
            useTinyfiledialogs = false -- default
          }
    end
    if storeTable == "bookTable" then
      -- new book
    elseif storetable =="pageTable" then
      -- new page
    end
  end

  function self.assetsSelector:onClick(isVisible, assetName)
    -- print("", UI.editor.currentBook, assetName)
    -- UI.editor.assetStore:set{{}}
    if isVisible then
      componentSelector:hide()
      UI.editor.assets = require("editor.asset.index").controller:read(UI.editor.currentBook)
      --
      tree:setConditionStatus("select asset props", bt.FAILED)
      tree:setConditionStatus("add asset", bt.FAILED)
      tree:setConditionStatus("modify asset", bt.FAILED)
      tree:setConditionStatus("delete asset", bt.FAILED)
      --
      if assetName then
        UI.editor.assetStore:set({class = assetName, decoded = UI.editor.assets[assetName]})
      else
        UI.editor.assetStore:set({decoded = UI.editor.assets})
      end
    else
      UI.editor.assetStore:set({})
    end

  end
end

function M:selectComponent(name)
  for i, v in next, self.componentSelector.objs do
    print("##", v.text)
    if v.text == name then
      v:dispatchEvent{name="tap", target=v}
      return
    end
  end
end

-- local posX = display.contentCenterX*0.75
local menuSet = table:mySet{"selectBook", "selectPage", "selectLayer", "selectAudio", "selectGroup", "selectTimer", "selectVariable", "selectAction"}
function M.mouseHandler(event)
  if event.isSecondaryButtonDown then
    print(event.target.command)
    if menuSet[event.target.command] then
       buttons:showContextMenu(event.x+20, event.y-10,
        {type=event.target.text, selections=selections or {},
        contextMenu = {"create"}})
    end
  else
    -- print("@@@@not selected")
  end
  return true
end

--[[
  local function mouseHandlerComponent(event)
    if event.isSecondaryButtonDown then
      local editor = require("editor.index")
      -- print("@@@@ selected")
      editor.selections = {"index"}
      editor.selection = "index"
      buttons:showContextMenu(posX, event.y)
    else
      -- print("@@@@not selected")
    end
    return true
  end
--]]


return M