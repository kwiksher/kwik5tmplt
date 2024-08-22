local physics = require("physics")

local M = {
  properties = {
    orientation = "landscaleLeft", -- portratiteUpsideDown
    invert = false,
    scale = 1,
    gravityX = 0,
    gravityY = 9.8,
    drawMode = "Hybrid"
  },
  walls = {top=false, bottom=false, left=false, right=false}
}
--
local W = display.viewableContentWidth
local H = display.viewableContentHeight

function M:create(UI)
  local  walls = self.walls
  if walls then
    if walls.top then
      self.wT = display.newRect(W/2,-1,W,0)
      self.wT:setFillColor(0,0,0)
      sceneGroup:insert(self.wT)
     end
    if walls.bottom then
      self.wB = display.newRect(W/2,H+1,W,1)
      sceneGroup:insert(self.wB)
      self.wB:setFillColor(0,0,0)
    end
    if walls.left then
      self.wL = display.newRect(-1,H/2,0,H)
      sceneGroup:insert(self.wL)
      self.wL:setFillColor(0,0,0)
    end
    if walls.right then
      self.wR = display.newRect(W+1,H/2,0,H)
      sceneGroup:insert(self.wR)
      self.wR:setFillColor(0,0,0)
    end
  end
end
--
function M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
   -- Physics
  physics.start()
  physics.setDrawMode(props.drawMode)
  physics.setScale = props.scale
  physics.setGravity(props.grapvityX, props.gravityY)
  -- Invert gravity on orientation change
  if props.invert then
   local kOrientation, gx, gy = system.orientation, physics.getGravity()
   self.orientationHandler = function(event)
      if (system.orientation == self.orientation and system.orientation ~= kOrientation) then
         physics.setGravity(gx*-1,gy*-1)
      else
         physics.setGravity(gx, gy)
      end
      return true
   end
   Runtime:addEventListener("orientation", self.orientationHandler);
  end
  --
  local  walls = self.walls
  if walls then
    if walls.top then
      physics.addBody(self.wT, "static")
     end
    if walls.bottom then
      physics.addBody(self.wB, "static")
    end
    if walls.left then
      physics.addBody(self.wL, "static")
    end
    if walls.right then
      physics.addBody(self.wR, "static")
    end
  end
end

function M:didHide()
  if self.orientationHandler then
    Runtime:removeEventListener("orientation", self.orientationHandler);
    self.orientationHandler = nil
  end
  physics.stop()
end

--
function M:destroy()
  if self.orientationHandler then
    Runtime:removeEventListener("orientation", self.orientationHandler);
  end
  physics.stop()
end
--
return M