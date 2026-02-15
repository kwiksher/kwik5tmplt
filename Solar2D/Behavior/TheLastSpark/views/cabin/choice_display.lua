-------------------------------------------------------------------------------
-- Cabin Choice Display Module
-- Manages player choice buttons for the cabin scene
-- Inherits from choice_base.lua using metatable
-------------------------------------------------------------------------------

local choiceBase = require("Behavior.choice_base")
local showChoicesAction = require("Behavior.TheLastSpark.actions.cabin.show_choices_action")

-- Create a new instance that inherits from choiceBase
local M = choiceBase:new()

M.defaultStyle = {
  width = 160,
  height = 44,
  cornerRadius = 10,
  fillColor = {0.2, 0.3, 0.5},
  strokeColor = {0.8, 0.8, 0.8},
  strokeWidth = 2,
  font = native.systemFontBold,
  fontSize = 18,
  textColor = {1, 1, 1},
  paddingHorizontal = 16,
  paddingVertical = 10,
}

-------------------------------------------------------------------------------
-- Override: Callback when a choice is selected (cabin-specific)
-- @param choice The value of the selected choice
-- @param button The button object that was tapped
-------------------------------------------------------------------------------
function M:onChoiceSelected(choice, button)
    self:_onChoiceSelected(choice, button, function()
      showChoicesAction.selectChoice()
    end)
end

-------------------------------------------------------------------------------
-- Override: Hides the choice buttons (cabin-specific)
-------------------------------------------------------------------------------
function M:hideChoiceButtons()
  self:_hideChoiceButtons(function()
    showChoicesAction.choicesAreVisible = false
  end)
end

return M
