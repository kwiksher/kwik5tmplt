-- Audio Actions (Cabin Scene)
-- Manages audio playback using audio_helper
-- Uses audio_helper to create module from cabin_model

local audioHelper = require("behaivor.audio_helper")

-- Create audio action module from cabin model
return audioHelper.new("models.cabin.cabin_model", "Cabin Audio Actions")
