local M = {
  -- name       = "GroupA",
  -- children   = {"Ellipse", "SubA"},
  -- isLuaTable = false,               -- if true, a group holds names of layers but not creating diplay.newGroup()
}

-- {
--   name     = "SubA",
--   chidlren = "Triangle"
-- }

-- alpha = {{alpha}}
-- xScale = {{scaleW}}
-- yScale = {{scaleH}}
-- rotation = {{rotation}}

M.isDispGroup = not M.isLuaTable

---------------------
-- Capture and set group position
 local function groupPos(obj)
    local minX, minY = 0, 0
    for i = 1, obj.numChildren do
       local currentRecord = obj[ i ]
       if i == 1 then
          minX = currentRecord.x - currentRecord.contentWidth * 0.5
          minY = currentRecord.y - currentRecord.contentHeight * 0.5
       end
       local mX = currentRecord.x - currentRecord.contentWidth * 0.5
       if mX < minX then
          minX = mX
       end
       local mY = currentRecord.y - currentRecord.contentHeight * 0.5
       if mY < minY then
          minY = mY
       end
    end
    obj.x = minX + obj.contentWidth * 0.5
    obj.y = minY + obj.contentHeight * 0.5
end
--

function M:init(UI)
end

function M:create(UI)
  local sceneGroup  = UI.sceneGroup
  local layers       = UI.layers

  if self.isDispGroup then
    local group = display.newGroup()
    group.anchorX = 0.5
    group.anchorY = 0.5
    group.anchorChildren = true

    for i=1, #self.children do
      local obj = sceneGroup[self.children[i]]
      if obj then
        group:insert(obj)
      else
        print("## error layer not found", self.children[i] )
      end
    end
      group.alpha = self.alpha
    group.oldAlpha = self.alpha
    group.xScale = self.xScale or 1
    group.yScale = self.yScale or 1
    group.rotation = self.rotation
    group.oriX = group.x
    group.oriY = group.y
    group.oriXs = group.xScale
    group.oriYs = group.yScale

    groupPos(group)
    sceneGroup:insert(group)
    sceneGroup[self.name] = group
    -- print("@@@@", self.name)
    self.group = group
  else -- self.isLua
      UI.data[self.name] = {}
      for i=1, #self.children do
        UI.data[self.name][i] = self.children[i] -- {{chldName}}
      end
  end
end
--
function M:didShow(UI)
end
--
function M:destroy(UI)
end
--
function M:willHide(UI)
end

M.set = function(instance)
	return setmetatable(instance, {__index=M})
end

return M