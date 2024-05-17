local M = {}
M.name = ...
M.weight = 1

local parent,root = newModule(M.name)

local selectorBase = require(parent .. "selectorBase")
local selectLayerFilter = require(parent .. "selectLayerFilter")
local propsTable = require(parent .. "propsTable")
local propsButtons = require(parent .. "propsButtons")

local bookTable = require(parent.."bookTable")
local pageTable = require(parent.."pageTable")
local layerTable = require(parent.."layerTable")
--local audioTable = require(parent.."audioTable")
---
local muiIcon = require("components.mui.icon").new()
local util = require("lib.util")
local mui = require("materialui.mui")
local muiData = require("materialui.mui-data")

local bt = require(root .. "controller.BTree.btree")
local tree = require(root .. "controller.BTree.selectorsTree")

local buttons                 = require("editor.parts.buttons")

local widget = require("widget")
---
local function newText(option)
  local obj = display.newText(option)
  obj:setFillColor(0)
  return obj
end

local function showLabels(fooValue, rootGroup)
  local labelBook = newText {
    parent = rootGroup,
    text = fooValue.currentBook or "",
    x = display.contentWidth * 0.75,
    y = 16,
    -- y = (display.actualContentHeight - 1280 / 4) / 2,
    width = nil,
    height = 18,
    font = native.systemFont,
    fontSize = 10,
    align = "center"
  }
  labelBook.anchorY = 1
  labelBook:setFillColor(1)
  --
  local labelPage = newText {
    parent = rootGroup,
    text = "> " .. (fooValue.currentPage or ""),
    x = 10,
    y = 16,
    -- y = (display.actualContentHeight - 1280 / 4) / 2,
    width = nil,
    height = 18,
    font = native.systemFont,
    fontSize = 10,
    align = "center"
  }
  labelPage.anchorY = 1
  labelPage.x = labelPage.width / 2 + labelBook.contentBounds.xMax + 2
  labelPage:setFillColor(1)
  ---
  local labelLayer = newText {
    parent = rootGroup,
    text = "> " .. (fooValue.currentLayer or ""),
    x = 10,
    y = 16,
    -- y = (display.actualContentHeight - 1280 / 4) / 2,
    width = nil,
    height = 18,
    font = native.systemFont,
    fontSize = 10,
    align = "center"
  }
  labelLayer.anchorY = 1
  labelLayer.x = labelPage.contentBounds.xMax + labelLayer.width / 2 + 2
  labelLayer:setFillColor(1)

  -- local rect = display.newRect(labelPage.x, labelPage.y, labelPage.width, labelPage.height)
  -- rect:setFillColor(0.5,0,0,0.5)

  -- local rect = display.newRect(labelLayer.x, labelLayer.y, labelLayer.width, labelPage.height)
  -- rect:setFillColor(0,0.5,0,0.5)

  --
  -- print("", labelBook.text, labelPage.text, labelLayer.text)
  return {labelBook, labelPage, labelLayer}
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


function M:init(UI)
end

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

