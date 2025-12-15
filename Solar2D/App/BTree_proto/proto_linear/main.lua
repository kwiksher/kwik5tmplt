-------------------------------------------------------------------------------
-- Main Game File - The Last Spark
-------------------------------------------------------------------------------

local composer = require("composer")

-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Set default background color
display.setDefault("background", 0.1, 0.1, 0.2)

-- Initialize audio
audio.reserveChannels(3) -- Reserve channels for music, SFX, and VO

-- Global game data
gameData = {
    currentScene = "forestScene",
    playerChoice = nil,
    hasLuminSeed = true
}

-- Load the first scene
composer.gotoScene("forestScene")