local M = require("editor.parts.baseProps").new()
---------------------------
M.name = "classProps"

local Layer_Class = table:mySet{}
M.onTapLayerSet = table:mySet{"target", "over", "mask", "dropArea", "_filename", "sheetInfo"}
M.onTapActionSet = table:mySet{"onComplete"}
M.onTapPosXYSet = table:mySet{"x", "y"}
--
function M:setActiveProp(layer, class)
  -- print("activeProp", self.name)
  local name =self.activeProp
  local value = layer
  local UI = self.UI

  if class then
    value = layer.."_"..class
  end
  if self.activeProp == "sheetInfo" then
     for i, obj in next, self.objs do
      if obj.text == "sheetInfo" then
        local filename = layer:gsub(".png", ".lua")
        local path = system.pathForFile( "App/"..UI.book.."/assets/"..filename , system.ResourceDirectory )
        if path == nil then
          filename = layer:gsub(".png", ".json")
          path = system.pathForFile( "App/"..UI.book.."/assets/"..filename , system.ResourceDirectory )
        end
        if path then
          obj.field.text = filename
        end
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
      elseif self.onTapLayerSet[self.activeProp] then
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

    local numFrames =  tonumber(self:getObj("numFrames").field.text) or 1
    local ratio     = sheetContentWidth/sheetContentHeight

    if ratio > 0 then
      local width = sheetContentWidth/(numFrames/ratio)
      local height = sheetContentHeight/ratio
      self:getObj("_width").field.text = width
      self:getObj("_height").field.text = height
    else
      ratio     = sheetContentWidth/sheetContentHeight
      local width = sheetContentWidth/ratio
      local height = sheetContentHeight/(numFrames/ratio)
      self:getObj("_width").field.text = width
      self:getObj("_height").field.text = height
    end
  end

end

function M:showThumnail(name, value, class)
  if self.showThumnailObj then
    self.showThumnailObj:removeSelf()
    self.showThumnailObj = nil
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
      obj.y = display.contentCenterY
    else
      obj:scale(scaleW, scaleW)
      obj.y = display.contentCenterY
    end
    obj.x = display.contentCenterX + 340
    self.showThumnailObj = obj
    return w, h
  end
end
--
return M