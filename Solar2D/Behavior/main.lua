-------------------------------------------------------------------------------
-- Unified Main Entry for Behavior tests
-- Set `_G.BTREE_TEST_APP` to `TheLastSpark` or `BTree_test`
-- Optional: set `_G.BTREE_TEST_SCENE` to override starting scene
-------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
local appName = _G.BTREE_TEST_APP or "TheLastSpark"

local defaults = {
    BTree_test = "views.animation.animationScene",
    TheLastSpark = "views.forest.forestScene",
}

local sceneName = _G.BTREE_TEST_SCENE or defaults[appName]
if not sceneName then
    error("Unknown BTREE_TEST_APP: " .. tostring(appName))
end

local resourcePath = system.pathForFile("", system.ResourceDirectory)
package.path = resourcePath .. "/" .. appName .. "/?.lua;" ..
               resourcePath .. "/" .. appName .. "/?/?.lua;" ..
               package.path

print("\n=== Starting Behavior Test ===")
print("App: " .. tostring(appName))
print("Scene: " .. tostring(sceneName) .. "\n")

composer.gotoScene(sceneName)
