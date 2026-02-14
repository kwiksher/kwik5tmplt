-------------------------------------------------------------------------------
-- Display Manager for BTree_test scenes
-- Uses shared implementation from lua_modules/kwiksher/kwik/behaivor
-------------------------------------------------------------------------------
local DisplayManagerCommon = require("behaivor.display_manager_common")

return DisplayManagerCommon.new({
    dialogue = {
        fontMultiplier = 0.5,
        autoButtonWidth = true,
        defaultButtonWidth = nil,
        buttonPadding = 22,
        useButtonFontSize = true,
        buttonReservedPadding = 40,
        leftPadding = 30,
        rightPadding = 30,
        minTextWidth = 150,
    }
})
