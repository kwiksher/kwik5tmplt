-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local Var = require("components.kwik.vars")
local _K   = require("Application")
---------------------
-- External libraries
--
function _M:localPos(UI)
    local sceneGroup  = UI.scene.view
    local layer       = UI.layer
  {{#after}}
  {{#vtype}}
    {{#vtable}}
        _K.{{vname}} = { {{vvalue}} }
      {{/vtable}}
      {{^vtable}}
        _K.{{vname}} = {{vvalue}}
      {{/vtable}}
  {{/vtype}}
  {{^vtype}}
    {{#vtable}}
        UI.{{vname}} = { {{vvalue}} }
      {{/vtable}}
      {{^vtable}}
        UI.{{vname}} = {{vvalue}}
      {{/vtable}}
  {{/vtype}}
  {{/after}}
end
--
function _M:didShow(UI)
  {{#after}}
  {{#vtype}}
      {{#vsave}}
         -- Check if variable has a pre-saved content
         if Var:kwkVarCheck("{{vname}}") ~= nil then
            _K.{{vname}} = Var:kwkVarCheck("{{vname}}")
         end
      {{/vsave}}
  {{/vtype}}
  {{^vtype}}
      {{#vsave}}
         -- Check if variable has a pre-saved content
         if Var:kwkVarCheck("{{vname}}") ~= nil then
            UI.{{vname}} = Var:kwkVarCheck("{{vname}}")
         end
      {{/vsave}}
  {{/vtype}}
  {{/after}}
end
--
function _M:toDispose(UI)
    {{#vsave}}
      {{#vtype}}
        Var:saveKwikVars({"{{vname}}", _K.{{vname}} })
      {{/vtype}}
      {{^vtype}}
        Var:saveKwikVars({"{{vname}}", UI.{{vname}} })
      {{/vtype}}
    {{/vsave}}
end
--
function _M:localVars(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  {{#before}}
  {{#vtype}}
    {{#vtable}}
        _K.{{vname}} = { {{vvalue}} }
      {{/vtable}}
      {{^vtable}}
        _K.{{vname}} = {{vvalue}}
      {{/vtable}}
      {{#vsave}}
         -- Check if variable has a pre-saved content
         if Var:kwkVarCheck("{{vname}}") ~= nil then
            _K.{{vname}} = Var:kwkVarCheck("{{vname}}")
         end
      {{/vsave}}
  {{/vtype}}
  {{^vtype}}
    {{#vtable}}
        UI.{{vname}} = { {{vvalue}} }
      {{/vtable}}
      {{^vtable}}
        UI.{{vname}} = {{vvalue}}
      {{/vtable}}
      {{#vsave}}
         -- Check if variable has a pre-saved content
         if Var:kwkVarCheck("{{vname}}") ~= nil then
            UI.{{vname}} = Var:kwkVarCheck("{{vname}}")
         end
      {{/vsave}}
  {{/vtype}}
  {{/before}}
end
--
return _M