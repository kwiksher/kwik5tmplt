-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local W = display.viewableContentWidth
local H = display.viewableContentHeight

local _K = require "Application"

--
function _M:localVars()
end
--
function _M:localPos()
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
   -- Physics
  physics.start()
  physics.setScale = {{ss}}
  physics.setGravity({{gx}}, {{gy}})
  {{#invert}}
   -- Invert gravity on orientation change
   local kOrientation, gx, gy = system.orientation, physics.getGravity()
   _K.kOrientation_act = function(event)
   {{#landscape}}
       vori = "landscapeLeft"
   {{/landscape}}
   {{#portrait}}
       vori = "portraitUpsideDown"
   {{/portrait}}
      if (system.orientation == "{{vori}}" and system.orientation ~= kOrientation) then
         physics.setGravity(gx*-1,gy*-1)
      else
         physics.setGravity(gx, gy)
      end
      return true
   end
  {{/invert}}
  physics.setDrawMode("{{gm}}")
  {{#walls}}
      {{#wallT}}
      local wT = display.newRect(W/2,-1,W,0)
      wT:setFillColor(0,0,0)
      physics.addBody(wT, "static")
    {{/wallT}}
    {{#wallB}}
      local wB = display.newRect(W/2,H+1,W,1)
      sceneGroup:insert(wB)
      wB:setFillColor(0,0,0)
      physics.addBody(wB, "static")
    {{/wallB}}
    {{#wallL}}
      local wL = display.newRect(-1,H/2,0,H)
      sceneGroup:insert(wL)
      wL:setFillColor(0,0,0)
      physics.addBody(wL, "static")
    {{/wallL}}
    {{#wallR}}
      local wR = display.newRect(W+1,H/2,0,H)
      sceneGroup:insert(wR)
      wR:setFillColor(0,0,0)
      physics.addBody(wR, "static")
    {{/wallR}}
  {{/walls}}
end
--
function _M:toDispose()
  physics.stop()
end
--
function _M:localVars()
end
--
return _M