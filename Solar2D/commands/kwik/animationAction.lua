local M = {}
--
local App            = require "controller.Application"
--
function M:pause(anim)
  if App.gt[anim] then
     App.gt[anim]:pause()
  elseif App.trans[anim] then
  	App.trans[anim]:pause()
  end
end
--
function M:resume(anim)
  if App.gt[anim] then
    App.gt[anim]:play()
  elseif App.trans[anim] then
    App.trans[anim]:resume()
  end
end
--
function M:play(anim)
	print(anim)
--	for k, v in pairs(App.trans) do print(k, v) end
  if App.gt[anim] then
    App.gt[anim]:toBeginning()
    App.gt[anim]:play()
  elseif App.trans[anim] then
		App.trans[anim]:resume()
  end
end
--
return M