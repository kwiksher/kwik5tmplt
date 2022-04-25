-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
---------------------
-- External libraries
local _K = require "Application"
  {{#extLib}}
    local {{name}} = requireKwik("{{libname}}")
  {{/extLib}}
--
{{#TV}}
local kInputDevices = require("extlib.tv.kInputDevices")
{{/TV}}

function _M:localVars(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    {{#extCodeTop}}
    {{ccode}}
    {{arqCode}}
    {{/extCodeTop}}
end
--
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    {{#extCodeMid}}
    {{ccode}}
    {{arqCode}}
    {{/extCodeMid}}
end
--
function _M:didShow(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer

    {{#TV}}
    kInputDevices:initGroup()
    {{/TV}}

    {{#extCodeBtm}}
    {{ccode}}
    {{arqCode}}
    {{/extCodeBtm}}

    {{#TV}}
    kInputDevices:willShow()
    kInputDevices:didShow()
    {{/TV}}

end
--
function _M:toDispose(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
    {{#extCodeDsp}}
    {{ccode}}
    {{arqCode}}
    {{/extCodeDsp}}

    {{#TV}}
    kInputDevices:willHide()
    kInputDevices:didHide()
    {{/TV}}

end
--
return _M