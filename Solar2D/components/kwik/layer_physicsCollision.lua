local M = {
  name = "",
  properties = {
    isRemoveOther = true,
    isRemoveSelf = true
  },
  actions = {
    { onCollision="" }
  },
  others = {}
}
--
function M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local props       = self.properties
  ---
  local obj = sceneGroup[self.name]
  local other = sceneGroup[props.other]
  if ob== nil then return end

   local function onCollision(self, event)
      for i, other in next, self.others do
        local otherObj = sceneGroup[other]
        if event.phase == "began" and event.other.layer == other then
          if actions[1].onCollision then
            Runtime:dispatchEvent({name=UI.page..actions[1].onCollision, event={obj=obj, other=otherObj}, UI=UI})
          end
          if props.isRemoveSelf then
            obj:removeSelf(); sceneGroup[self.name] = nil
          end
          if props.isRemoveOther then
            otherObj:removeSelf(); sceneGroup[other] = nil
          end
       end
    end
    obj.collision = onCollision
    obj:addEventListener("collision", obj)
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end