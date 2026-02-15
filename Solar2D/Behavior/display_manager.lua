local DisplayManagerCommon = require("behaivor.display_manager_common")

local M = {}
local defaultManager = DisplayManagerCommon.new({
    dialogue = {},
})

function M.new(dialogueOptions)
    return DisplayManagerCommon.new({
        dialogue = dialogueOptions or {}
    })
end

setmetatable(M, {
    __index = defaultManager,
})

return M
