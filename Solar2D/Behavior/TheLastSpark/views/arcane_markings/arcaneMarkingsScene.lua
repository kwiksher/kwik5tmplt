-------------------------------------------------------------------------------
-- Arcane Markings Scene View - BTree Implementation
-------------------------------------------------------------------------------
local BaseScene = require("Behavior.baseScene")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("arcane_markings")

-- Layout configuration
local layout = {
    background = "images/bg_arcane_markings.png",
}

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
        print("Arcane Markings scene: Next button pressed")
    end)

    -- Display placeholder text
    if self.objs.dialogueText then
        self.objs.dialogueText.text = "ARCANE MARKINGS SCENE - You trace the glowing symbols with your fingers..."
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
