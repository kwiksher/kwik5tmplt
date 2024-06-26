local name = ...
local parent, root = newModule(name)
local util = require("editor.util")


local M = {} -- layerTable
local bt = require(root .. "controller.BTree.btree")
local tree = require(root .. "controller.BTree.selectorsTree")

local propsTable              = require(parent .. "propsTable")
local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
local classProps              = require("editor.parts.classProps")
local buttons                 = require("editor.parts.buttons")

local posX = display.contentCenterX*0.75

local isLastSelection = "class"

function M.mouseHandler(event)
  if event.isSecondaryButtonDown and event.target.isSelected then
    --for k,v in pairs(event) do print(k, v) end
    -- print("@", event.target.text, event.isSecondaryButtonDown)
    -- local posX, posY = event.target:localToContent(event.target.x, event.target.y)
    -- local posX, posY = event.target:contentToLocal(event.x, event.y)
    -- local posX, posY = event.target:localToContent(event.x, event.y)
    -- print(posX, posY)
    buttons:showContextMenu(posX, event.y)
    -- buttons:showContextMenu(posX, posY)
  else
    -- print("@@@@not selected")
  end
  return true
end

local function clearSelections(layerTable, current)
  if isLastSelection ~= current then
    for i, v in next, layerTable.selections do
      v.isSelected = false
      v.rect:setStrokeColor(0.8)
      v.rect:setFillColor(0.8)
    end
  end
  isLastSelection = current
end

