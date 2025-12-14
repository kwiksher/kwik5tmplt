-------------------------------------------------------------------------------
-- Main Entry Point for Solar2D Application - The Last Spark
-- This file demonstrates BTree-driven scene flow
-------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Require Composer for scene management
local composer = require("composer")

-- Start with the forest scene
--composer.gotoScene("views.forest.forestScene")
composer.gotoScene("views.cabin.cabinScene")


--Start automated test after scene loads
timer.performWithDelay(1000, function()
    print("\n=== Starting Automated Cabin Test (Jump to Choices) ===\n")
    local cabinTest = require("tests.cabinSceneTest")
    cabinTest.start()
end)
