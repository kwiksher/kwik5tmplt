-------------------------------------------------------------------------------
-- Main Entry Point for BTree Test Application
-- Demonstrates simple behavior tree with animation and button scenes
-------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Require Composer for scene management
local composer = require("composer")

-- Start with the animation scene
print("\n=== Starting BTree Test Application ===")
print("Starting with animation scene...\n")
composer.gotoScene("views.animationScene")
