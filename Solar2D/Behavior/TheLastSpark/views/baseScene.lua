-------------------------------------------------------------------------------
-- Base Scene - Common scene functionality for inheritance
-------------------------------------------------------------------------------
local BaseSceneFactory = require("Behavior.baseScene")

return BaseSceneFactory.new({
    resetUiOnShow = false,
    resetPlayerChoice = false,
    resetTreeStarted = false,
    callResetActionModules = false,
    enableAutoTick = false,
    cancelBlinkTag = false,
    verboseButtonLogs = false,
})
