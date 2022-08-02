-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local ActionCommand = {}
--
local Var = require("components.kwik.vars")
local _K = require "Application"
--
function ActionCommand:new()
	local command = {}
	--
	function command:execute(params)
		local UI         = params.UI
		local sceneGroup = UI.scene.view
		local layer      = UI.layer
		local phase     = params.event.phase

		{{#global}}
			_K.{{vvar}} = {{vval}}
		{{/global}}
		{{^global}}
			UI.{{vvar}} = {{vval}}
		{{/global}}

		{{#save}}
        {{#global}}
           Var:saveKwikVars({"{{vvar}}", _K.{{vvar}} })
        {{/global}}
        {{^global}}
          Var:saveKwikVars({"{{vvar}}", UI.{{vvar}} })
        {{/global}}
		{{/save}}
		
		{{#dynatxtArr}}
		{{#global}}
			layer.{{vlay}}.text = _K.{{vvar}}
		{{/global}}
		{{^global}}
			layer.{{vlay}}.text = UI.{{vvar}}
		{{/global}}
		{{/dynatxtArr}}
		end
		return command
end
--
return ActionCommand