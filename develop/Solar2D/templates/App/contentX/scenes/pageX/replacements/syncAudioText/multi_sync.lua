-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K = require "Application"
--
function _M:localPos(UI)
end
--
function _M:vcall()
end
--
function _M:toDestroy()
end
--
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  if UI.tSearch["{{bn}}"] == nil then return end
  {{#multLayers}}
    layer.b_{{myLName}}, layer.{{myLName}} = _K.syncSound.addSentence{
      x           = UI.tSearch["{{dois}}"][1],
      y           = UI.tSearch["{{dois}}"][2],
      padding     = UI.tSearch["{{dois}}"][3],
      sentence    = UI.tSearch["{{dois}}"][4],
      volume      = {{avol}},
      sentenceDir = "audio",
      line        = UI.tSearch["{{dois}}"][5],
      button      = UI.tSearch["{{dois}}"][6],
      font        = UI.tSearch["{{dois}}"][7],
      fontColor   = {
        UI.tSearch["{{dois}}"][8],
        UI.tSearch["{{dois}}"][9],
        UI.tSearch["{{dois}}"][10]
      },
      fontSize = UI.tSearch["{{dois}}"][11],
      fontColorHi = {
        UI.tSearch["{{dois}}"][12],
        UI.tSearch["{{dois}}"][13],
        UI.tSearch["{{dois}}"][14]
      },
      fadeDuration = {{afade}},
      wordTouch    = UI.tSearch["{{dois}}"][15],
      readDir      = UI.tSearch["{{dois}}"][16],
      channel      = UI.tSearch["{{dois}}"][17],
      lang         = _K.lang
    }
    sceneGroup:insert( layer.{{myLName}})
    sceneGroup.{{myLName}} = {{myLName}}

    {{#elaudioKwk}}
    {{#autoPlay}}
      _K.timerStash.timer_AP1 = timer.performWithDelay( {{eldelay}}, function()
        _K.syncSound.saySentence{sentence= UI.tSearch["{{dois}}"][4],line=UI.tSearch["{{dois}}"][5], button=layer.b_{{myLName}}
      }
      end)
    {{/autoPlay}}
    {{/elaudioKwk}}
  {{/multLayers}}
end
--
function _M:toDispose()
  {{#multLayers}}
  {{#daTrigger}}
    _K.s{{trigger}} = nil
  {{/daTrigger}}
  {{/multLayers}}
end
--
function _M:localVars()
end
--
return _M