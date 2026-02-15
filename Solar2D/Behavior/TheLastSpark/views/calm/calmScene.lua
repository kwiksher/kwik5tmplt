-------------------------------------------------------------------------------
-- Calm Scene View - BTree Implementation
-------------------------------------------------------------------------------
local BaseScene = require("Behavior.baseScene")
local behaviorConfig = require("Behavior.config")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("calm")

-- Layout configuration
local layout = {
    background = "images/bg_calm.png",
}

local uiLayout = behaviorConfig.getDialogueLayout()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Use BaseScene initialization for display
    self:initializeDisplay(sceneGroup, {
        background = layout.background,
    })

    -- Use BaseScene initialization for dialogue interface
    self:initializeDialogueInterface(function()
        -- TODO: Add behavior tree controller here
        print("Calm scene: Next button pressed")
    end, {
        x = uiLayout.safeCenterX,
        y = uiLayout.dialogY,
        width = uiLayout.dialogWidth,
        height = uiLayout.dialogHeight,
        buttonLabel = "Next",
        buttonX = uiLayout.buttonX,
        buttonY = uiLayout.nextButtonY,
        textWidth = uiLayout.dialogTextWidth,
        textHeight = uiLayout.dialogTextHeight,
        fontSize = uiLayout.dialogueFontSize,
        buttonHeight = uiLayout.buttonHeight,
        buttonWidth = uiLayout.buttonWidth
    })

    -- Display placeholder text
    if self.objs.dialogueText then
        self.objs.dialogueText.text = "CALM SCENE - You offer the Lumin Seed, calming the corrupted wolf..."
    end
end

function scene:show(event)
    -- Call BaseScene's onShow
    self:onShow(event.phase)
end

function scene:hide(event)
    -- Call BaseScene's onHide
    self:onHide(event.phase)
end

function scene:destroy(event)
    -- Call BaseScene's onDestroy
    self:onDestroy()
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners - Use BaseScene's setupEventListeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:setupEventListeners()

return scene
