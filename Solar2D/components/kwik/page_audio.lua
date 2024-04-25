local M = {
  -- name        = {{aname}},
  -- type        = {{atype}},
  -- language    = nil  -- or {"en", "jp"},
  -- filename    = "{{fileName}}",
  -- allowRepeat = false,
  -- autoPlay    = {{aplay}},
  -- deplay      = {{adelay}},
  -- volume      = {{avol}},
  -- channel     = {{achannel}}
  -- loops       = {{aloop}},
  -- fadein      = {{tofade}},
  -- retain      = {{akeep}}
  -- audioChannel   = nil ,
  -- repeatableChannel = nil, -- for allowRepeat
  -- loader      = nil -- audio.{{loadType}},
}

local App = require("Application")
--
-- local allAudios = {}
--
function M:init(UI)
end

function M:create(UI)
  print("create page audio", self.type)
    --
    --
    if self.audioObj == nil then
    if self.folder then
       self.filename = self.folder.."/"..self.filename
    end
    if self.language then
      self.filename = App.getProps().lang.."/"..self.filename
    end
    --

    if self.type == "stream" then
      self.loader = audio.loadStream
      self.filename = "long/"..self.filename
    else
      self.loader = audio.loadSound
      self.filename = "short/"..self.filename
    end

    local path =  App.getProps().audioDir..self.filename

    self.audioObj =  self.loader(path , App.getProps().systemDir)

    UI.audios[self.name] = self
    -- TODO autoPlay pages
    -- local a = audio.getDuration( self.audioObj );
    -- if a > UI.allAudios.kAutoPlay  then
    --   UI.allAudios.kAutoPlay = a
    -- end
  end
  --
  self.repeatableChannel = nil
end

function M:play()
  audio.setVolume(self.volume or 8, { channel=self.channel });
  if self.allowRepeat then
      self.repeatableChannel = audio.play(self.audioObj, {  channel=self.channel, loops=self.loops, fadein = self.fadein } )
  else
    audio.play(self.audioObj, {channel=self.channel, loops=self.loops, fadein = self.fadein } )
  end
end

function M:didShow(UI)
  if self.audioObj == nil then return end
  --
   if self.autoPlay then
    if self.delay then
       self.timerStash = timer.performWithDelay(self.delay, function() self:play() end, 1)
    else
      self:play()
    end
  end
end

function M:didHide(UI)
  if self.audioObj == nil then return end
  if not self.retain then
    if audio.isChannelActive ( self.channel ) then
      audio.stop(self.channel)
    end
  end
  if self.timerStash then
    timer.cancel(self.timerStash )
    self.timerStash = nil
  end
end
--
function M:destroy(UI)
  if self.audioObj == nil then return end
  if not self.retain then
      if self.allowRepeat then
        if self.repeatableChannel then
          audio.dispose(self.audioObj)
        end
      else
        if self.audioObj then
          audio.dispose(self.audioObj)
        end
      end
      self.audioObj = nil
      self.repeatableChannel = nil
   end
end

function M:getAudio(UI)
  if self.audioObj == nil then
    if self.language then
      self.filename = App.getProps().lang .."/"..self.filename
    end

    local path =  App.getProps().audioDir..self.filename
    if self.folder then
      path = App.getProps().audioDir..self.folder.."/"..self.filename
    end

    self.audioObj =  self.loader(path , App.getProps().systemDir)
  end
  --
  return self.type
end

function M:rewind()
  if not self.repeatable then
    audio.rewind( self.channel )
  else
    if self.repeatableChannel then
      audio.rewind(self.repeatableChannel)
    else
      audio.rewind(self.audioObj )
    end
  end
end
--
function M:pause()
  if not self.repeatable then
    audio.pause(self.channel )
  else
    if self.repeatableChannel then
      audio.pause(self.repeatableChannel)
    else
      audio.pause(self.audioObj )
    end
  end
end
--
function M:stop()
  if not self.repeatable then
    audio.rewind( self.audioObj )
    audio.stop( self.audioObj )
  else
    if self.repeatableChannel  then
      audio.rewind(self.repeatableChannel )
      audio.stop(self.repeatableChannel  )
    else
      audio.rewind(self.audioObj )
      audio.stop(self.audioObj )
    end
  end
end
--
function M:resume()
  if not self.repeatable then
    audio.resume( self.audioObj )
  else
    if self.repeatableChannel  then
      audio.resume(self.repeatableChannel  )
    else
      audio.resume( self.audioChannel )
    end
  end
end
--
function M:setVolume(vvol)
  audio.setVolume(vvol, {channel=self.audioChannel} )
end

function M:muteUnmute()
  if (audio.getVolume() == 0.0) then
     audio.setVolume(self.volume, {channel=self.audioChannel})
  else
     audio.setVolume(0.0,  {channel=self.audioChannel})
  end
end

M.set = function(instance)
	return setmetatable(instance, {__index=M})
end

return M