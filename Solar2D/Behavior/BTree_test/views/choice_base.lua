-------------------------------------------------------------------------------
-- Choice Base Module
-- BTree_test wrapper for shared choice base implementation
-------------------------------------------------------------------------------

local ChoiceBaseCommon = require("behaivor.choice_base_common")

return ChoiceBaseCommon:new({
    defaultStyle = {
        width = 25,
        height = 8,
        cornerRadius = 4,
        fillColor = {0.2, 0.3, 0.5},
        strokeColor = {0.8, 0.8, 0.8},
        strokeWidth = 2,
        font = native.systemFontBold,
        fontSize = 10,
        textColor = {1, 1, 1},
        paddingHorizontal = 12,
        paddingVertical = 6,
    }
})
