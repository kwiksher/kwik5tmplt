-- Audio Actions
-- Consolidated actions for ambient/background audio
-- Uses audio_helper to create module from forest_model

local audioHelper = require("utils.audio_helper")

-- Create audio module from forest model
return audioHelper.new("models.forest_model", "Audio Actions")