-------------------------------------------------------------------------------
-- Cabin Scene View - BTree Implementation
-------------------------------------------------------------------------------
local BaseScene = require("views.baseScene")
local model = require("models.cabin.cabin_model")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local ChoiceDisplay = require("views.cabin.choice_display")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("cabin")
common._env = {imagePath = "App/TheLastSpark/assets/images/cabin/"}
---
-- BTree components
local bt = require("utils.btree")
local actionController = require("actions.cabin.cabin_actions")
local conditionController = require("conditions.cabin.cabin_conditions")
local waitActionModule = require("actions.cabin.wait_action")

-- Layout diagram (keeps object placement explicit, similar to BT test scene)
local layout = {
    background = "App/TheLastSpark/assets/images/cabin/bg_cabin_exterior.png",
    notes = [[
        [ cabin_door ]
             |
        [ elara ]
             |
        [ iron_key ] (near door)

        Interior:
        [ luminSeed ] → [ chest ]
             |              |
        [ loose_floorboard ] [ brass_key ]
    ]],
    objects = {
        elara = {
            x = (model.objects.elara or {}).x or 300,
            y = (model.objects.elara or {}).y or 500,
            width = (model.objects.elara or {}).width or 300,
            height = (model.objects.elara or {}).height or 500,
            neutralState = ((model.objects.elara or {}).states or {}).neutral or "App/TheLastSpark/assets/images/cabin/elara_neutral.png",
        },
        cabin_door = {
            x = (model.objects.cabin_door or {}).x or 900,
            y = (model.objects.cabin_door or {}).y or 380,
            width = (model.objects.cabin_door or {}).width or 220,
            height = (model.objects.cabin_door or {}).height or 320,
            closedState = ((model.objects.cabin_door or {}).states or {}).closed or "App/TheLastSpark/assets/images/cabin/door_closed.png",
        },
        luminSeed = {
            x = (model.objects.luminSeed or {}).x or 640,
            y = (model.objects.luminSeed or {}).y or 400,
            width = (model.objects.luminSeed or {}).width or 100,
            height = (model.objects.luminSeed or {}).height or 100,
            glowingState = ((model.objects.luminSeed or {}).states or {}).glowing or "App/TheLastSpark/assets/images/cabin/lumin_seed_glowing.png",
        },
        chest = {
            x = (model.objects.chest or {}).x or 600,
            y = (model.objects.chest or {}).y or 420,
            width = (model.objects.chest or {}).width or 170,
            height = (model.objects.chest or {}).height or 130,
            lockedState = ((model.objects.chest or {}).states or {}).locked or "App/TheLastSpark/assets/images/cabin/chest_locked.png",
        },
        iron_key = {
            x = (model.objects.iron_key or {}).x or 850,
            y = (model.objects.iron_key or {}).y or 300,
            width = (model.objects.iron_key or {}).width or 50,
            height = (model.objects.iron_key or {}).height or 80,
            visibleState = ((model.objects.iron_key or {}).states or {}).visible or "App/TheLastSpark/assets/images/cabin/iron_key.png",
        },
        brass_key = {
            x = (model.objects.brass_key or {}).x or 450,
            y = (model.objects.brass_key or {}).y or 200,
            width = (model.objects.brass_key or {}).width or 50,
            height = (model.objects.brass_key or {}).height or 80,
            visibleState = ((model.objects.brass_key or {}).states or {}).visible or "App/TheLastSpark/assets/images/cabin/brass_key.png",
        },
        loose_floorboard = {
            x = (model.objects.loose_floorboard or {}).x or 450,
            y = (model.objects.loose_floorboard or {}).y or 650,
            width = (model.objects.loose_floorboard or {}).width or 120,
            height = (model.objects.loose_floorboard or {}).height or 80,
            normalState = ((model.objects.loose_floorboard or {}).states or {}).normal or "App/TheLastSpark/assets/images/cabin/floorboard_normal.png",
        },
    },
    choices = {
        {label = "Force Door", x = display.contentCenterX - 220, y = display.contentHeight - 20, value = "force_door"},
        {label = "Window", x = display.contentCenterX, y = display.contentHeight - 20, value = "window"},
        {label = "Markings", x = display.contentCenterX + 220, y = display.contentHeight - 20, value = "markings"}
    }
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
        -- Clear the wait state and tick the behavior tree
        waitActionModule.clearWait()

        -- Also clear choice action wait state
        local choiceActionModule = require("actions.cabin.choice_action")
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

    -- Pre-load characters and objects (but don't show them yet)
    self.objs.elara = common.createCharacter("elara", model, layout, self.objs.characterGroup)
    self.objs.luminSeed = common.createCharacter("luminSeed", model, layout, self.objs.characterGroup)
    self.objs.cabin_door = common.createCharacter("cabin_door", model, layout, self.objs.characterGroup)
    self.objs.chest = common.createCharacter("chest", model, layout, self.objs.characterGroup)
    self.objs.iron_key = common.createCharacter("iron_key", model, layout, self.objs.characterGroup)
    self.objs.brass_key = common.createCharacter("brass_key", model, layout, self.objs.characterGroup)
    self.objs.loose_floorboard = common.createCharacter("loose_floorboard", model, layout, self.objs.characterGroup)

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
    self.behaviorTree = common.loadBehaviorTree("App/TheLastSpark/behaviorTree/cabin_scene.tree", actionController, conditionController)

    -- Store condition controller for use in BaseScene's onShow
    self.conditionController = conditionController

    -- Store restart tree function for use when conditions change
    self.objs.restartTree = function()
        print("Restarting behavior tree...")

        -- Reset wait action state before restarting tree
        waitActionModule.reset()

        -- Recreate the tree controller to restart from the beginning
        if self.behaviorTree and self.conditionController then
            self.treeController = common.createManualBehaviorTree(self.behaviorTree, self.conditionController)

            -- Store treeController reference in objs for action modules to access
            self.objs.treeController = self.treeController

            -- Update ChoiceDisplay reference
            if self.ChoiceDisplay then
                self.ChoiceDisplay.treeController = self.treeController
            end

            print("Behavior tree restarted successfully")

            -- Tick the tree once to start evaluating from the new state
            -- This will execute actions until a wait is encountered
            if self.treeController then
                print("\n========== TICK AFTER RESTART ==========")
                print("DEBUG: About to call tick() after restart")
                local result = self.treeController:tick()
                print("DEBUG: tick() returned: " .. tostring(result))
                if result == 0 then
                    print("DEBUG: tick() returned FAILED (0)")
                elseif result == 1 then
                    print("DEBUG: tick() returned SUCCESS (1)")
                elseif result == 2 then
                    print("DEBUG: tick() returned RUNNING (2)")
                end
                -- Execute any pending action queued before restart (e.g., 'scene chest_open')
                if self.objs.pendingAction and actionController and actionController.execute then
                    local actionName = self.objs.pendingAction
                    print("Pending action detected after restart: " .. tostring(actionName))
                    actionController.execute(actionName)
                    self.objs.pendingAction = nil
                end
                print("========== END TICK AFTER RESTART ==========\n")
            end
        end
    end

    -- Store ChoiceDisplay for BaseScene cleanup
    self.ChoiceDisplay = ChoiceDisplay
end

function scene:show(event)
    common._env = {imagePath = "App/TheLastSpark/assets/images/cabin/"}

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
