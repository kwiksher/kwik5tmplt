-------------------------------------------------------------------------------
-- Choice Base Module
-- Base module for creating and managing player choice buttons
-- Provides reusable functions for choice button creation across all scenes
-------------------------------------------------------------------------------

local M = {}

-- Default style configuration for choice buttons
M.defaultStyle = {
    width = 100,
    height = 30,
    cornerRadius = 8,
    fillColor = {0.2, 0.3, 0.5},
    strokeColor = {0.8, 0.8, 0.8},
    strokeWidth = 3,
    font = native.systemFontBold,
    fontSize = 18,
    textColor = {1, 1, 1}
}

-------------------------------------------------------------------------------
-- Creates a single choice button with label
-- @param parentGroup Display group to add button to
-- @param label Text label for the button
-- @param x X position
-- @param y Y position
-- @param choiceValue Value to set when button is tapped
-- @param onChoiceSelected Callback function when choice is selected
-- @param style Optional style overrides (table)
-- @return button display object with label property
-------------------------------------------------------------------------------
function M.createChoiceButton(parentGroup, label, x, y, choiceValue, onChoiceSelected, style)
    style = style or {}

    -- Merge with default style
    local buttonStyle = {
        width = style.width or M.defaultStyle.width,
        height = style.height or M.defaultStyle.height,
        cornerRadius = style.cornerRadius or M.defaultStyle.cornerRadius,
        fillColor = style.fillColor or M.defaultStyle.fillColor,
        strokeColor = style.strokeColor or M.defaultStyle.strokeColor,
        strokeWidth = style.strokeWidth or M.defaultStyle.strokeWidth,
        font = style.font or M.defaultStyle.font,
        fontSize = style.fontSize or M.defaultStyle.fontSize,
        textColor = style.textColor or M.defaultStyle.textColor
    }

    -- Create button background
    local button = display.newRoundedRect(
        parentGroup,
        x,
        y,
        buttonStyle.width,
        buttonStyle.height,
        buttonStyle.cornerRadius
    )
    button.strokeWidth = buttonStyle.strokeWidth
    button:setFillColor(unpack(buttonStyle.fillColor))
    button:setStrokeColor(unpack(buttonStyle.strokeColor))

    -- Create button text
    local buttonText = display.newText({
        parent = parentGroup,
        text = label,
        x = x,
        y = y,
        font = buttonStyle.font,
        fontSize = buttonStyle.fontSize
    })
    buttonText:setFillColor(unpack(buttonStyle.textColor))

    -- Initially hide button
    button.isVisible = false
    buttonText.isVisible = false

    -- Store reference to label
    button.label = buttonText
    button.choiceValue = choiceValue

    -- Add tap listener
    button:addEventListener("tap", function()
        if onChoiceSelected then
            onChoiceSelected(choiceValue, button)
        end
    end)

    return button
end

-------------------------------------------------------------------------------
-- Creates a set of choice buttons from a configuration table
-- @param parentGroup Display group to add buttons to
-- @param choices Array of choice configurations: {label, x, y, value}
-- @param onChoiceSelected Callback function when any choice is selected
-- @param style Optional style overrides
-- @return table of button objects indexed by choice value
-------------------------------------------------------------------------------
function M.createChoiceButtons(parentGroup, choices, onChoiceSelected, style)
    local buttons = {}

    for _, choice in ipairs(choices) do
        local button = M.createChoiceButton(
            parentGroup,
            choice.label,
            choice.x,
            choice.y,
            choice.value,
            onChoiceSelected,
            style
        )
        buttons[choice.value] = button
    end

    return buttons
end

-------------------------------------------------------------------------------
-- Shows all buttons in a button set
-- @param buttons Table of button objects
-------------------------------------------------------------------------------
function M.showButtons(buttons)
    for _, button in pairs(buttons) do
        if button and button.label then
            button.isVisible = true
            button.label.isVisible = true
        end
    end
end

