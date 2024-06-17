local M = require("editor.parts.baseProps").new()
---------------------------
M.name = "classProps"

local Layer     = table:mySet{"over", "mask", "dropLayer", "_filename", "sheetInfo"}
local Layer_Class = table:mySet{}
M.onTapLayerSet = Layer

local PosXY = table:mySet{"x", "y"}
M.onTapPosXYSet   = PosXY
--
function M:setActiveProp(layer, class)
  local name =self.activeProp
  local value = layer
  if class then
    value = layer.."_"..class
  end
  if self.activeProp == "sheetInfo" then
     for i, obj in next, self.objs do
      if obj.text == "sheetInfo" then
        obj.field.text = layer:gsub(".png", ".lua")
      elseif obj.text == "_filename" then
        obj.field.text = layer
      else
        obj.field.text = ""
      end
     end
    self:showThumnail(self.activeProp, layer, self.class)
  else
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
      local obj = self:getObj(name)
      obj.field.text = value
      if name == "_filename" and self.class == "sprite" then
        local w, h = self:showThumnail(self.activeProp, layer, self.class)
        self:updateSheetInfo(w, h)
        -- local sheetOptions = {
        --   width = 50,
        --   height = 50,
        --   numFrames = 64,
        --   sheetContentWidth = 800,
        --   sheetContentHeight = 200
        -- }
      end
    else
      -- TBI show popup
    end
  end
  --
end

function M:getObj (name)
  for i,v in next, self.objs do
    -- print("######isValid", name, v.text)
    if v.text == name then
      return v
    end
  end
end

function M:updateSheetInfo(sheetContentWidth, sheetContentHeight)

  if sheetContentWidth then
    self:getObj("sheetContentWidth").field.text = sheetContentWidth
    self:getObj("sheetContentHeight").field.text = sheetContentHeight

    local numFrames =  tonumber(self:getObj("numFrames").field.text)
    local ratio     = sheetContentWidth/sheetContentHeight

    if ratio > 0 then
      local width = sheetContentWidth/(numFrames/ratio)/ratio
      local height = sheetContentHeight/(numFrames/ratio)
      self:getObj("_width").field.text = width
      self:getObj("_height").field.text = height
    else
      ratio     = sheetContentWidth/sheetContentHeight
      local width = sheetContentWidth/(numFrames/ratio)
      local height = sheetContentHeight/(numFrames/ratio)/ratio
      self:getObj("_width").field.text = width
      self:getObj("_height").field.text = height
    end
  end

end

function M:showThumnail(name, value, class)
  if self.showThumnailObj then
    self.showThumnailObj:removeSelf()
  end
  --
  local path = "App/" ..self.UI.book.."/assets/"..value
  local obj = display.newImage(self.group, path)
  if obj then
    local w, h = obj.width, obj.height
    local scaleW = 200/w
    local scaleH = 200/h
    if scaleW > scaleH then
      obj:scale(scaleH, scaleH)
    else
      obj:scale(scaleW, scaleW)
    end
    obj.x = self.x + 40
    obj.y = display.contentCenterY
    self.showThumnailObj = obj
    return w, h
  end
end
--
return M