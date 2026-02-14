-------------------------------------------------------------------------------
-- Base Scene - Common scene functionality for inheritance
-------------------------------------------------------------------------------
local BaseSceneCommon = require("behaivor.base_scene_common")

return BaseSceneCommon.new({
    resetUiOnShow = false,
    resetPlayerChoice = false,
    resetTreeStarted = false,
    callResetActionModules = false,
    enableAutoTick = false,
    cancelBlinkTag = false,
    verboseButtonLogs = false,
})
