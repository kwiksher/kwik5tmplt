local M = {}
--
local app = require "controller.Application"
local MultiTouch = require("extlib.dmc_multitouch")
--[[
  function M.add(layer, onComplete)
    if layer == nil then return end
    MultiTouch.activate( layer, "move", "single", {})
    --
    local eventHandler = function (event )
      local t = event.target
      if event.phase == "began" then
        local parent = t.parent; parent:insert(t); display.getCurrentStage():setFocus(t); t.isFocus = true
      elseif event.phase == "moved" then
      elseif event.phase == "ended" or event.phase == "cancelled" then
        --UI.scene:dispatchEvent({name="dragComplete", event={UI=UI, target=t} })
        onComplete(t)
        display.getCurrentStage():setFocus(nil); t.isFocus = false
      end
      return true
    end
    --
    layer:addEventListener( MultiTouch.MULTITOUCH_EVENT, eventHandler )
  end
  --
  function M.remove(layer)
    if layer then
      layer:removeEventListener ( MultiTouch.MULTITOUCH_EVENT,  eventHandler );
    end
  end
--]]
--

M.dragHandler = function (self, event )
  local UI = self.UI
  local target = event.target
  local flip = self.flipSet[self.flip]
  if self.actions.onShapeHandler then
    self.actions.onShapeHandler(event)
  end
  if event.phase == "began" then
    if not target.isFocus then
        local parent = target.parent
        parent:insert(target)
        display.getCurrentStage():setFocus(target)
        target.isFocus = true
    end
    target.oriBodyType = target.bodyType
    target.bodyType ="kinematic"
    -- self.layer = nil
    -- self.dropLayer = nil

  elseif event.phase == "moved" then
    if self.isFlip then
      if (target[flip.axis] < self.flipValue) then
        if target.flipDirection == flip.from then
          target.flipScale = flip.scaleStart
          target.flipDirection = flip.to
        end
      elseif (target[flip.axis] > self.flipValue) then
        if target.flipDirection == flip.to then
          target.flipScale = flip.scaleEnd
          target.flipDirection = flip.from
        end
      end
      self.flipValue = target[flip.axis]
    end
    ---
    if self.isDrop then
        function hitTest(dropLayer)
            target.posX = target.x - dropLayer.x
            target.posY = target.y - dropLayer.y
        if target.posX < 0 then
          target.posX = target.posX * -1
        end
        if target.posY < 0  then
          target.posY = target.posY * -1
        end
        if target.posX <= self.dropdBound.xEnd and target.posY <= self.dropdBound.yEnd  then  --in position\r\n'
              target.x = dropLayer.x
              target.y = dropLayer.y
          target.lock = 1
        else
          target.lock = 0
        end
        end
        hitTest(self.dropLayer)
    end
    if self.actions.onMoved then
      --  self.layer = target
       UI.scene:dispatchEvent({name=self.actions.onMoved, event={UI=UI} })
    end
  elseif event.phase == "ended" or event.phase == "cancelled" then
      target.bodyType = target.oriBodyType
      if self.isDrop then
        if target.lock == 1 and target.posX <= self.dropdBound.xEnd and target.posY <= self.dropdBound.xEnd then
           target.x = target.dropLayer.x
           target.y = target.dropLayer.y

          --  if self.actions.onReleased then
          --    MultiTouch.deactivate(target)
          --  end

           if self.actions.onDropped then
            -- self.layer = target
            -- self.dropLayer = target.dropLayer
            UI.scene:dispatchEvent({name=self.onDropped, event={UI=UI} })
           end
        elseif self.backToOrigin then
          target.x = target.oriX
          target.y = target.oriY
        end
      end
      -- if self.onReleased then
      --     if self.actions.onReleased then
      --       if target.lock == nil or target.lock == 0 then
      --           -- self.layer = target
      --           UI.scene:dispatchEvent({name=self.actions.onReleased, event={UI=UI} })
      --       end
      --     end
      -- else
      --   if self.actions.onReleased then
      if target.lock == nil or target.lock == 0 then
        -- self.layer = target
        UI.scene:dispatchEvent({name=self.actions.onReleased, event={UI=UI} })
      end
      -- end
      -- end
      if target.isFocus then
        display.getCurrentStage():setFocus(nil); target.isFocus = false
      end
  end
  return true
end

--
function M:activate(obj)
  if obj == nil then return end
  ---
  local options = {}
  if self.constrainAngle then
    options.constrainAngle=self.constrainAngle
  end
  if self.bounds.xStart then
    options.xBounds ={ self.bounds.xStart, self.bounds.xEnd }
  end
  if self.bounds.yStart then
    options.yBounds ={ self.bounds.yStart, sefl.bounds.yEnd }
  end
  --
  -- print("@@@@@@@", obj.text)

  -- MultiTouch.activate( obj, "move", "single", options)
  MultiTouch.activate( obj, "move", "single")
  --
  if self.isDrop then
    obj.lock = 0
    obj.posX = 0
    obj.posY = 0
  end
  --
  if self.isFlip then
    obj.flipDirection = self.flipDirection
    self.flipValue = obj[self.flipSet[self.flip].axis]
  end
  --
  -- obj.dragHandler = self.dragHandler
  -- self.obj = obj
  self.listener = function(event)
    -- print("event")
    -- self has the all the props of layer_drag, obj does not have them
    --   see setmetatable is used for the model not to object
    self:dragHandler(event)
  end
  print(MultiTouch.MULTITOUCH_EVENT)
  obj:addEventListener( MultiTouch.MULTITOUCH_EVENT, self.listener)
end

function M:deactivate(obj)
  obj:removeEventListener( MultiTouch.MULTITOUCH_EVENT, self.listener)
  MultiTouch.deactivate( obj, "move", "single")
end

M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M