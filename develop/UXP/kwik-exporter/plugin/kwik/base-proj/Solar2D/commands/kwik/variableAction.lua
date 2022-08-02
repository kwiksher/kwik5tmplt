-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local Var = require("components.kwik.vars")
--
function _M:restartTrackVars(params)
	Var:zeroesKwikVars()
end
--
return _M
