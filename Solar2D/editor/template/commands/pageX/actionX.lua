-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local ActionCommand = {}
local AC           = require("commands.kwik.actionCommand")
--
-----------------------------
-----------------------------
function ActionCommand:new()
	local command = {}
	--
	function command:execute(params)
		local UI         = params.UI
		local sceneGroup = UI.sceneGroup
		local layers      = UI.layers
		local obj        = params.obj

    local conditions = require("App." .. UI.book..".common.conditions")
    local expressions = require("App." .. UI.book.."common.expressions")

{{#actions}}

  {{#condition}}
    {{#__if}}
    if {{exp1}}  {{exp1Op}} {{exp1Comp}} {{exp2Cond}}  {{exp2}}  {{exp2Op}} {{exp2Comp}} then
    {{/__if}}

    {{#__if_}}
    if {{condition}} then
    {{/__if_}}

    {{#_else}}
    else
    {{/_else}}

    {{#_elseif}}
    elseif {{exp1}}  {{exp1Op}} {{exp1Comp}} {{exp2Cond}}  {{exp2}}  {{exp2Op}} {{exp2Comp}} then
    {{/_elseif}}

    {{#_elseif_}}
    elseif {{condition}} then
    {{/_elseif_}}

    {{#_end}}
    end
    {{/_end}}
  {{/condition}}

  {{#loop}}
    {{#_while}}
      while  {{condition}} do
    {{/_while}}

    {{#_for_next}}
    for {{i_exp}}, {{v_exp}, in next, {{t_exp}} do
    {{/_for_next}}

    {{#_for_pairs}}
    for {{k_exp}}, {{v_exp}, in pairs( {{t_exp}} ) do
    {{/_for_pairs}}

    {{#_end}}
    end
    {{/_end}}

    {{#_repeat}}
      repeat
    {{/_repeat}}

    {{#_untl}}
      until( {{condition}} )
    {{/_until}}

  {{#loop}}

  {{#animation}}
    --
    -- target layer :sceneGroup[layerName]
    -- target animation : layer.animations[index]
    --
    {{#pause}}
      AC.Animation:pause("{{target}}")
    {{/pause}}
    {{#resume}}
      AC.Animation:resume("{{target}}")
    {{/resume}}
    {{#play}}
      AC.Animation:play("{{target}}", {{index}})
    {{/play}}
  {{/animation}}
  {{#button}}
    {{#onOff}}
     AC.Button:onOff("{{target}}", {{enable}}, {{toggle}} ) -- enable, toggle
    {{/onOff}}
  {{/button}}
{{/actions}}
	end
	return setmetatable( command, {__index=AC})
end
--
return ActionCommand