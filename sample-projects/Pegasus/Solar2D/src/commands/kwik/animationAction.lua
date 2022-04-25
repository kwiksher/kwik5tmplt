-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local _K            = require "Application"
--
function _M:pauseAnimation(anim)
  if _K.gt[anim] then
     _K.gt[anim]:pause()
  elseif _K.trans[anim] then
  	_K.trans[anim]:pause()
  end
end
--
function _M:resumeAnimation(anim)
  if _K.gt[anim] then
    _K.gt[anim]:play()
  elseif _K.trans[anim] then
    _K.trans[anim]:resume()
  end
end
--
function _M:playAnimation(anim)
--	print(anim)
--	for k, v in pairs(_K.trans) do print(k, v) end
  if _K.gt[anim] then
    _K.gt[anim]:toBeginning()
    _K.gt[anim]:play()
  elseif _K.trans[anim] then
		_K.trans[anim]:resume()
  end
end
--
return _M