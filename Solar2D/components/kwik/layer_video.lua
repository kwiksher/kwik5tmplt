local M = require("components.kwik.layer_base").new()
--
function M:isSingleton(layerName)
  for i = 1, #self.singleNames do
    if layerName == self.singleNames[i] then
      return true
    end
  end
  return false
end

--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  local props = self.properties
  local layerProps = self.layerProps
  local obj
  --
  if self:isSingleton(layerName) then
    obj = sceneGroup[layerName]
    if obj == nil or obj.play == nil then
      print("singleton:newVideo")
      obj = native.newVideo(layerProps.mX, layerProps.mY, layerProps.imageWidth,layerProps.imageHeight)
      obj.isLoaded = false
    end
  else
    -- print(layerProps.mX, layerProps.mY, layerProps.imageWidth,layerProps.imageHeight)
    -- local circle = display.newCircle( layerProps.mX, layerProps.mY ,100 )
    obj = native.newVideo(layerProps.mX, layerProps.mY, layerProps.imageWidth,layerProps.imageHeight)
    -- print(obj.x, obj.y)
  end

  --
  if self:isSingleton(layerName) then
    if not obj.isLoaded then
      if self.isLocal then
        obj:load(UI.props.videoDir .. self.url, UI.props.systemDir)
      else
        obj:load(props.url, media.RemoteSource)
      end
      obj.isLoaded = true
    else
      obj:seek(0) --rewind video after play
      obj:pause()
    end
  else
    if props.isLocal then
      obj:load(UI.props.videoDir .. props.url, UI.props.systemDir)
    else
      obj:load(props.url, media.RemoteSource)
    end
  end
  if props.autoPlay then

    -- print("@@@", UI.props.videoDir .. props.url, UI.props.systemDir)

    obj:play()
  end

  -- if self.classProps.paused then
  --   obj:pause()
  -- else
  --   obj:play()
  -- end

  self:setLayerProps(obj)
  --
  obj.name = layerName
  obj.type = "video"
  --sceneGroup:insert(obj)
  -- local origin = sceneGroup[layerName]
  -- if origin then
  --   obj.layerIndex = origin.layerIndex
  --   origin:removeSelf()
  -- else
  --   obj.layerIndex = obj.layerIndex + 1
  -- end
  sceneGroup[layerName] = obj
  -- UI.layers[obj.layerIndex] = obj
  ---
  UI.videos[#UI.videos + 1] = obj
  self.obj = obj

end
--
function M:didShow (UI)

  if self.loop or self.rewind then
    self.listener = function(event)
      if event.phase == "ended" then
        if self.rewind then
          self.obj:seek(0) --rewind video after play
        end
        if self.loop then
          self.obj:play()
        end
        if self.actions.onComplete then
          UI.scene:dispatchEvent({name = self.actions.onComplete, layer = self.obj})
        end
      end
    end
    obj:addEventListener("video", self.listener)
  end
end
--
function M:didHide(UI)
  local sceneGroup = UI.sceneGroup
  local layer = UI.layer
  if self.obj ~= nil then
    if self.loop or self.rewind then
      if self.obj ~= nil and self.listener ~= nil then
        self.obj:removeEventListener("video", self.listener)
        self.listener = nil
      end
    end
    --
    if self:isSingleton(layerName) then
      for i = 1, 32 do
        if audio.isChannelActive(i) then
        --   print('channel '..i..' is active')
        -- audio.setVolume( 0.01, {channel=i}  )
        end
      end
    else
      if self.obj then
        self.obj:pause()
        self.obj:removeSelf()
        self.obj = nil
        sceneGroup[layerName] = nil
      end
    end
  end
end

---------------------------
M.set = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end
--
return M
