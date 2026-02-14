local BaseSceneCommon = require("behaivor.base_scene_common")

return BaseSceneCommon.new({
    returningSceneName = "Behavior.BTree_test.views.emptyScene",
    resetUiOnShow = true,
    resetPlayerChoice = true,
    resetTreeStarted = true,
    callResetActionModules = true,
    enableAutoTick = true,
    autoTickDelay = 100,
    autoTickTag = "behaviorTreeTick",
    cancelBlinkTag = true,
    verboseButtonLogs = true,
})