-- local posX = display.contentCenterX*0.75
local menuSet = table:mySet{"selectBook", "selectPage", "selectLayer", "selectAudio", "selectGroup", "selectTimer", "selectVariable", "selectAction"}
local function mouseHandler(event)
  if event.isSecondaryButtonDown then
    print(event.target.command)
    if menuSet[event.target.command] then
       buttons:showContextMenu(event.x+20, event.y-10,
      {type=event.target.text, selections=selections,
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

--
function M:create(UI)
  -- print("create", self.name)
  if self.rootGroup then return end
  self.rootGroup = UI.editor.rootGroup
  ---
  -- See editor.index.lua registers each select command  to the context
  ---
  self.projectPageSelector =
    selectorBase.new(
    UI,
    11, --self.x
    -2, --self.y
    {
      {label = "", command = "selectBook", store = "bookTable", btree = "select book"},
      {label = "", command = "selectPage", store = "pageTable", btree = "select page"},
      {label = "Project", command = "selectApp"},
      {label = "Settings", command = "selectPageProps"}
    },
    "openProject", --iconName
    nil,
    nil,
    nil,
    mouseHandler
  )

  self.projectPageSelector.optionWidth = 40
  self.projectPageSelector.marginY = 11
  self.projectPageSelector.marginX = 20

  self.componentSelector =
    selectorBase.new(
    UI,
    33, --self.x
    -2, --self.y
    {
      {label = "Layer", command = "selectLayer", store = "layerTable", filter = true, btree = "select layer"},
      {label = "Audio", command = "selectAudio", store = "audioTable", btree = "select component"},
      {label = "Group", command = "selectGroup", store = "groupTable", btree = "select component"},
      {label = "Timer", command = "selectTimer", store = "timerTable", btree = "select component"},
      {label = "Var", command = "selectVariable", store = "variableTable", btree = "select component"},
      {label = "Action", command = "selectAction", store = "actionTable"}
    },
    "toolLayer",
    selectLayerFilter,
    propsTable,
    propsButtons,
    mouseHandler
  )
  self.componentSelector.marginY = 11
  self.componentSelector.marginX = 43

  self.assetsSelector =
  selectorBase.new(
    UI,
    display.contentCenterX, -- self.x
    -2,        -- self.y
    {
      {label = "Audio", command = "selectAudioAsset", store = "audios", btree = "select asset"},
      {label = "Particles", command = "selectPaticlesAsset", store = "paticles", btree = "select asset"},
      {label = "Sprites", command = "selectSpriteAsset", store = "sprites", btree = "select asset"},
      {label = "SyncText", command = "selectSyncTextAsset", store = "aduios.sync", btree = "select asset"},
      {label = "Video", command = "selectVideoAsset", store = "videos", btree = "select asset"},
    },
    "toolAssets",
    nil
  )
  self.assetsSelector.marginX = display.contentCenterX -11
  self.assetsSelector.marginY =  11 -- -12 -- self.componentSelector.height+30
  self.assetsSelector.optionWidth = 48
  self.assetsSelector.width =  60

  --
  self.projectPageSelector:create(UI)
  self.componentSelector:create(UI)
  self.assetsSelector:create(UI)
  --------------
  function self.assetsSelector.iconObj:move(width)
    -- self.x = self.x + width
  end

  function self.assetsSelector.iconObj:reset(width)
    -- self.x = self.x - width
  end
  -------------

  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectLayer",
  --   UI = UI,
  --   show = false
  -- }


  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectAction",
  --   UI = UI
  -- }

  -- timer.performWithDelay( 100, function()
    self.projectPageSelector:hide()
    self.componentSelector:hide()
    self.assetsSelector:hide()
    selectLayerFilter:hide()
  -- end)

  ------
  -- header/footer
  --
  UI.editor.rootGroup:addEventListener("labelStore", function(event)
    self:destroy()
    timer.performWithDelay( 10,
    function()
      if self.objs == nil then
        self.objs = showLabels(event, self.rootGroup)
      end
    end )
  end)
  -- UI.editor.labelStore:listen(
  --   function(foo, fooValue)
  --     print("UI.labelStore")
  --     for k, v in pairs(fooValue) do
  --       print("", k, v)
  --     end
  --     timer.performWithDelay( 1000,
  --     function()
  --       self:destroy()
  --       self.objs = showLabels(fooValue, rootGroup)
  --     end )
  --   end
  -- )
end
--
function M:didShow(UI)
  -- print("---------------- didShow --------------", UI.page)
  self.projectPageSelector:didShow(UI)
  self.componentSelector:didShow(UI)
  self.assetsSelector:didShow(UI)


  -- The icon click callback
  function self.componentSelector:onClick(isVisible, storeTable)
    -- print("componentSelector", isVisible)
    -- for i=1, #UI.scene.model.components.layers do
      -- for k, v in pairs(UI.scene.model.components.layers[i]) do print(k, v) end
    -- end
    --
    buttons:hide()
    if isVisible then
      M.projectPageSelector:hide()
      propsTable:hide()
      -- for k, tool in pairs(UI.editor.editorTools) do
      --   -- print("hiding", k)
      --   tool:hide()
      -- end
      componentHandler(UI, storeTable)
      if not UI.editor.toolbar.isVisible  then
         UI.editor.toolbar:show()
        UI.editor.actionIcon.isVisible = true
        local width = UI.editor.toolbar:getWidth()
        M.assetsSelector.iconObj:move(width)
      end

    end
    --
  end

  -- The icon click callback
  function self.projectPageSelector:onClick(isVisible, storeTable)
    -- print("projectPageSelector", isVisible)
    buttons:hide()
    if isVisible then
      M.componentSelector:hide()
      for k, tool in pairs(UI.editor.editorTools) do
        --print(k, tool.id)
        tool:hide()
      end

      if UI.editor.toolbar.isVisible then
        UI.editor.toolbar:hide()
        UI.editor.actionIcon.isVisible = false

        local width = UI.editor.toolbar:getWidth()
        M.assetsSelector.iconObj:reset(width)
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

  end
end
--
function M:didHide(UI)
  self.projectPageSelector:didHide(UI)
  self.componentSelector:didHide(UI)
end
--
function M:destroy(UI)
  if self.objs then
    for i=1, #self.objs do
      self.objs[i]:removeSelf()
    end
    self.objs = nil
  end
end
--
return M
