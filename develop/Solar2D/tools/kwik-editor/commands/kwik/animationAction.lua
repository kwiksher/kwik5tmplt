-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
--
local app            = require "Application"
--
function _M:pauseAnimation(anim)
  if app.gt[anim] then
     app.gt[anim]:pause()
  elseif app.trans[anim] then
  	app.trans[anim]:pause()
  end
end
--
function _M:resumeAnimation(anim)
  if app.gt[anim] then
    app.gt[anim]:play()
  elseif app.trans[anim] then
    app.trans[anim]:resume()
  end
end
--
function _M:playAnimation(anim)
--	print(anim)
--	for k, v in pairs(app.trans) do print(k, v) end
  if app.gt[anim] then
    app.gt[anim]:toBeginning()
    app.gt[anim]:play()
  elseif app.trans[anim] then
		app.trans[anim]:resume()
  end
end
--
return _M