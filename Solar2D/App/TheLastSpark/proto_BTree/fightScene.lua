-------------------------------------------------------------------------------
-- Fight Scene View - BTree Implementation
-------------------------------------------------------------------------------
local composer = require("composer")

local scene = composer.newScene()
local displayManager = require("views.display_manager")

-- Layout configuration
local layout = {
    background = "images/bg_fight.png",
}

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Initialize display objects container
    self.objs = {}

    -- Create display groups for organization
    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- Initial background
    local backgroundElements = displayManager.createBackgroundLayer(self.objs.background, {
        image = layout.background,
    })
    self.objs.vignette = backgroundElements.vignette

    -- Dialogue elements (text plus navigation)
    local uiElements = displayManager.createDialogueInterface(self.objs.uiGroup, {
        onRelease = function()
            -- Hide button
            if self.objs.nextButton then
                self.objs.nextButton.isVisible = false
                transition.cancel(self.objs.nextButton)
                self.objs.nextButton.alpha = 1.0
            end

            -- TODO: Add behavior tree controller here
            print("Fight scene: Next button pressed")
        end,
    })
    self.objs.dialogueText = uiElements.dialogueText
    self.objs.nextButton = uiElements.nextButton

    -- Show button
    self.objs.nextButton.isVisible = true
    self.objs.nextButton.alpha = 1.0

    -- Display placeholder text
    if self.objs.dialogueText then
        self.objs.dialogueText.text = "FIGHT SCENE - You engage the corrupted wolf in battle..."
    end
end

function scene:show(event)
    if event.phase == "will" then
        print("Fight scene showing")
    elseif event.phase == "did" then
        print("Fight scene visible")
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Fight scene hiding")
        -- Clean up audio
        audio.stop()
    end
end

function scene:destroy(event)
    print("Fight scene destroyed")
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
