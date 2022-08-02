
-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
--
-- local allAudios = {}
--
function _M:localPos(UI)
  if {{atype}}.{{aname}} == nil then
    {{#alang}}
     {{atype}}.{{aname}} =  audio.{{loadType}}( _K.audioDir.._K.lang.."{{fileName}}", _K.systemDir)
    {{/alang}}
    {{^alang}}
     {{atype}}.{{aname}} =  audio.{{loadType}}( _K.audioDir.."{{fileName}}", _K.systemDir)
    {{/alang}}
        end
  -- audio
  if {{atype}}.{{aname}} then
    local a = audio.getDuration( {{atype}}.{{aname}} );
    if a > UI.allAudios.kAutoPlay  then
      UI.allAudios.kAutoPlay = a
    end
    {{#allowRepeat}}
      {{atype}}.{{aname}}x9 = 0
    {{/allowRepeat}}
  end
  --/audio
end

function _M:didShow(UI)
  -- audio
      {{#aplay}}
        {{#adelay}}
          local myClosure_{{aname}} = function()
        {{/adelay}}
               audio.setVolume({{avol}}, { channel={{achannel}} });
            {{#allowRepeat}}
                if {{atype}}.{{aname}} == nil then return end
               {{atype}}.{{aname}}x9 = audio.play({{atype}}.{{aname}}, {  channel={{achannel}}, loops={{aloop}}{{tofade}} } )
            {{/allowRepeat}}
            {{^allowRepeat}}
                if {{atype}}.{{aname}} == nil then return end
              audio.play({{atype}}.{{aname}}, {channel={{achannel}}, loops={{aloop}}{{tofade}} } )
            {{/allowRepeat}}
        {{#adelay}}
           end
           _K.timerStash.{{tm}} = timer.performWithDelay({{adelay}}, myClosure_{{aname}}, 1)
        {{/adelay}}
      {{/aplay}}
  --/audio
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
      {{#allowRepeat}}
        if ({{atype}}.{{aname}}x9 ~= 0) then
          audio.dispose({{atype}}.{{aname}})
          {{atype}}.{{aname}} = nil
          {{atype}}.{{aname}}x9 = 0
        end
      {{/allowRepeat}}
      {{^allowRepeat}}
        if ({{atype}}.{{aname}} ~= 0) then
          audio.dispose({{atype}}.{{aname}})
          {{atype}}.{{aname}} = nil
        end
        {{/allowRepeat}}
  {{/akeep}}
end

-- function audioDisposal(UI)
  -- audio
    -- {{^areadme}}
  --    { {{achannel}}, "_K.allAudios.{{aname}}"},
    -- {{/areadme}}
  --/audio
-- end
function _M:getAudio(UI)
  --UI.allAudios or _K.allAudios
  if {{atype}}.{{aname}} == nil then
    {{#alang}}
     {{atype}}.{{aname}} =  audio.{{loadType}}( _K.audioDir.._K.lang.."{{fileName}}", _K.systemDir)
    {{/alang}}
    {{^alang}}
     {{atype}}.{{aname}} =  audio.{{loadType}}( _K.audioDir.."{{fileName}}", _K.systemDir)
    {{/alang}}
  end
  return {{atype}}
end


return _M