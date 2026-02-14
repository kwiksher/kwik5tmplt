-- Audio Actions
-- Consolidated actions for ambient/background audio
-- Uses audio_helper to create module from forest_model

local audioHelper = require("behaivor.audio_helper")

-- Create audio module from forest model
return audioHelper.new("models.forest.forest_model", "Audio Actions")