local M = {}
M.name = ...
-- attach drag-item scrollview to widget library
require("extlib.dragitemscrollview")

-- load widget library
local widget = require("widget")

function M:init(UI) end
--
function M:create(UI)

  self.group = display.newGroup()
  self.UI = UI
  UI.editor.viewStore.actionCommandTable = self

  self.singleClickEvent = function(obj)
    UI.scene.app:dispatchEvent {
      name = "editor.action.selectActionCommand",
      UI = UI,
      index = obj.index,
      commandClass = self.actions[obj.index]
    }
    if self.selection and self.selection ~= obj then
      self.selection.rect:setFillColor(1)
    end
    self.selection = obj
    self.selection.rect:setFillColor(0,1,0)
  end

  UI.editor.actionCommandStore:listen(function(foo, fooValue)
    self:createTable(foo, fooValue)
  end)

end

    -- create a listener to handle drag-item commands
function M:listener( item, touchevent )
  if touchevent.phase  == "ended" then
    -- print("single click event")
    -- this opens a commond editor table
    self.singleClickEvent(item)
  else
    display.currentStage:insert( item )
    item.x, item.y = touchevent.x, touchevent.y
    -- print(item.x, item.y)
    --
    local function touch(e)
      --print("touch", e.phase, e.target.hasFocus)
      if (e.phase == "began") then
        display.currentStage:setFocus( e.target, e.id )
        e.target.hasFocus = true
        return true
      elseif (e.target.hasFocus) then
        e.target.x, e.target.y = e.x, e.y
        -- print("", e.target.x, e.target.y)
        if (e.phase == "moved") then
        elseif (e.phase == "ended") then
          -- print(e.phase, e.target.x, e.target.y)
          display.currentStage:setFocus( e.target, nil )
          e.target.hasFocus = nil
          local localX, localY = self.scrollView:contentToLocal(  e.target.x,  e.target.y )
          e.target.x = localX + self.scrollView.width/2
          e.target.y = localY + self.scrollView.height/2
          -- print("", e.target.x, e.target.y)
          -- print("--------")

          local function compare(a,b)
            return a.y < b.y
          end
          --
          table.sort(self.objs,compare)
          local actions = {}
          for i=1, #self.objs do
            print(i, self.objs[i].index, self.objs[i].action.command)
            actions[i] = self.objs[i].action
          end
          self:destroy()
          self:createTable(nil, {actions = actions})
          --
          --self.scrollView:attachListener(e.target, listener, 100, 20, 20)
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

