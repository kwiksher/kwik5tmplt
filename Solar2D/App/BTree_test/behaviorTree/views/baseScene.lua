-------------------------------------------------------------------------------
-- Base Scene - Common scene functionality for inheritance
-------------------------------------------------------------------------------
local composer = require("composer")
local displayManager = require("views.display_manager")

local BaseScene = {}
BaseScene.__index = BaseScene

-------------------------------------------------------------------------------
-- Creates a new scene that inherits from BaseScene
-- @param sceneType string - Optional scene type identifier
-- @return table - A new scene instance with BaseScene methods
-------------------------------------------------------------------------------
function BaseScene:new(sceneType)
    local scene = composer.newScene()

    -- Store the original metatable (composer scene methods)
    local composerMeta = getmetatable(scene)

    -- Create a new metatable that chains to both BaseScene and composer
    local newMeta = {
        __index = function(t, k)
            -- First check BaseScene methods
            local baseMethod = BaseScene[k]
            if baseMethod ~= nil then
                return baseMethod
            end
            -- Then check composer scene methods
            if composerMeta and composerMeta.__index then
                if type(composerMeta.__index) == "function" then
                    return composerMeta.__index(t, k)
                else
                    return composerMeta.__index[k]
                end
            end
            return nil
        end
    }

    -- Set up the new metatable
    setmetatable(scene, newMeta)

    -- Store scene type
    scene.sceneType = sceneType or "base"

    return scene
end

-------------------------------------------------------------------------------
-- Common initialization for display objects and layers
-- @param sceneGroup DisplayGroup - The scene's view group
-- @param layoutConfig table - Configuration for background image
-------------------------------------------------------------------------------
function BaseScene:initializeDisplay(sceneGroup, layoutConfig)
    -- Initialize display objects container
    self.objs = self.objs or {}

    -- Create display groups for organization
    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- Initial background
    local backgroundElements = displayManager.createBackgroundLayer(self.objs.background, {
        image = layoutConfig.background,
    })
    self.objs.vignette = backgroundElements.vignette
end

-------------------------------------------------------------------------------
-- Common dialogue interface setup
-- @param onNextCallback function - Callback for next button press
-- @param layoutParams table - Optional layout parameters (x, y, width, height, buttonLabel, buttonX, buttonY, etc.)
-------------------------------------------------------------------------------
function BaseScene:initializeDialogueInterface(onNextCallback, layoutParams)
    if not self.objs or not self.objs.uiGroup then
        print("Warning: UI group not initialized. Call initializeDisplay first.")
        return
    end

    -- Merge layout parameters with onRelease callback
    local params = layoutParams or {}
    params.onRelease = function()
        -- Hide button and stop blinking animation
        if self.objs.nextButton then
            self.objs.nextButton.isVisible = false
            transition.cancel(self.objs.nextButton)
            self.objs.nextButton.alpha = 1.0
        end

        -- Call custom callback if provided
        if onNextCallback then
            onNextCallback()
        end
    end

    -- Create dialogue elements (text plus navigation)
    local uiElements = displayManager.createDialogueInterface(self.objs.uiGroup, params)

    self.objs.dialogueText = uiElements.dialogueText
    self.objs.nextButton = uiElements.nextButton

    -- Initially show button
    self.objs.nextButton.isVisible = true
    self.objs.nextButton.alpha = 1.0
end

-------------------------------------------------------------------------------
-- Helper function to change background image
-- @param imagePath string - Path to the new background image
-- @return boolean - Success status
-------------------------------------------------------------------------------
function BaseScene:changeBackground(imagePath)
    if not self.objs.background then
        print("Warning: Background group not found")
        return false
    end

    -- Remove existing background objects (children of the background group)
    for i = self.objs.background.numChildren, 1, -1 do
        local child = self.objs.background[i]
        if child then
            child:removeSelf()
        end
    end

    -- Create new background with the same structure as original
    local backgroundElements = displayManager.createBackgroundLayer(self.objs.background, {
        image = imagePath,
    })
    self.objs.vignette = backgroundElements.vignette

    print("Changed background to: " .. imagePath)
    return true
end

-------------------------------------------------------------------------------
-- Common show event handler - handles behavior tree initialization if present
-- Can be overridden in derived scenes for additional behavior
-------------------------------------------------------------------------------
function BaseScene:onShow(phase)
    if phase == "will" then
        print(self.sceneType .. " scene showing")

        -- Initialize behavior tree controller if behavior tree exists
        if self.behaviorTree then
            local common = require("utils.common_helpers")
            self.treeController = common.createManualBehaviorTree(self.behaviorTree, self.conditionController)

            -- Store treeController reference in objs for action modules to access
            if self.objs then
                self.objs.treeController = self.treeController
            end

            -- Update choice display if it exists
            local ChoiceDisplay = self.ChoiceDisplay
            if ChoiceDisplay then
                ChoiceDisplay.treeController = self.treeController
            end

            print("Use the Next button to advance through the story")
        end
    elseif phase == "did" then
        print(self.sceneType .. " scene visible")
    end
end

-------------------------------------------------------------------------------
-- Common hide event handler - handles behavior tree cleanup if present
-- Can be overridden in derived scenes for additional behavior
-------------------------------------------------------------------------------
function BaseScene:onHide(phase)
    if phase == "will" then
        print(self.sceneType .. " scene hiding")

        -- Clean up behavior tree controller if it exists
        if self.treeController then
            self.treeController = nil
        end

        -- Clean up audio
        audio.stop()
    end
end

-------------------------------------------------------------------------------
-- Common destroy event handler - handles behavior tree cleanup if present
-- Can be overridden in derived scenes for additional behavior
-------------------------------------------------------------------------------
function BaseScene:onDestroy()
    print(self.sceneType .. " scene destroyed")

    -- Clean up choice display if it exists
    if self.ChoiceDisplay then
        self.ChoiceDisplay:cleanup()
    end

    -- Clean up behavior tree resources if they exist
    if self.treeController then
        self.treeController = nil
    end
    if self.behaviorTree then
        self.behaviorTree = nil
    end

    -- Clean up display objects
    self.objs = nil
end

-------------------------------------------------------------------------------
-- Setup standard event listeners for a scene
-- Should be called at the end of derived scene files
-------------------------------------------------------------------------------
function BaseScene:setupEventListeners()
    self:addEventListener("show", function(event)
        self:onShow(event.phase)
    end)

    self:addEventListener("hide", function(event)
        self:onHide(event.phase)
    end)

    self:addEventListener("destroy", function(event)
        self:onDestroy()
    end)
end

return BaseScene
