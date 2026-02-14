-------------------------------------------------------------------------------
-- Display Manager for TheLastSpark scenes
-- Uses shared implementation from lua_modules/kwiksher/kwik/behaivor
-------------------------------------------------------------------------------
local DisplayManagerFactory = require("Behavior.display_manager")

return DisplayManagerFactory.new({
        fontMultiplier = 0.5,
        autoButtonWidth = true,
        defaultButtonWidth = nil,
        buttonPadding = 10,
        useButtonFontSize = true,
        buttonReservedPadding = 40,
        leftPadding = 30,
        rightPadding = 30,
        minTextWidth = 150,
})
