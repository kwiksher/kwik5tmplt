-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
local _K = require("Application")
---------------------
---------------------
function _M:localPos(UI)
	local sceneGroup  = UI.scene.view
	local layer       = UI.layer
		{{#nativeobj}}
	     layer.{{gname}}.alpha = 0
		{{/nativeobj}}
end
--
function _M:didShow(UI)
	local layer       = UI.layer
		{{#dispobj}}
	layer.{{gname}}.alpha = 0
	{{/dispobj}}
end
--
function _M:toDispose()
end

function _M:willHide()
end

--
function _M:localVars()
end
--
return _M