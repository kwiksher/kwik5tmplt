-- $weight=1
--
local M = {}
M.name = ...

function M:init(UI)
end
--
function M:create(UI)
	print("create", self.name)
	local sceneGroup = UI.sceneGroup

end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destroy()
end
--
return M