local BaseSceneCommon = require("behaivor.base_scene_common")

local M = {}

function M.new(options)
    return BaseSceneCommon.new(options or {})
end

return M
