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
  local layer = UI.layer
  local obj
  if self:isSingleton(self.name) then
    obj = sceneGroup[self.name]
    if obj == nil or obj.play == nil then
      print("singleton:newVideo")
      obj = native.newVideo(self.x, self.y, self.width, self.height)
      obj.isLoaded = false
    end
  else
    -- print(self.x, self.y, self.width, self.height)
    -- local circle = display.newCircle( self.x, self.y ,100 )
    obj = native.newVideo(self.x, self.y, self.width, self.height)
    -- print(obj.x, obj.y)
  end

  --
  if self:isSingleton(self.name) then
    if not obj.isLoaded then
      if self.isLocal then
        obj:load(UI.props.videoDir .. self.url, UI.props.systemDir)
      else
        obj:load(self.url, media.RemoteSource)
      end
      obj.isLoaded = true
    else
      obj:seek(0) --rewind video after play
      obj:pause()
    end
  else
    if self.isLocal then
      obj:load(UI.props.videoDir .. self.url, UI.props.systemDir)
    else
      obj:load(self.url, media.RemoteSource)
    end
  end
  if self.autoPlay then

    -- print("@@@", UI.props.videoDir .. self.url, UI.props.systemDir)

    obj:play()
  end

  -- if self.classProps.paused then
  --   obj:pause()
  -- else
  --   obj:play()
  -- end

  if self.loop or self.rewind then
    self.listener = function(event)
      if event.phase == "ended" then
        if self.rewind then
          obj:seek(0) --rewind video after play
        end
        if self.loop then
          obj:play()
        end
        if self.onComplete then
          UI.scene:dispatchEvent({name = self.onComplete, layer = obj})
        end
      end
    end
    obj:addEventListener("video", self.listener)
  end

  self:setLayerProps(obj)
  obj.name = self.name
  obj.type = "video"
  --sceneGroup:insert(obj)
  local origin = sceneGroup[obj.name]
  if origin then
    obj.layerIndex = origin.layerIndex
    origin:removeSelf()
  else
    obj.layerIndex = #UI.layers + 1
  end
  sceneGroup[obj.name] = obj
  UI.layers[obj.layerIndex] = obj
  ---
  if UI.props.muteVideos == nil then
    UI.props.muteVideos = {}
  end
  if UI.props.muteVideos[self.name] == true then
    obj.isMuted = true
  end
end
--
function M:destroy(UI)
  local sceneGroup = UI.sceneGroup
  local layer = UI.layer
  local obj = sceneGroup[self.name]
  if obj ~= nil then
    if self.loop or self.rewind then
      if obj ~= nil and self.listener ~= nil then
        obj:removeEventListener("video", self.listener)
        self.listener = nil
      end
    end
    --
    if self:isSingleton(self.name) then
      for i = 1, 32 do
        if audio.isChannelActive(i) then
        --   print('channel '..i..' is active')
        -- audio.setVolume( 0.01, {channel=i}  )
        end
      end
    else
      if obj then
        obj:pause()
        obj:removeSelf()
        sceneGroup[self.name] = nil
      end
    end
  end
end

---------------------------
M.new = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end
--
return M
