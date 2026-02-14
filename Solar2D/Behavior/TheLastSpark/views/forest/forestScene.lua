-------------------------------------------------------------------------------
-- Forest Scene View - BTree Implementation
-------------------------------------------------------------------------------
local BaseScene = require("views.baseScene")
local model = require("models.forest.forest_model")
local common = require("behaivor.common_helpers")
local displayManager = require("views.display_manager")
local ChoiceDisplay = require("views.forest.choice_display")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("forest")

-- BTree components
local bt = require("behaivor.btree")
local actionController = require("actions.forest.forest_actions")
local conditionController = require("conditions.forest.forest_conditions")
local waitActionModule = require("actions.forest.wait_action")

scene.imagePath = "App/TheLastSpark/assets/images/forest/"

local scale = 0.25
-- Layout diagram (keeps object placement explicit, similar to BT test scene)
local layout = {
    background = "App/TheLastSpark/assets/images/forest/bg_forest.png",
    notes = [[
        [ lumin_seed ]   → trail →   [ wolf ]
                 |                       ↑
              [ elara ]           (forest edge)
    ]],
    objects = {
        elara = {
            x = (model.objects.elara or {}).x or 300*scale,
            y = (model.objects.elara or {}).y or 500*scale,
            width = (model.objects.elara or {}).width or 300*scale,
            height = (model.objects.elara or {}).height or 500*scale,
            neutralState = ((model.objects.elara or {}).states or {}).neutral or "App/TheLastSpark/assets/images/forest/elara_neutral.png",
        },
        wolf = {
            x = (model.objects.wolf or {}).x or 900*scale,
            y = (model.objects.wolf or {}).y or 450*scale,
            width = (model.objects.wolf or {}).width or 400*scale,
            height = (model.objects.wolf or {}).height or 300*scale,
            aggroState = ((model.objects.wolf or {}).states or {}).aggro or "App/TheLastSpark/assets/images/forest/corrupted_wolf_aggro.png",
        },
        lumin_seed = {
            x = (model.objects.lumin_seed or {}).x or display.contentCenterX,
            y = (model.objects.lumin_seed or {}).y or 400*scale,
            width = (model.objects.lumin_seed or {}).width or 100*scale,
            height = (model.objects.lumin_seed or {}).height or 100*scale,
            idleState = ((model.objects.lumin_seed or {}).states or {}).normal or "App/TheLastSpark/assets/images/forest/item_lumin_seed.png",
        },
    },
    choices = {
        {label = "Fight", x = display.contentCenterX - 220, y = display.contentHeight - 20, value = "fight"},
        {label = "Calm", x = display.contentCenterX, y = display.contentHeight - 20, value = "calm"},
        {label = "Retreat", x = display.contentCenterX + 220, y = display.contentHeight - 20, value = "retreat"}
    }
}

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    common._env = {imagePath = self.imagePath, UI=self.UI}
    -- print("@@@@ create() with self.UI", self.UI)
    -- Use BaseScene initialization for display
    self:initializeDisplay(sceneGroup, {
        background = layout.background,
    })

    -- Use BaseScene initialization for dialogue interface
    self:initializeDialogueInterface(function()
        -- Clear the wait state and tick the behavior tree
        waitActionModule.clearWait()

        -- Also clear choice action wait state
        local choiceActionModule = require("actions.forest.choice_action")
        choiceActionModule.clearWait()

        if self.treeController and not self.treeController.isComplete then
            self.treeController:tick()
        end
    end)

    -- Initialize choice display system
    self.objs.choiceGroup = ChoiceDisplay:initialize(sceneGroup, self.objs, nil, layout.choices)

    -- Initialize missing files UI layer (must be after sceneGroup creation)
    displayManager.initMissingFilesUI(sceneGroup)

    -- Helper function to show choice buttons
    function self.showChoiceButtons()
        ChoiceDisplay:showChoiceButtons()
    end

    -- Helper function to hide choice buttons
    function self.hideChoiceButtons()
        ChoiceDisplay:hideChoiceButtons()
    end

    -- Pre-load characters (but don't show them yet)
    self.objs.elara = common.createCharacter("elara", model, layout, self.objs.characterGroup)
    self.objs.lumin_seed = common.createCharacter("lumin_seed", model, layout, self.objs.characterGroup)
    self.objs.wolf = common.createCharacter("wolf", model, layout, self.objs.characterGroup)

    -- Store reference to scene for helper functions
    self.objs.showChoiceButtons = function() self.showChoiceButtons() end
    self.objs.hideChoiceButtons = function() self.hideChoiceButtons() end
    -- Use BaseScene's changeBackground method
    self.objs.changeBackground = function(imagePath) return self:changeBackground(imagePath) end

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Initialize condition controller with scene objects
    conditionController.initialize(self.objs)

    -- Load behavior tree and register action/condition handlers
    self.behaviorTree = common.loadBehaviorTree("Behavior/TheLastSpark/forest_scene.tree", actionController, conditionController)

    -- Store condition controller for use in BaseScene's onShow
    self.conditionController = conditionController

    -- Store ChoiceDisplay for BaseScene cleanup
    self.ChoiceDisplay = ChoiceDisplay
end

function scene:show(event)
  -- common._env = {imagePath = self.imagePath, UI=self.UI}
    -- Call BaseScene's onShow to handle behavior tree initialization
    self:onShow(event.phase)
end

function scene:hide(event)
    -- Call BaseScene's onHide to handle cleanup
    self:onHide(event.phase)
end

function scene:destroy(event)
    -- Call BaseScene's onDestroy to handle cleanup
    self:onDestroy()
end

-- -----------------------------------------------------------------------------------
-- Scene event listeners - Use BaseScene's setupEventListeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:setupEventListeners()

return scene
