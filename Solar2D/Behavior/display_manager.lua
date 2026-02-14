local DisplayManagerCommon = require("behaivor.display_manager_common")

local M = {}

function M.new(dialogueOptions)
    return DisplayManagerCommon.new({
        dialogue = dialogueOptions or {}
    })
end

return M
