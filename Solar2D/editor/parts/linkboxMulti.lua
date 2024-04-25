local name = ...
local parent = name:match("(.-)[^%.]+$")
local util = require("editor.util")

local M = {
  model = {},
  selections = {}
}

local function onKeyEvent(event)
  -- Print which key was pressed down/up
  local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
  --for k, v in pairs(event) do print(k, v) end
  if (event.keyName == "leftAlt" or event.keyName == "rightAlt") and event.phase == "down" then
    print("linkboxMulti", message)
    M.altDown = true
  elseif (event.keyName == "leftControl" or event.keyName == "rightControl") and event.phase == "down" then
    M.controlDown = true
  elseif (event.keyName == "leftShift" or event.keyName == "rightShift") and event.phase == "down" then
    M.shiftDown = true
  end
end

function M:didShow(UI)
  Runtime:addEventListener("key", onKeyEvent)
  self:_didShow(UI)
end
--
function M:getValue()
  return self.objs
end
--
function M:getSelections()
  return self.selections
end

--
function M:didHide(UI)
  Runtime:removeEventListener("key", onKeyEvent)
  self:_didHide(UI)
end

function M:commandHandler(eventObj, event)
  print(event.phase)
  if event.phase == "began" or event.phase == "moved" then
    return
  end

  util.setSelection(self, eventObj)

  -- local target = eventObj -- or event.target
  -- --
  -- if not self.controlDown then
  --   self.selection = target
  --   for i = 1, #self.selections do
  --     if self.selections[i].rect then
  --       self.selections[i].rect:setFillColor(0.8)
  --     end
  --   end
  --   self.selections = {target}
  --   target.isSelected = true
  --   target.rect:setFillColor(0,1,0)
  -- else -- mutli selections
  --   if not target.isSelected then
  --     self.selections[#self.selections + 1] = target
  --     target.isSelected = true
  --   end
  --   --target:setFillColor(1)
  --   target.rect:setFillColor(0, 1, 0)
  -- end

  return true

end

return M