-------------------------------------------------------------------------------
-- Cabin Choice Display Module
-- Manages player choice buttons for the cabin scene
-- Inherits from choice_base.lua using metatable
-------------------------------------------------------------------------------

local choiceBase = require("views.choice_base")
local showChoicesAction = require("actions.cabin.show_choices_action")

-- Create a new instance that inherits from choiceBase
local M = choiceBase:new()

-------------------------------------------------------------------------------
-- Override: Callback when a choice is selected (cabin-specific)
-- @param choice The value of the selected choice
-- @param button The button object that was tapped
-------------------------------------------------------------------------------
function M:onChoiceSelected(choice, button)
    self:_onChoiceSelected(choice, buttons, function()
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
