-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
{{#ultimate}}
local mX, mY = _K.ultimatePosition({{mX}}, {{mY}})
local dX, dY = _K.ultimatePosition({{mX}}+15, {{mY}}-30)
local elpad = {{elpad}}/4
local elFontSize = {{elFontSize}}/4
local audioImage = "kAudio.png"
local audioImageHi = "kAudio.png"
local speakW, speakH = 60/4, 60/4
{{/ultimate}}
{{^ultimate}}
local mX = {{mX}}
local mY = {{mY}}
local dX, dY = {{mX}}+15, {{mY}}-30
local elpad = {{elpad}}
local elFontSize = {{elFontSize}}
local audioImage = "kAudioHi.png"
local audioImageHi = "kAudioHi.png"
local speakW, speakH = 30, 30
{{/ultimate}}
--
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  local allAudios = requireKwik("components.page0{{page}}.page_audio_{{isReadme}}{{audio}}"):getAudio(UI)
  --
  {{#daTrigger}}
    _K.s{{trigger}} = function()
      UI.scene:dispatchEvent({name="action_{{trigger}}"})
    end
  {{/daTrigger}}

  layer.{{myLName}}_txt = {
  {{#daArr}}
    {{#da}}
    {
      start =  {{start}}, out = {{out}}, dur = {{dur}}, name = "{{name}}", file = "{{file}}", newline = true,
      {{#trigger}}
        trigger=_K.s{{trigger}},
      {{/trigger}}
    },
    {{/da}}
    {{^da}}
    {
      start =  {{start}}, out = {{out}}, dur = {{dur}}, name = "{{name}}", file = "{{file}}",
      {{#trigger}}
        trigger=_K.s{{trigger}},
      {{/trigger}}
    },
    {{/da}}
  {{/daArr}}
  }

  {{#isTmplt}}
  if _K.systemDir == system.ApplicationSupportDirectory then
    local ui = require("components.store.UI")
    ui.replaceTimeCodes(layer.{{myLName}}_txt, "p"..ui.currentPage.."_{{myLName}}.txt", "{{myLName}}")
  end
  {{/isTmplt}}

  {{#isTmplt}}
  {{#deviceH}}
    layer.speak{{spe}} =  display.newImageRect( "assets/images/".. audioImage,  speakW, speakH);
  {{/deviceH}}
  {{^deviceH}}
    layer.speak{{spe}} =  display.newImageRect( "assets/images/".. audioImage, 30, 30 );
  {{/deviceH}}
  {{/isTmplt}}
  {{^isTmplt}}
  {{#deviceH}}
    layer.speak{{spe}} =  display.newImageRect( _K.imgDir.. audioImage, _K.systemDir, speakW, speakH);
  {{/deviceH}}
  {{^deviceH}}
    layer.speak{{spe}} =  display.newImageRect( _K.imgDir.. audioImage, _K.systemDir, 30, 30 );
  {{/deviceH}}
  {{/isTmplt}}

  layer.speak{{spe}}.x = mX
  layer.speak{{spe}}.y = mY
  layer.speak{{spe}}.oriX = mX
  layer.speak{{spe}}.oriY = mY

  {{#elshow}}
    layer.speak{{spe}}.alpha = 1
  {{/elshow}}
  {{^elshow}}
    layer.speak{{spe}}.alpha = 0
  {{/elshow}}
  {{#um}}
    --Not show if multilanguage
    if (_K.lang ~= "{{um}}") then
        layer.speak{{spe}}.alpha = 0
    end
  {{/um}}
  sceneGroup:insert(layer.speak{{spe}})
  --
  {{#multLayers}}
    UI.tab{{um}}["{{dois}}"] = { dX, dY, elpad, allAudios.{{elaudio}}, layer.{{myLName}}_txt, {{sbut}}, {{elFont}}, {{elFontColor}}, elFontSize, {{elColorHi}}, {{elTouch}}, "{{rightLeft}}", {{vchan}} }
    {{^elshow}}
      -- send button out of screen
      layer.speak{{spe}}.x = -500
    {{/elshow}}
  {{/multLayers}}
  {{^multLayers}}
    layer.b_{{myLName}}, layer.{{myLName}} = _K.syncSound.addSentence{
{{#ultimate}}
  {{#elshow}}
        x            = dX + elpad*2,
        y            = dY,
  {{/elshow}}
  {{^elshow}}
        x            = dX,
        y            = dY,
  {{/elshow}}
{{/ultimate}}
{{^ultimate}}
        x            = dX,
        y            = dY,
{{/ultimate}}
        padding      = elpad,
        sentence     = allAudios.{{elaudio}},
        volume       = {{avol}},
        line         = layer.{{myLName}}_txt,
        button       = {{sbut}},
        font         = {{elFont}},
        fontColor    = { {{elFontColor}} },
        fontSize     = elFontSize,
        fontColorHi  = { {{elColorHi}} },
        fadeDuration = {{afade}},
        wordTouch    = {{elTouch}},
        readDir      = "{{rightLeft}}",
        sentenceDir  = {{elTouchFolder}},
        channel      = {{vchan}},
        lang         = ""
    }

    --layer.{{myLName}}:translate(-layer.{{myLName}}.width/2, 0 )

    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = layer.{{myLName}}
    --
    {{^elshow}}
      -- send button out of screen
      layer.speak{{spe}}.x = -500
    {{/elshow}}
  {{/multLayers}}
end
--
function _M:vcall()
end
--
function _M:toDestroy()
  {{^multLayers}}
  {{#daTrigger}}
    _K.s{{trigger}} = nil
  {{/daTrigger}}
  {{/multLayers}}
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
{{^multLayers}}
{{#elaudio}}
{{#autoPlay}}
    local allAudios = requireKwik("components.page0{{page}}.page_audio_{{isReadme}}{{audio}}"):getAudio(UI)
      _K.timerStash.timer_AP1 = timer.performWithDelay( {{eldelay}},
        function()
        _K.syncSound.saySentence( {
          sentence= allAudios.{{elaudio}},
          line=layer.{{myLName}}_txt,
          button=layer.b_{{myLName}} })
      end)
{{/autoPlay}}
{{/elaudio}}
{{/multLayers}}
end
--
function _M:toDispose()
end
--
function _M:localVars(UI)
  {{#isTmplt}}
   mX, mY, imageWidth, imageHeight , imagePath = _K.getModel("{{myLName}}", imagePath, UI.dummy)
   mX = mX - imageWidth/2
   mY = mY - imageHeight/2
   dX, dY = _K.getModel("{{myLName}}", imagePath, UI.dummy, 15, -30)
   dX = dX-imageWidth/2
  {{/isTmplt}}
end
--
return _M