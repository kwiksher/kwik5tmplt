name = ...
local parent,root = newModule(name)
local M = {name = name, views = {
  "index", -- this creates actionIcon button
  "selector", -- context:mapCommands "selectAction", "selectActionCommand"
  "actionTable", -- lists actions in a page
  "actionCommandTable",
  "actionCommandPropsTable",
  "commandbox", -- animation.play, pause, ..
  "buttons",
  "actionCommandButtons"
}}

M.weight = 1
---
local muiIcon = require("components.mui.icon").new()
local util    = require("lib.util")
local mui     = require("materialui.mui")
local muiData = require("materialui.mui-data")
---
local models         = require(parent.."model").menu
local controller     = require(parent.."controller.index")
local commandView    = require(parent.."commandView")
local selectbox      = require(root.."parts.selectbox"):newInstance()
local toolbar        = require(root .."parts.toolbar")
selectbox.name = "actionName"
selectbox.create = function(UI) end -- see createSelectbox below

function M:init(UI)
end

M.commandMap = {}
  -- local acton = {"command":"audio.play", "params":{
  --   "target" : "bgm",
  --   "type" : "",
  --   "channel" : "",
  --   "repeatable" : true,
  --   "delay" : "",
  --   "loop" : -1,
  --   "fade" : "",
  --   "volume" : "",
  --   "trigger" : "eventTwo"
  -- }}

local function newText(option)
  local obj = display.newText(option)
  obj:setFillColor(0)
  return obj
end

function M.iconHander()
  local self = M
  self.isVisible = not self.isVisible
    if self.isVisible then
      self:show()
    else
        self:hide()
    end
end

function M:createIcon(UI, posX, posY)
  local actionIcon = muiIcon:create {
    icon     = {"actions_over", "actions_over","actions_over"},
    text     = "",
    name     = "action-icon",
    x        = posX,
    y        = posY,
-- y        = (display.actualContentHeight - display.contentHeight)/2 -2,
    width    = 22,
    height   = 22,
    fontSize = 16,
    listener = self.iconHander,
    fillColor = {1.0}
  }
  UI.editor.actionIcon = actionIcon
  actionIcon.isVisible = false
  UI.editor.rootGroup:insert(actionIcon)
end

function M:createSelectbox(UI, posX, posY)
  -- UI.editor.viewStore = self.group -- used in selecbox:create()
  selectbox:init(UI, posX + 22, posY+24, 96, 22)
  selectbox:setValue(
    {
      {name="new-action", class="action"},
      -- {name="new-action2", class="action"}
    }
    , 1)
    selectbox:create(UI)
    -- selectbox:hide()
  -- selectbox.scrollView:scrollToPosition{y=-22}
  self.selectbox = selectbox

  self.selectbox.classEditorHandler = function(decoded, index)
  end

  self.selectbox.useClassEditorProps = function()
    return {}
  end
end


--
function M:create(UI)
  -- if self.group then return end
  self.UI = UI
  self.group = display.newGroup()
  --
  controller:init(UI, self.commandMap, selectbox)
  -- print("create", self.name)
  local posX, posY = toolbar:getWidth() + 36, -2 --display.contentCenterX/2 + 42, -2
  -----------------------------------------
  self:createIcon(UI, posX, posY)
  -----------------------------------------
  self:createSelectbox(UI, posX, posY)
  -----------------------------------------
  local scrollView = commandView:createTable(models, self.commandMap, self.group, UI.editor.rootGroup.selectLayer)
  self.group:insert(scrollView)
  -----------------------------------------
  UI.editor.actionEditor = self
  self.group.commandView = scrollView
  UI.editor.viewStore.commandView = scrollView
  --
  self:hide()
  -- self:show()

  if system.orientation == "portrait" then
    local delta_x = 400
    self.group:translate(delta_x, 0)
    -- if self.group.propsTable then
    --   self.group.propsTable:translate(delta_x, 0)
    -- end
  else
    local delta_x = 400
    self.group:translate(delta_x/2, 0)
  end

end

function M:commandViewHandler(name, selectLayer)
  if commandView.activeEntry == name then
    commandView.activeEntry = nil
  else
    commandView.activeEntry = name
  end
  self.group.commandView:removeSelf()
  local scrollView = commandView:createTable(scrollView, models, self.commandMap, self.group, selectLayer)
  self.group:insert(scrollView)
  self.group.commandView = scrollView
end
-----------------------------------------
function M:show()
  controller:show()
  self.isVisible = true
end

function M:hide(cancel)
  controller:hide()
  self.isVisible = false
end

function M:hideCommandPropsTable()
  local UI = self.UI
  UI.editor.viewStore.commandbox:hide()
  UI.editor.viewStore.actionCommandPropsTable:hide()
  UI.editor.viewStore.actionCommandButtons.lastVisible = false
  UI.editor.viewStore.actionCommandButtons:hide()

end
--
function M:didShow(UI)
  self.selectbox:didShow(UI)
end
--
function M:didHide(UI)
  if self.selectbox then
    self.selectbox:didHide(UI)
  end
end
--
function M:destroy(UI)
  if self.selectbox then
   -- self.selectbox:destroy(UI)
  end
end
--
return M
