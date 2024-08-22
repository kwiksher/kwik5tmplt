local current = ...
local parent,root, M = newModule(current)

local function onKeyEvent(self, event)
  -- Print which key was pressed down/up
  local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  -- print(M.name, message)
  -- for k, v in pairs(event) do print(k, v) end
  self.altDown = false
  self.controlDown = false
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    print("baseTable", self.name, message)
    self.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    self.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    self.shiftDown = true
  end
  -- print("controlDown", M.controlDown)
end
--
local basePropsControl   = require("editor.parts.basePropsControl")
local layerTable         = require("editor.parts.layerTable")
local layerTableCommands = require("editor.parts.layerTableCommands")
local selectbox          = require("editor.physics.selectbox")
local model              = require("editor.template.components.pageX.physics.defaults.joint")
local pointA        = require("editor.animation.pointA")
local pointB        = require("editor.animation.pointB")
--
function M:tapListener(event, type)
  print("tapListener", type)
  -- event.actionbox = self
  if self:isAltDown() then -- show Focus
    -- print("altDown")
    local bodyA = self.objs[1].field.text
    local bodyB = self.objs[2].field.text

    local selections = {}
    for i, v in next, layerTable.objs do
      if v.layer == bodyA or v.layer == bodyB then
        selections[#selections + 1] = v
      end
    end
    layerTable.selections = selections
    layerTableCommands.showFocus(layerTable)
  else
    self.activeProp = event.target.text
    basePropsControl.handler[type](event, self)
  end
end

M.onTapLayerSet = table:mySet{"_target", "_bodyA", "_bodyB", "_body"}
M.onTapActionSet =  table:mySet{"onComplete"}
M.onTapPosXYSet = table:mySet{"anchor_x", "anchorA_x", "anchorB_x", "statA_x", "stateB_x", "bodyA_x", "bodyB_x", "offsetA_x", "offsetB_x"}
--
function M:setActiveProp(layer, class)
  print("setActiveProp", self.name)
  local name =self.activeProp
  local value = layer
  local UI = self.UI
  --
  if self.activeProp =="othersGroup" then
    print("@@@@", layer, class)
    for i,v in next, self.objs do
      if v.text == "othersGroup" then
        v.field.text = layer
        break
      end
    end
  elseif self.onTapLayerSet[self.activeProp] then
    local fields = {_bodyA=NIL, _bodyA=NIL, _body=NIL, anchor_x=NIL, anchor_y=NIL, anchorA_x=NIL, anchorA_y=NIL, anchorB_x=NIL, anchorB_y=NIL, statA_x=NIL, statB_x=NIL, statB_y=NIL, bodyA_x, bodyA_y, bodyB_x, bodyB_y}
    for i,v in next, self.objs do
      if v.text == name then
        -- print("name", name)
        v.field.text = value
      end
      -- print("", name)
      fields[v.text] = v
    end
    -- print("joint type", selectbox.selectedTextLabel)
    local joint = selectbox.selectedTextLabel
    local bodyA, bodyB = self.objs[1], self.objs[2]

    -- for k, v in pairs(UI.sceneGroup) do print(k) end

    local objA = UI.sceneGroup[bodyA.field.text]
    local objB = UI.sceneGroup[bodyB.field.text]

    if joint == "touch" then
      fields.anchor_x.field.text = bodyA.field.text ..".x"
      fields.anchor_x.field.text = bodyA.field.text ..".y"
      pointA:setValue(objA)
      pointA:setActiveEntry(bodyA)
      pointB:setValue()
    else
      -- for A
      if bodyA.field.text:len() > 0 then
        -- print(joint, bodyA.field.text)
        if joint == "pivot" then
          fields.anchor_x.field.text = bodyA.field.text ..".x"
          fields.anchor_y.field.text = bodyA.field.text ..".y"
        elseif joint == "piston" then
          fields.anchor_x.field.text = bodyA.field.text ..".x"
          fields.anchor_y.field.text = bodyA.field.text ..".y"
        elseif joint == "distance" then
          fields.anchorA_x.field.text = bodyA.field.text ..".x"
          fields.anchorA_y.field.text = bodyA.field.text ..".y"
        elseif joint == "pulley" then
          fields.statA_x.field.text = bodyA.field.text ..".x"
          fields.statA_y.field.text = bodyA.field.text ..".y"
          fields.bodyA_x.field.text = bodyA.field.text ..".x"
          fields.bodyA_y.field.text = bodyA.field.text ..".y"
        end
        pointA:setValue(objA)
        -- pointA:setActiveEntry(bodyA)
        pointA:setBodyName(bodyA.field.text)
      else
        pointA:setValue()
      end
      -- for B
      if bodyB.field.text:len() > 0 then
        if joint == "distance" then
          fields.anchorB_x.field.text = bodyB.field.text ..".x"
          fields.anchorB_y.field.text = bodyB.field.text ..".y"
        elseif joint == "pulley" then
          fields.statB_x.field.text = bodyB.field.text ..".x"
          fields.statB_y.field.text = bodyB.field.text ..".y"
          fields.bodyB_x.field.text = bodyB.field.text ..".x"
          fields.bodyB_y.field.text = bodyB.field.text ..".y"
        elseif joint == "wheel" then
          fields.anchor_x.field.text = bodyB.field.text ..".x"
          fields.anchor_y.field.text = bodyB.field.text ..".y"
          pointA:setValue()
        end
        pointB:setValue(objB)
        -- pointB:setActiveEntry(bodyB)
        pointB:setBodyName(bodyB.field.text)
      else
        pointB:setValue()
      end
    end
  else
    -- TBI show popup
  end
end

--
function M:isAltDown()
    return self.altDown
end
--
function M:isControlDown()
  return self.controlDown
end
--
function M:isShiftDown()
  return self.shiftDown
end

function M:didShow(UI)
  self.UI = UI
  self.keyListener = function(event) onKeyEvent(self, event)end
  Runtime:addEventListener("key", self.keyListener)
end

--
function M:didHide(UI)
  -- print(self.name, "didHide")
  Runtime:removeEventListener("key", self.keyListener)
end

return setmetatable( M, {__index=require(root.."parts.classProps")} )