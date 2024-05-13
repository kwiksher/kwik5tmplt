local name = ...
local parent,root, M = newModule(name)
local actionbox = require(root.."parts.actionbox")
--

local contextButtons = require("editor.parts.buttons")
local layerTableCommands = require("editor.parts.layerTableCommands")

function M:onKeyEvent(event)
  -- Print which key was pressed down/up
  -- local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  -- for k, v in pairs(event) do print(k, v) end
  self.altDown = false
  self.controlDown = false
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    -- print(message)
    self.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    self.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    self.shiftDown = true
  end
  -- print("controlDown", self.controlDown)
end

local posX = display.contentCenterX*0.75

function M:mouseHandler(event)
  if event.isSecondaryButtonDown and event.target.isSelected then
    -- print("@@@@selected")
    contextButtons:showContextMenu(posX, event.y,  {type="action", selections=self.selections})
  else
    -- print("@@@@not selected")
  end
  return true
end

function M:selectHandler(target)
  layerTableCommands.clearSelections(self, "action")
  if self.controlDown then
    print("controlDown")
    layerTableCommands.multiSelections(self, target)
  else
    self.lastTarget = target
    self.UI.scene.app:dispatchEvent {
      name = "editor.action.selectAction",
      action = target.action,
      UI = self.UI
    }
    if self.altDown then
      if layerTableCommands.singleSelection(self, target) then
        actionbox:setActiveProp(target.action) -- nil == activeProp
      end
   end
  end
end
-- edit button
function M:editHandler(target)
  if self.lastTarget then
    if layerTableCommands.showLayerProps(self, self.lastTarget) then
       print("TODO show action props")
       if layerTableCommands.singleSelection(self, self.lastTarget) then
         actionbox:setActiveProp(self.lastTarget.action) -- nil == activeProp
       end
    end
  end
end

function M:newHandler(target)
  self.UI.scene.app:dispatchEvent {
    name = "editor.action.selectAction",
    action = {},
    isNew = true,
    UI = self.UI
  }
end

return M