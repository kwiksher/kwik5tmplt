-------------------------------------------------------------------------------
-- Forest Choice Display Module
-- Manages player choice buttons for the forest scene
-- Inherits from choice_base.lua using metatable
-------------------------------------------------------------------------------

local choiceBase = require("Behavior.choice_base")
local behaviorConfig = require("Behavior.config")
local showChoicesAction = require("Behavior.TheLastSpark.actions.forest.show_choices_action")

-- Create a new instance that inherits from choiceBase
local M = choiceBase:new()

M.defaultStyle = behaviorConfig.getChoiceButtonStyle()

-------------------------------------------------------------------------------
-- Override: Callback when a choice is selected (forest-specific)
-- @param choice The value of the selected choice
-- @param button The button object that was tapped
-------------------------------------------------------------------------------
function M:onChoiceSelected(choice, button)
    self:_onChoiceSelected(choice, button, function()
      showChoicesAction.selectChoice()
    end)
end

-------------------------------------------------------------------------------
-- Override: Hides the choice buttons (forest-specific)
-------------------------------------------------------------------------------
function M:hideChoiceButtons()
  self:_hideChoiceButtons(function()
    showChoicesAction.choicesAreVisible = false
  end)
end

return M
