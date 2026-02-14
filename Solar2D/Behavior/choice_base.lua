local ChoiceBaseCommon = require("behaivor.choice_base_common")

local M = {}

function M.new(defaultStyle)
    return ChoiceBaseCommon:new({
        defaultStyle = defaultStyle or {}
    })
end

return M
