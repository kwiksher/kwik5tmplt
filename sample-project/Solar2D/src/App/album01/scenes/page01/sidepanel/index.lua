local M = {}
M.name = ...
M.weight = 1
---
function M:init(UI)
end
--
function M:create(UI)
	print("create", self.name)
	local sceneGroup = UI.scene.view
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destory()
end
--
return M