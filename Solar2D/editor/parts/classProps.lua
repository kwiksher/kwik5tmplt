local M = require("editor.parts.baseProps").new()
---------------------------
M.name = "classProps"

local Layer     = table:mySet{"over", "mask", "dropLayer"}
local Layer_Class = table:mySet{}
M.onTapLayerSet = Layer
--
function M:setActiveProp(layer, class)
  -- print("@@@@@", layer)
  local name =self.activeProp
  local value = layer
  if class then
    value = layer.."_"..class
  end
  --
  -- check
  --
  -- animation.play, animation.pause, animation.resume
  local isValid = function(class)
    if Layer_Class[self.activeProp] then
      return self.activeProp == class
    elseif Layer[self.activeProp] then
      return class == nil
    end
  end
  --
  if isValid(class) then
    ---
    for i,v in next, self.objs do
      -- print("######isValid", name, v.text)
      if v.text == name then
        v.field.text = value
        return
      end
    end
  else
    -- TBI show popup
  end
end

--
return M