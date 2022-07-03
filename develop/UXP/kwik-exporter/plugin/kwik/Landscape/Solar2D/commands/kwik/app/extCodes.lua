-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
{{each(options.extlib)}}
local {{@this.name}} = requireKwik("{{@this.libname}}")
{{/each}}
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			-- Adding external code
			{{if(options.extCode)}}
			{{each(options.extCode)}}
			    {{@this.ccode}}
			    {{@this.arqCode}}
			{{/each}}
			{{/if}}
		end
	end
	return command
end
--
return _Command