-------------------------------------------------------------------------------
-- Hides all buttons in a button set
-- @param buttons Table of button objects
-------------------------------------------------------------------------------
function M.hideButtons(buttons)
    for _, button in pairs(buttons) do
        if button and button.label then
            button.isVisible = false
            button.label.isVisible = false
        end
    end
end

-------------------------------------------------------------------------------
-- Removes all buttons in a button set
-- @param buttons Table of button objects
-------------------------------------------------------------------------------
function M.removeButtons(buttons)
    for _, button in pairs(buttons) do
        if button then
            if button.label then
                button.label:removeSelf()
            end
            button:removeSelf()
        end
    end
end

-------------------------------------------------------------------------------
-- Brings the choice group to the front of display hierarchy
-- @param parentGroup The group containing the choice buttons
-------------------------------------------------------------------------------
function M.bringToFront(parentGroup)
    if parentGroup then
        parentGroup:toFront()
    end
end

-------------------------------------------------------------------------------
-- Initializes the choice display system (base implementation)
-- @param sceneGroup The main scene group to add choice group to
-- @param sceneObjs Reference to scene objects for callbacks
-- @param treeController Reference to behavior tree controller
-- @param choices Table of choice definitions from layout
-- @return choice group
-------------------------------------------------------------------------------
function M:initialize(sceneGroup, sceneObjs, treeController, choices)
    -- Create a separate group for choice buttons (on top of everything)
    self.choiceGroup = display.newGroup()
    sceneGroup:insert(self.choiceGroup)

    -- Store references
    self.sceneObjs = sceneObjs
    self.treeController = treeController

    -- Create buttons using base module with provided choices
    self.buttons = M.createChoiceButtons(
        self.choiceGroup,
        choices,
        function(choice, button) self:onChoiceSelected(choice, button) end,
        nil  -- Use default style
    )

    return self.choiceGroup
end

-------------------------------------------------------------------------------
-- Callback when a choice is selected (base implementation)
-- @param choice The value of the selected choice
-- @param button The button object that was tapped
-------------------------------------------------------------------------------
function M:_onChoiceSelected(choice, button, callback)
    print("Player chose: " .. choice)

    -- Set the player choice in scene objects
    if self.sceneObjs then
        self.sceneObjs.playerChoice = choice
    end

    -- Hide all choice buttons
    self:hideChoiceButtons()

    callback()

    -- Advance behavior tree
    if self.treeController and not self.treeController.isComplete then
        self.treeController:tick()
    end
end

-------------------------------------------------------------------------------
-- Shows the choice buttons (base implementation)
-------------------------------------------------------------------------------
function M:showChoiceButtons()
    -- Hide Next button when showing choices
    if self.sceneObjs and self.sceneObjs.nextButton then
        self.sceneObjs.nextButton.isVisible = false
    end

    -- Bring choice group to absolute front
    M.bringToFront(self.choiceGroup)

    -- Show all buttons
    M.showButtons(self.buttons)
end

-------------------------------------------------------------------------------
-- Hides the choice buttons (base implementation)
-------------------------------------------------------------------------------
function M:_hideChoiceButtons(callback)
   callback()
    -- Hide Next button (let narration/audio control it)
    if self.sceneObjs and self.sceneObjs.nextButton then
        self.sceneObjs.nextButton.isVisible = false
    end

    -- Hide all buttons
    M.hideButtons(self.buttons)
end

-------------------------------------------------------------------------------
-- Cleans up the choice display system (base implementation)
-------------------------------------------------------------------------------
function M:cleanup()
    if self.buttons then
        M.removeButtons(self.buttons)
        self.buttons = {}
    end

    if self.choiceGroup then
        self.choiceGroup:removeSelf()
        self.choiceGroup = nil
    end

    self.sceneObjs = nil
    self.treeController = nil
end

-------------------------------------------------------------------------------
-- Creates a new instance of the choice display
-- @return new instance with metatable set to M
-------------------------------------------------------------------------------
function M:new()
    local instance = {}
    setmetatable(instance, {__index = self})
    return instance
end

-- Set M as its own metatable for inheritance
M.__index = M

return M
