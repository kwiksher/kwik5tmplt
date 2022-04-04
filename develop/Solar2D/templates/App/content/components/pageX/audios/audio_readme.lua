-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
--
--
-- local allAudios = {}
---
--
function _M:localPos(UI)
  --UI.allAudios or _K.allAudios
  if {{atype}}.kwk_readMeFile == nil then
    {{#alang}}
     {{atype}}.kwk_readMeFile = audio.{{loadType}}( _K.audioDir.._K.lang.."{{fileName}}" , _K.systemDir)
    {{/alang}}
    {{^alang}}
     {{atype}}.kwk_readMeFile = audio.{{loadType}}( _K.audioDir.."{{fileName}}", _K.systemDir )
    {{/alang}}
  end
  if {{atype}}.kwk_readMeFile then
    local a = audio.getDuration( {{atype}}.kwk_readMeFile );
    if a > UI.allAudios.kAutoPlay  then
      UI.allAudios.kAutoPlay = a
    end
  end
  --  /audio
end

function _M:didShow(UI)
  -- #audio
      {{^temSync}}
         if (_K.kwk_readMe == 1 and _K.lang == "{{langID}}") then
        {{#adelay}}
          local kwkDelay = function()
        {{/adelay}}
          audio.setVolume({{avol}}, { channel={{achannel}} });
          audio.play({{atype}}.kwk_readMeFile, { channel={{achannel}}, loops={{aloop}}{{tofade}} });
        {{#adelay}}
          end
          _K.timerStash.kwkDelay = timer.performWithDelay({{adelay}}, kwkDelay, 1)
        {{/adelay}}
        end
      {{/temSync}}
  --  /audio
end

function _M:toDispose(UI)
  -- audio
  {{^akeep}}
    if audio.isChannelActive ( {{achannel}} ) then
      audio.stop({{achannel}})
    end
  {{/akeep}}
--/audio
end
--
function _M:toDestroy(UI)
  {{^akeep}}
      if ({{atype}}.kwk_readMeFile ~= 0) then
        audio.dispose({{atype}}.kwk_readMeFile)
        {{atype}}.kwk_readMeFile = nil
      end
  {{/akeep}}
end
--
function _M:getAudio(UI)
  --UI.allAudios or _K.allAudios
  if {{atype}}.kwk_readMeFile == nil then
    {{#alang}}
     {{atype}}.kwk_readMeFile = audio.{{loadType}}( _K.audioDir.._K.lang.."{{fileName}}", _K.systemDir )
    {{/alang}}
    {{^alang}}
     {{atype}}.kwk_readMeFile = audio.{{loadType}}( _K.audioDir.."{{fileName}}" , _K.systemDir)
    {{/alang}}
  end
  return {{atype}}
end
--
return _M
