-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _Command = {}
local _K            = require "Application"
-----------------------------
-----------------------------
function _Command:new()
	local command = {}
	--
	function command:execute(params)
		local event         = params.event
		if event=="init" then
			_K.kwk_readMe = 0
			_K.kBidi     = {{use.bidi}}
			_K.kAutoPlay = 0
			_K.goPage    = {{curPage}}
		end
	end
	return command
end
--
return _Command