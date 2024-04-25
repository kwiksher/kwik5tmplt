local M = {
  -- text   = {},
  -- speakerIcon = true,
  -- padding = {{elpad}}/4,
  -- ---
  -- fontSize = {{elFontSize}}/4,
  -- x = {{mX}},
  -- y = {{mY}},
  -- --
  -- name = {{elaudio}},
  -- folder = nil,
  -- language = nil,
  -- delay = {{eldelay}},
  -- --
  -- volume = {{avol}},
  -- trigger = {{sbut}},
  -- --
  -- font         = {{elFont}},
  -- fontColor    = { {{elFontColor}} },
  -- fontSize     = {{elFontSize}}/4,
  -- fontColorHi  = { {{elColorHi}} },
  -- fadeDuration = {{afade}},
  -- wordTouch    = {{elTouch}},
  -- readDir      = "{{rightLeft}}",
  -- sentenceDir  = {{elTouchFolder}}, -- wordTouch
  -- channel      = {{vchan}},
}

local App = require "Application"
local syncSound = require("extlib.syncSound")


-- linefeed (RL)
-- elContent     = elContent.replace(/\r/g,'\-r ') //adds the newline
-- var txt       = elContent.replace(/\r/g,' ');

function M:setHandler()
  if self.line == nil then return end
  for i=1, #self.line do
    -- local _value = {
    --   start = rows[i].start, -- {{start}},
    --   out = rows[i].out,  -- {{out}},
    --   dur = rows[i].dur, -- {{dur}},
    --   name = rows[i].name, -- "{{name}}",
    --   file = rows[i].file, -- "{{file}}",
    --   newline = rows[i].newline, -- false/true,
    -- }

    if self.line[i].action then
      self.line[i].trigger = function(event)
        -- for k,v in pairs(event) do print(k, v) end
        -- print("", event.name, event.action)
        self.UI:dispatchEvent({name=event.action, params=event})
      end
    end
    ---
  end
end

function M:newIcon (UI)
  local sceneGroup  = UI.sceneGroup

  local x, y = App.getPosition(self.x + 15, self.y-30)
  -- x = display.contentCenterX
  -- y = display.contentCenterY
  local audioImage = "kAudio.png"
  local audioImageHi = "kAudio.png"
  local speakW, speakH = 60/4, 60/4
  local obj =  display.newImageRect( App.getProps().imgDir.. audioImage, App.getProps().systemDir, speakW, speakH);
  obj.x = x
  obj.y = y
  obj.oriX = x
  obj.oriY = y
  -- obj:scale(10,10)

  --Not show if multilanguage?
  --speakerIcon.alpha = 0
  sceneGroup:insert(obj)
  self.speakerObj = obj
end

--
function M:init(UI)
  -- print(self.name)
  if self.language then
    self.line =self.language and  self.language[App.getProps().lang]
  end
  --
  self:setHandler(self.line)
  --
end

function M:create(UI)
  local sceneGroup  = UI.sceneGroup

  if self.audioProps == nil then return end
  --
  local path =  App.getProps().audioDir.."sync/"..self.audioProps.filename
  if self.language then
    if self.folder then
      path = App.getProps().audioDir.."sync/"..App.getProps().lang.."/"..self.folder.."/"..self.audioProps.filename
    else
      path = App.getProps().audioDir.."sync/"..App.getProps().lang.."/"..self.audioProps.filename
    end
  else
    if self.folder then
      path = App.getProps().audioDir.."sync/"..self.folder.."/"..self.audioProps.filename
    end
  end

  --
  -- print(path)
  self.audioObj =  audio.loadStream(path , App.getProps().systemDir)

  local x,y = App.getPosition(self.x, self.y)

  -- need this?
  -- if self.speakerIcon then
  --   x = x + elpad*2
  -- end

  if self.speakerIcon then
    self:newIcon(UI)
  end

  local button =  UI.sceneGroup[self.layer]
  button.x = x
  button.y = y
  button.isVisible = false
  -- print("#", self.layer, button)

  local lang = ""
  if self.language then
    lang = App.getProps().lang or ""
  end
  --
  self.talkButton, self.syncObj = syncSound.addSentence{
      x            = x,
      y            = y,
      padding      = self.textProps.padding,
      sentence     = self.audioObj,
      volume       = self.audioProps.volume,
      line         = self.line,
      button       = self.speakerObj or button,
      font         = self.textProps.font,
      fontColor    = self.textProps.fontColor,
      fontSize     = self.textProps.fontSize,
      fontColorHi  = self.textProps.fontColorHi,
      fadeDuration = self.controls.fadeDuration,
      wordTouch    = self.controls.wordTouch,
      readDir      = self.textProps.readDir,
      sentenceDir  = self.textProps.sentenceDir,
      channel      = self.audioProps.channel,
      lang         = lang
  }


  sceneGroup:insert(self.syncObj)
  --

  UI.audios[self.name] = self

end

function M:play()
  syncSound.saySentence{
    sentence= self.audioObj,
    line=self.line,
    button=self.talkButton }
end
--
function M:didShow(UI)
  local sceneGroup  = UI.sceneGroup
  if self.autoPlay and self.talkButton then
      self.timerStash = timer.performWithDelay( self.delay or 0,
        function()
          syncSound.saySentence{
          sentence= self.audioObj,
          line=self.line,
          button=self.talkButton }
      end)
    end
  self.UI = UI
  if self.wordTouch and self.talkButton then
    syncSound.addEventListener(self.talkButton.words)
  end
end

function M:didHide(UI)
  if self.timerStash then
    timer.cancel(self.timerStash )
  end
  --
  self.timerStash = nil1
  --
  for k, v in pairs (syncSound.timerStash) do
    timer.cancel(v)
  end
  syncSound.timerStash = {}
  if self.wordTouch and self.talkButton then
    syncSound.removeEventListener(self.talkButton.words)
  end
end
--
function M:destroy()
end

M.set = function(instance)
	return setmetatable(instance, {__index=M})
end

--
return M