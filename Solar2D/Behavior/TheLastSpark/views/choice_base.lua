-------------------------------------------------------------------------------
-- Choice Base Module
-- TheLastSpark wrapper for shared choice base implementation
-------------------------------------------------------------------------------

local ChoiceBaseCommon = require("behaivor.choice_base_common")

return ChoiceBaseCommon:new({
    defaultStyle = {
        width = 200,
        height = 60,
        cornerRadius = 12,
        fillColor = {0.2, 0.3, 0.5},
        strokeColor = {0.8, 0.8, 0.8},
        strokeWidth = 3,
        font = native.systemFontBold,
        fontSize = 24,
        textColor = {1, 1, 1},
    }
})