function M:createTable (foo, fooValue)
  local UI = self.UI
  local objs = {}
  local group = display.newGroup()

  local option = {
    parent = self.group,
    text = "",
    x = 0,
    y = 0,
    width = nil,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }

  local function newText(option, text)
    option.text = text or ""
    local obj = display.newText(option)
    obj:setFillColor(0)
    obj.anchorX = 0
    return obj
  end

   -- create drag-item scrollview
  local scrollView = widget.newDragItemsScrollView{
    backgroundColor = {1.0},
    left=UI.editor.viewStore.commandView.contentBounds.xMax,
    top=22,
    -- top=(display.actualContentHeight-1280/4 )/2,
    width=display.actualContentWidth - UI.editor.viewStore.commandView.contentBounds.xMax,
    height=240
  }
  --scrollView.x = display.contentCenterX
  -- scrollView.y = 0

  self.scrollView = scrollView
  UI.editor.viewStore.actionCommandTable.group:insert(scrollView)
  -- scrollView.isVisible = false

  local last_x, last_y = 2, 0

  for i, action in pairs(fooValue.actions) do
    local target, params = "", ""
    for k, v in pairs(action.params) do
      if k ~= "target" then
        params = params ..k ..":" .. tostring(v) .." "
      else
        target = tostring(v)
      end
    end

    local obj = newText(option, action.command .." "..target)
    scrollView:attachListener(obj,
      function(item, touchevent )
        self:listener(item, touchevent)
      end, 100, 20, 20)
    obj.x, obj.y = last_x, last_y + 20
    last_x, last_y = obj.x, obj.y
    obj.action = action
    obj.params = params
    obj.target = target
    obj.index = i

    local rect = display.newRect(obj.x, obj.y, obj.width, obj.height)
    rect:setFillColor(1)
    rect.anchorX = 0
    obj.rect = rect

    group:insert(rect)
    group:insert(obj)
    scrollView:insert(group)
    objs[#objs+1] = obj

  end
  self.objs = objs
  -- print("@@@@@@@", #objs)
  self.actions = fooValue.actions
end


  -- create item to add to the scroll view (this will be dragged off the scrollview)
  -- local text1 = newText(option, "Animation-play title")
  -- local text2 = newText(option, "Audio-play bgm")
  -- local text3 = newText(option )


  -- add the drag-item to the scrollview
  --[[
    Params:
      item: Item to add to the scrollview
      listener: Listener function to call when a drag-off is detected
      Dragtime: Milliseconds that a hold will begin a drag-off
      Angle: Angle at which a touch-motion will begin a drag-off event
      Radius: Radius around the angle within which the drag-off will begin, outside this will not
      Touch-threshold: Distance a touch must travel to begin a drag-off (default is .1 of screen width)

    Description:
      This example will cause the white circle to be dragged off the scrollview only if the
      touch begins and does not move further than the touch-threshold within 450 milliseconds
      OR if the touch moves further than .1 of the screen width within 450 millisecond
      BUT ONLY if the touch moves within 90 degrees of immediately east (right) of the initial touch.

      The Dragtime determines how long a touch-and-hold will cause a drag to fire. Leave nil to
      have only touch with distance begin a drag-off.

      Angle and Radius define a range of direction which will fire a drag-off event. Outside of that
      will result in the scrollview being scrolled. Leave nil to have only touch-and-hold to fire a
      drag-off event.

      The Touch-threshold can be used to define the distance that a touch-and-move will fire a
      drag-off event. The default is .1 of the screen width.
  ]]--

  -- scrollView:attachListener( text1, listen, 100, 20, 20 )
  -- scrollView:attachListener( text2, listen, 100, 20, 20 )
  -- scrollView:attachListener( text3, listen, 100, 20, 20 )


  -- position the drag item in the scrollview
  -- text1.x, text1.y = 2, text1.height/2
  -- text2.x, text2.y = text1.x, text1.y + 20 --scrollView.x, scrollView.y + 20
  -- text3.x, text3.y = text2.x, text2.y + 20


  -- local function render (models, xIndex, yIndex)
  --   local count = 0
  --   for i = 1, #models do
  --     local model = models[i]
  --     model.name, model.class, model.children = parse(model)
  --     option.text = model.name
  --     option.x = UI.editor.viewStore.selectLayer.x + UI.editor.viewStore.selectLayer.width/2 + xIndex *5
  --     option.y = UI.editor.viewStore.selectLayer.contentBounds.yMax + 10 + option.height * count
  --     option.width = 100
  --     local obj = newText(option)
  --     obj.layer = model.name
  --     obj.class = ""
  --     obj.tap = commandHandler
  --     obj:addEventListener("tap", obj)
  --     count = count + 1
  --     -- class
  --     if model.class then
  --       local last_x = 10
  --       for k=1, #model.class do
  --         option.text = model.class[k]:sub(1, 5)
  --         option.x = UI.editor.viewStore.selectLayer.x + UI.editor.viewStore.selectLayer.width/2 + last_x
  --         option.y = UI.editor.viewStore.selectLayer.contentBounds.yMax + 10 + option.height * (count-1)
  --         option.width = nil
  --         local obj = newText(option)
  --         --obj.width = 50
  --         obj.layer = model.name
  --         obj.class = "_"..model.class[k]
  --         obj.tap = commandHandler
  --         obj:addEventListener("tap", obj)
  --         last_x = obj.width + 2
  --       end
  --     end
  --     -- children
  --     if #model.children then
  --       count = count + render(model.children, xIndex + 1, count )
  --     end
  --   end
  --   return count
  -- end

  -- UI.actionStore:listen(
  --   function(foo, fooValue)
  --     render(fooValue,0,0)
  --   end
  -- )

function M:didShow(UI) end
--
function M:didHide(UI) end
--
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