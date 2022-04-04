-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
-----------------------------
-- {{#extlib}}
-- local {{name}} = requireKwik("{{libname}}")
-- {{/extlib}}
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			-- Adding external code
			-- {{#extCode}}
			--     {{ccode}}
			--     {{arqCode}}
			-- {{/extCode}}
		end
	end
	return command
end
--
return _Command