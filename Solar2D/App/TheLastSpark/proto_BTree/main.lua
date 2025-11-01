-- BTree Forest Scene Main Entry Point
-- Solar2D BTree implementation for The Last Spark forest scene

local composer = require("composer")
local bt = require("btree")

-- Global game state
_G.gameData = _G.gameData or {
    playerChoice = nil,
    sceneState = "forest"
}

-- Scene controller
local scene = composer.newScene()

-- Action and condition controllers
local actionController
local conditionController

-- Scene objects
local sceneObjects = {}

function scene:create(event)
    local sceneGroup = self.view

    -- Load controllers
    actionController = require("controllers.action_controller")
    conditionController = require("controllers.condition_controller")

    -- Initialize scene objects
    self:initializeSceneObjects(sceneGroup)

    -- Load and execute the behavior tree
    self:loadBehaviorTree()
end

function scene:show(event)
    if event.phase == "will" then
        -- Scene is about to show
    elseif event.phase == "did" then
        -- Scene is now showing
        if self.behaviorTree then
            -- Start the behavior tree execution
            self:startBehaviorTree()
        end
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Scene is about to hide
    elseif event.phase == "did" then
        -- Scene is now hidden
    end
end

function scene:destroy(event)
    -- Clean up scene
    if self.behaviorTree then
        self.behaviorTree = nil
    end
end

function scene:initializeSceneObjects(sceneGroup)
    -- Load display manager
    local displayManager = require("views.display_manager")

    -- Initialize display manager with scene group
    displayManager.initialize(sceneGroup)

    -- Load models (required by display manager)
    local elaraModel = require("models.elara")
    local wolfModel = require("models.wolf")
    local luminSeedModel = require("models.lumin_seed")
    local cabinModel = require("models.cabin")

    -- Create models for display manager
    local models = {
        elara = elaraModel.create(),
        wolf = wolfModel.create(),
        luminSeed = luminSeedModel.create(),
        cabin = cabinModel.create()
    }

    -- Use display manager to load all display components
    displayManager.loadDisplayComponents(models)

    -- Get display components from display manager
    sceneObjects = displayManager.getDisplayComponents()

    -- Store references for action controller
    actionController.setSceneObjects(sceneObjects)

    -- Initialize controllers with scene objects
    actionController.initialize(sceneObjects)
    conditionController.initialize(sceneObjects)
end

function scene:loadBehaviorTree()
    -- Load the forest scene behavior tree
    local treeFile = io.open("Solar2D/App/TheLastSpark/proto_BTree/forest_scene.tree", "r")
    if treeFile then
        local treeText = treeFile:read("*a")
        treeFile:close()

        self.behaviorTree = bt.BehaviorTree.fromText(treeText)

        -- Register action callbacks
        self:registerActionCallbacks()

        -- Register condition callbacks
        self:registerConditionCallbacks()
    else
        print("Error: Could not load forest_scene.tree")
    end
end

function scene:registerActionCallbacks()
    if not self.behaviorTree then return end

    -- Register all action callbacks
    for actionName, actionModule in pairs(actionController.getActions()) do
        self.behaviorTree:setActionStatus(actionName, bt.RUNNING)

        -- Register activation callback
        self.behaviorTree:onActionActivation(function(actionNode)
            if actionNode.name == actionName then
                actionModule.execute()
            end
        end)
    end
end

function scene:registerConditionCallbacks()
    if not self.behaviorTree then return end

    -- Register all condition callbacks
    for conditionName, conditionModule in pairs(conditionController.getConditions()) do
        self.behaviorTree:setConditionStatus(conditionName, bt.FAILED)

        -- Update condition status based on game state
        timer.performWithDelay(100, function()
            local status = conditionModule.evaluate()
            self.behaviorTree:setConditionStatus(conditionName, status and bt.SUCCESS or bt.FAILED)
        end, 0) -- Repeat every 100ms
    end
end

function scene:startBehaviorTree()
    if not self.behaviorTree then return end

    -- Execute the behavior tree in a loop
    local function tickTree()
        if self.behaviorTree then
            self.behaviorTree:tick()

            -- Continue ticking
            timer.performWithDelay(50, tickTree)
        end
    end

    -- Start the behavior tree execution
    tickTree()
end

-- Scene event listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene