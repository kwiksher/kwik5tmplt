-------------------------------------------------------------------------------
-- Main Entry Point for Solar2D Application - The Last Spark
-- This file demonstrates BTree-driven scene flow
-------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Require Composer for scene management
local composer = require("composer")

-- Start with the forest scene
composer.gotoScene("forestScene")