local M = {}
M.name = ...

function M:singleClickEvent(obj)
  self.UI.scene.app:dispatchEvent {
    name = "editor.action.selectActionCommand",
    UI = self.UI,
    index = obj.index,
    commandClass = self.actions[obj.index]
  }
  if self.selection and self.selection ~= obj then
    self.selection.rect:setFillColor(1)
  end
  self.selection = obj
  self.selection.rect:setFillColor(0,1,0)
end

    -- create a listener to handle drag-item commands
function M:listener( item, touchevent )
  if touchevent.phase  == "ended" then
    -- print("single click event")
    -- this opens a commond editor table
    self:singleClickEvent(item)
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

M.attachListener = function(instance)
	return setmetatable(instance, {__index=M})
end

--
return M