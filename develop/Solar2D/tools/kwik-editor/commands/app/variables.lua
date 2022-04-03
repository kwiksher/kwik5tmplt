-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local app            = require "Application"
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			app.kwk_readMe = 0
			app.kBidi     = {{use.bidi}}
			app.kAutoPlay = 0
			app.goPage    = {{curPage}}
		end
	end
	return command
end
--
return _Command