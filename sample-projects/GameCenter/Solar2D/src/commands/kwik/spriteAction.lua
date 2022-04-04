-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
function _M:playSprite(obj, seq)
		obj:setSequence(seq)
		obj:play()
end
--
function _M:pauseSprite(obj)
  	obj:pause()
end
--
return _M