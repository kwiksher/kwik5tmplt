local M = {}
M.name = ...
-- attach drag-item scrollview to widget library
require("extlib.dragitemscrollview")

local utileditor = require("editor.util")
local util = require("lib.util")

local option, newText = util.newTextFactory{
  height = 20,
  -- fontSize = 10,
  anchorX = 0
}

-- load widget library
local widget = require("widget")

function M:getValue()
  return self.objs
end

function M:getLayers()
  return self.layers
end

function M:getSelections()
 return self.selections
end

local function onKeyEvent(event)
  -- Print which key was pressed down/up
  local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  --for k, v in pairs(event) do print(k, v) end
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    print("group", message)
    M.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    M.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    M.shiftDown = true
  end
end

function M:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width= width or 80*2
  self.height=height or 100
  self.selections = {}

end
--
function M:create(UI)
  -- if self.group then return end
  self.group = display.newGroup()
  --UI.editor.viewStore:insert(self.group)

  option.parent = self.group
  option.width = self.width

  self.singleClickEvent = function(obj)
    utileditor.setSelection(self, obj)
  end


  -- create a listener to handle drag-item commands
  local function listener( item, touchevent )
    print(touchevent.id)
    -- if touchevent.pahse == "began" then
    --   item.markX = item.x
    --   item.markY = item.y

    if touchevent.phase  == "ended" then
      -- print("single click event")
      -- this opens a commond editor table
      self.singleClickEvent(item)
    else

      local function touch(e)
        local target = e.target
        --print("@@touch", e.phase, e.target.hasFocus)
        if (e.phase == "began" or target.markX == nil) then
         target.markX, target.markY = target.x, target.y
          --
          -- display.currentStage:insert( target )
          --
          display.currentStage:setFocus( target, e.id )
          target.hasFocus = true

          target.x = e.x - e.xStart + target.markX
          target.y = e.y - e.yStart + target.markY

          return true
        elseif (target.hasFocus) then
          -- print("", target.x, target.y)
          if (e.phase == "moved") then
            target.x = e.x - e.xStart + target.markX
            target.y = e.y - e.yStart + target.markY
          else
            -- print(e.phase, target.x, target.y)
            display.currentStage:setFocus( target, nil )
            target.hasFocus = nil
            self.scrollView:attachListener(target, listener, 100, 20, 20) -- dragtime, angle, radius,(touchthreshold)
            --
            local function compare(a,b)
              return  a.y < b.y
            end

            target.obj.y = target.obj.y + target.y
            table.sort(self.objs,compare)
            local _layers = {}
            for i, v in next, self.objs do
              -- print(i, v.text, v.y)
              _layers[i] = v.text
            end
            -- reset
            UI.editor.groupLayersStore:set{layers=_layers} -- layersTable
            --
          end
          return true
        end
        return false
      end
      --
      item.hasFocus = true
      display.currentStage:setFocus( item, touchevent.id )
      -- print("add")
      item:addEventListener( "touch", touch )
    end
  end

  self.listener = listener


  UI.editor.groupLayersStore:listen(
      function(foo, fooValue)
        local objs = {}
         -- create drag-item scrollview
        local scrollView = widget.newDragItemsScrollView{
          backgroundColor = {1.0},
          left=self.x, -- M.rootGroup.layerbox.contentBounds.xMax,
          top= self.y, -- 22,
          -- top=(display.actualContentHeight-1280/4 )/2,
          width=self.width, -- display.actualContentWidth - M.rootGroup.layerbox.contentBounds.xMax,
          height=self.height -- 240
        }
        --scrollView.x = display.contentCenterX
        -- scrollView.y = 0

        self.scrollView = scrollView
        self.group:insert(scrollView)
        -- scrollView.isVisible = false

        local last_x, last_y = 2, 0 -- scrollView.x , scrollView.y


        for i=1, #fooValue.layers do
          local _group = display.newGroup()

          local name = fooValue.layers[i]
          option.text = name
          local obj = newText(option)

          scrollView:attachListener(_group, listener, 100, 20, 20) -- dragtime, angle, radius,(touchthreshold)
          obj.x, obj.y = last_x, last_y + 20
          last_x, last_y = obj.x, obj.y
          obj.index = i

          local rect = display.newRect(obj.x, obj.y, obj.width, obj.height)
          rect:setFillColor(1)
          rect.anchorX = 0
          obj.rect = rect

          _group:insert(rect)
          _group:insert(obj)
          _group.obj = obj
          _group.rect = rect
          obj.parent = _group
          scrollView:insert(_group)
          objs[#objs+1] = obj

        end
        self.layers = fooValue.layers
        self.objs = objs
      end
    )
end


function M:didShow(UI)
  Runtime:addEventListener("key", onKeyEvent)
end
--
function M:didHide(UI)
  Runtime:removeEventListener("key", onKeyEvent)
end
--
function M:hide(UI)
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = false
      if self.objs[i].rect then
        self.objs[i].rect.isVisible = false
      end
    end
  end
  if self.scrollView then
    self.scrollView.isVisible = false
  end
end
--
function M:show(UI)
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = true
      if self.objs[i].rect then
        self.objs[i].rect.isVisible = true
      end
    end
  end
  if self.scrollView then
    self.scrollView.isVisible = true
  end
end

function M:destroy()
  if self.objs then
    for i=1, #self.objs do
      if self.objs[i].rect then
        self.objs[i].rect:removeSelf()
      end
      self.objs[i]:removeSelf()
    end
    self.objs = nil
  end

  if self.scrollView then
    self.scrollView:removeSelf()
    self.scrollView = nil
  end
end


return M