local function multiSelections(layerTable, target)
  if not target.isSelected then
    layerTable.selections[#layerTable.selections + 1] = target
    target.isSelected = true
    -- target.rect:setFillColor(0, 1, 0)
    target.rect:setStrokeColor(0, 1, 0)
  else
    target.isSelected = false
    -- target.rect:setFillColor(0.8)
    target.rect:setStrokeColor(0.8)
    for i, v in next, layerTable.selections do
       if v == target then
        table.remove(layerTable.selections, i)
        break
       end
    end
    layerTable.selection = nil
  end
end

local function singleSelection(layerTable, target)
  local UI = layerTable.UI
  if layerTable.selection == target and target.isSelected then
    -- print("let's toogle")
    target.isSelected = false
    target.rect:setFillColor(0.8)
    for i, v in next, layerTable.selections do
       if v == target then
        table.remove(layerTable.selections, i)
        break
       end
    end
    layerTable.selection = nil
  else
    layerTable.selection = target
    for i = 1, #layerTable.selections do
      layerTable.selections[i].rect:setFillColor(0.8)
      layerTable.selections[i].rect:setStrokeColor(0.8)
    end
    --
    layerTable.selections = {target}
    target.isSelected = true
    -- target.rect:setFillColor(0,1,0)
    target.rect:setStrokeColor(0, 1, 0)
    ---
    UI.editor.currentLayer = target.layer
    -- target.isSelected = true
    UI.editor.currentClass = target.name
    return true
    --
  end
end

local function showLayerProps(layerTable, target)
  local UI = layerTable.UI
  local path = util.getParent(target)

  if layerTable.selection == target then
    -- let's toogle
    -- target.isSelected = false
    if propsTable.isVisible then
      -- print("", "hide")
      target:setFillColor(0)
      propsTable:hide()
    else
      target.rect:setFillColor(0, 1, 0)
      propsTable:show()
      return true
    end
  else
    layerTable.selection = target
    for i = 1, #layerTable.selections do
      layerTable.selections[i].rect:setFillColor(0.8)
    end
    layerTable.selections = {target}
    target.isSelected = true
    target.rect:setFillColor(0, 1, 0)
    return true
  end
end

local function showFocus(layerTable)
  local UI = layerTable.UI
  if UI.editor.focusGroup then
    UI.editor.focusGroup:removeSelf()
  end
  local group = display.newGroup()
  UI.sceneGroup:insert(group)
  UI.editor.focusGroup = group
  --
  for i, v in next, layerTable.selections do
    local obj = UI.sceneGroup[v.text]
    if obj then
      print("@", v.text, obj.x, obj.y)
      local posX, posY = obj.x, obj.y
      local rect = display.newRect(UI.editor.focusGroup, posX, posY, obj.width, obj.height)
      rect:setFillColor(1, 0, 0, 0)
      rect:setStrokeColor(0, 1, 0)
      rect.strokeWidth = 1
      rect.xScale = obj.xScale
      rect.yScale = obj.yScale
      rect.anchorX = obj.anchorX
      rect.anchorY = obj.anchorY
      rect.rotation = obj.rotation
      transition.from(rect, {time=100, xScale=3, yScale=3})
    end
  end
end

function M.commandHandler(layerTable, target, event)
  if event.phase == "began" or event.phase == "moved" then
    return true
  end
  local  UI = layerTable.UI
  local path = util.getParent(target)
  --
  clearSelections(layerTable, "layer")
  --
  buttons:hide()
  ---
  print("@@@@@@", layerTable.altDown, layerTable:isAltDown())
  -- print(debug.traceback())
  if layerTable:isAltDown() then
    if showLayerProps(layerTable, target) then
      --
      tree.backboard = {
        layer = target.layer,
        path = path
        -- class = target.class
      }
      print("###", target.layer)
      tree:setConditionStatus("select layer", bt.SUCCESS, true)
      tree:setActionStatus("load layer", bt.RUNNING, true)
      tree:setConditionStatus("select props", bt.SUCCESS)
      UI.editor.currentLayer = target.layer
      -- UI:dispatchEvent {
      --   name = "editor.selector.selectLayer",
      --   UI = UI,
      --   layer = target.layer,
      --   class = target.class
      -- }
      --
    end
  elseif layerTable:isControlDown() then -- mutli selections
    print("multi selection")
    multiSelections(layerTable, target)
  else
    if singleSelection(layerTable, target) then
      -- should we enable one of them?
        actionCommandPropsTable:setActiveProp(target.layer)
        classProps:setActiveProp(target.layer)
    end
  end
  --
  -- focus
  --
  showFocus(layerTable)
  --
  UI.editor.selections = layerTable.selections
  return true
end

local function showClassProps(layerTable, target)
  local UI = layerTable.UI
  local path = util.getParent(target)
  if layerTable.selection == target then
    print("let's toogle")
    -- target.isSelected = false

    target.rect:setFillColor(0.8)
    UI.scene.app:dispatchEvent {
      name = "editor.selector.selectTool",
      UI = UI,
      class = target.class,
      isNew = false,
      layer = target.layer,
      toogle = true -- <========
    }
  else
    layerTable.selection = target
    for i = 1, #layerTable.selections do
      layerTable.selections[i].rect:setFillColor(0.8)
    end
    --
    layerTable.selections = {target}
    target.isSelected = true
    target.rect:setFillColor(0,1,0)
    UI.editor.currentLayer = target.layer
    --
    -- target.isSelected = true
    UI.editor.currentClass = target.name
    -- for load layer
    tree.backboard = {
      layer = target.layer,
      class = target.class,
      path = path
    }
    tree:setConditionStatus("select layer", bt.SUCCESS, true)
    tree:setActionStatus("load layer", bt.RUNNING) -- need tick to process load layer with tree.backboard
    tree:setConditionStatus("select props", bt.FAILED, true)

    -- For editor compoent. this fires selectTool event with backboard params
    tree.backboard = {
      class = target.class,
      isNew = false,
      layer = target.layer,
      path = path
    }
    tree:setConditionStatus("modify component", bt.SUCCESS)
    tree:setActionStatus("editor component", bt.RUNNING, true)
  end
end

function M.commandHandlerClass(layerTable, target, event)
  local UI = layerTable.UI
  if event.phase == "began" or event.phase == "moved" then
    return
  end
  --
  clearSelections(layerTable, "class")
  --
  buttons:hide()
  --
  if layerTable:isAltDown() then
    showClassProps(layerTable, target)
  elseif layerTable.isControlDown() then -- mutli selections
    multiSelections(layerTable, target)
  else
    if singleSelection(layerTable, target) then
      actionCommandPropsTable:setActiveProp(target.layer, target.class)
      classProps:setActiveProp(target.layer, target.class)
    end
  end
  UI.editor.selections = layerTable.selections
  return true
end
--
-- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectTool",
  --   UI = UI,
  --   class = target.class,
  --   isNew = false,
  --   layer = target.layer
  -- }

  --[[

     print("==== cond")
     tree.tree.conditions:forEach(function(____, c)
       for i=1, #c do
         if c[i].nodeStatus == 1 then
           print("", c[i].name)
         end
       end
     end)

     print("==== action")
     tree.tree.actions:forEach(function(____, a)
       for i=1, #a do
         if a[i].nodeStatus > 0 then
           -- for k, v in pairs(a[i]) do
           --   print("",k, v)
           -- end
           print("", a[i].name, a[i].nodeStatus, a[i]._active)
         end
       end
     end)
     --]]
--
M.singleSelection = singleSelection
M.clearSelections = clearSelections
M.multiSelections = multiSelections
M.showLayerProps = showLayerProps

return M
