local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
    local sceneGroup  = UI.sceneGroup
    local props      = self.properties
    local layerProps = self.layerProps
    local options
    --
    local options = {
      text = props.contents,
      fontSize = props.fontSize/2,
      font = props.font,
      --align = props.alignment,
      x = layerProps.mX + (props.paddingX or 0),
      y = layerProps.mY + (props.paddingY or 0),
      width = layerProps.width/4,
      height = layerProps.height/4,
    }

    if props.width == NIL then
      options.width = nil
    end

    if props.height == NIL then
      options.height = nil
    end

    if props.font == "native.systemFont" then
      options.font = native.systemFont
    end

  --   local textOptions =
	-- {
	-- 	parent = group,
	-- 	text = table.concat(arr, ", "),
	-- 	x = 10,--display.contentCenterX,
	-- 	y = 0,
	-- 	width = row.contentWidth-100,
	-- 	font = native.systemFont,
	-- 	fontSize = row.params.fontSize,
	-- 	align = "left" -- Alignment parameter
	-- }

    local obj = display.newText( options )

    obj.originalH = obj.height
    obj.originalW = obj.width
    obj:setFillColor (unpack(props.color))
    -- obj.x = obj.x + options.width/2 + (props.paddingX or 0)
    -- --
    -- obj.y = obj.y + (props.paddingY or 0)
    -- --
    obj.anchorX = 0.5
    obj.anchorY = 0.5
    ---
    self:setLayerProps(obj)
    obj.layerProps = layerProps
    sceneGroup:insert( obj)
    if sceneGroup[layerProps.name] then
      sceneGroup[layerProps.name]:removeSelf()
    end
    sceneGroup[layerProps.name] = obj
end

M.set = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end

return M