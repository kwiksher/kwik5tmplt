local Class, M = {}, {}
M.name = ...
M.weight = 1

local parent = M.name:match("(.-)[^%.]+$")
local root = parent:sub(1, parent:len()-1):match("(.-)[^%.]+$")

---
local muiIcon = require("components.mui.icon").new()
local util = require("lib.util")
local mui = require("materialui.mui")
local muiData = require("materialui.mui-data")

local widget = require("widget")

local bt = require(root..'controller.BTree.btree')
local tree = require(root.."controller.BTree.selectorsTree")

local option = {
  text = "",
  x = 20,
  y = 0,
  width = 30,
  height = 20,
  font = native.systemFont,
  fontSize = 8,
  align = "left"
}

---
function M:init(UI)
end
--
function M:create(UI)
  -- print("create", self.name)
  if self.rootGroup then return end
  self.rootGroup = UI.editor.rootGroup

  self.iconHander = function()
    local isVisible = self.isVisible
    self:onClick(not isVisible)
    if not isVisible then self:show() else self:hide()  end
  end

  local selectorIcon = muiIcon:create {
    icon = {self.iconName.."_over", self.iconName.."_over", self.iconName.."_over"},
    text = "",
    name = self.iconName.."-icon",
    x = self.x,
    y = self.y,
    width = 22,
    height = 22,
    fontSize =16,
    listener = self.iconHander
  }

  self.iconObj = selectorIcon


  --
  local commandHandler = function(event)
    -- print( "editor.selector." .. event.command, self.UI.page)
    if not event.btree then
      -- tree:setConditionStatus(event.btree, bt.SUCCESS)
      --
      -- entries of xxxTable
      -- then BTree will activate an actio node.
      --
      -- print("", "no event.btree")
      UI.scene.app:dispatchEvent{
          name = "editor.selector." .. event.command,
          UI = self.UI, -- beaware UI is belonged to a page
          show = not event.isVisible
        }
    end

  end

  option.parent = self.rootGroup

  local function newText(option)
    local obj=display.newText(option)
    obj:setFillColor( 0 )
    return obj
  end

  self.objs = {}
  local createSelection = function(event)
    for index=1, #self.rows do
      local row = self.rows[index]
      option.text =  row.label
      option.y = (self.marginY or 0) + option.height * (index)  - option.height/2 + 22
      -- option.y = option.height * (index) + (display.actualContentHeight-1280/4 )/2 - option.height/2
      --
      option.x = self.marginX or option.x
      option.width = self.optionWidth or option.width
      --
      local rect = display.newRect(self.rootGroup,option.x, option.y, option.width+18,option.height)
      rect:setFillColor(0.8)
      --
      local obj = newText(option)
      obj.command = row.command
      -- if row.command and row.btree == nil then
      --   obj.tap = commandHandler
      --   obj:addEventListener("tap", obj)
      if row.store  then
        obj:addEventListener("tap", function(event)
          if self.lastSelection then
            self.lastSelection:setFillColor(0.8)
          end
          event.target.rect:setFillColor(0,1,0)
          -- print(obj.text)
          self:onClick(true, row.store)
          self.lastSelection = event.target.rect
          end)
      else
        obj:addEventListener("tap", function(event)
          print("tap", row.command, UI.scene.app)
          UI.scene.app:dispatchEvent{
            name = "editor.selector." .. row.command,
            UI = UI, -- beaware UI is belonged to a page
            show = true
          }
        end)
      end

      if self.mouseHandler then
        obj:addEventListener("mouse", self.mouseHandler )
      end

      obj.rect = rect
      obj.btree = row.btree
      self.rootGroup[row.command] = obj
      if row.filter then
        -- filter
        obj.filter = self.filter:create(UI, obj.contentBounds.xMax, obj.y)
        self.rootGroup:insert(obj.filter)
      end
      self.objs[#self.objs + 1] = obj
    end
  end
  createSelection() -- create but do not show panel demo
  --
  function self:show ()
    -- print("@@@ show @@@", self.iconName)
    for k, row in pairs(self.rows) do
      self.rootGroup[row.command].isVisible = true
      self.rootGroup[row.command].rect.isVisible = true
      if row.filterSelector then
        self.rootGroup[row.command].filterSelector.isVisible = true
      end
      -- print("", row.store)
      if row.store and self.rootGroup[row.store] then
        self.rootGroup[row.store].isVisible = true
        -- for j, obj in pairs(self.rootGroup[row.store]) do
        --   obj.isVisible = true
        --   if obj.rect then
        --     obj.rect.isVisible = true
        --   end
        -- end
      end
    end
    if self.filter then
      self.filter:show()
    end
    if self.propsTable then
      self.propsTable:show()
     -- self.propsButtons:show()
    end
    self.isVisible = true
  end
  --
  function self:hide()
    for k, row in pairs(self.rows) do
      self.rootGroup[row.command].isVisible = false
      self.rootGroup[row.command].rect.isVisible = false
      if row.filterSelector then
        self.rootGroup[row.command].filterSelector.isVisible = false
      end
      -- print("row.store", row.store)
      if row.store and self.rootGroup[row.store] then
        -- print("", "isVisible false")
        self.rootGroup[row.store].isVisible = false
        -- for j, obj in pairs(self.rootGroup[row.store]) do
        --   obj.isVisible = false
        --   if obj.rect then
        --     obj.rect.isVisible = false
        --   end
        -- end
      end
    end
    if self.filter then
      self.filter:hide()
    end
    if self.propsTable then
      self.propsTable:hide()
      self.propsButtons:hide()
    end
    self.isVisible = false
  end

  -- self:hide()

end
--
function M:didShow(UI)
  self.UI = UI
  if self.filter then
    self.filter:didShow(UI)
  end
end
--
function M:didHide(UI)
  if self.filter then
    self.filter:didHide(UI)
  end
end
--
function M:destroy()
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].rect:removeSelf()
      self.objs[i]:removeSelf()
      if self.objs[i].filter then
        self.objs[i].filter:removeSelf()
      end
    end
  self.objs = nil
  end
end
--
--
function Class.new(UI, x,y, rows, iconName, filter, propsTable, propsButtons, mouseHandler)
  local instance = {}
  instance.x = x
  instance.y = y
  --
  instance.rows = rows
  instance.iconName = iconName
  instance.filter = filter
  instance.propsTable = propsTable
  instance.propsButtons = propsButtons
  instance.height = #rows*option.height
  instance.isVisible = false
  instance.mouseHandler = mouseHandler
  return setmetatable(instance, {__index=M})
end
--
return Class
