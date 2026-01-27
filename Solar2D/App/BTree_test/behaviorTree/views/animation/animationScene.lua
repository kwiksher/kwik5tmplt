-------------------------------------------------------------------------------
-- Animation Scene View - BTree Implementation
-- Shows a star performing linear animation
-------------------------------------------------------------------------------
local BaseScene = require("views.baseScene")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("animation")

-- BTree components
local bt = require("utils.btree")
local actionController = require("actions.animation.animation_controller")
local conditionController = require("conditions.animation.animation_condition_controller")

-- Layout configuration
local layout = {
    background = {r=0.1, g=0.1, b=0.2}, -- Dark blue background
}

-------------------------------------------------------------------------------
-- Scene event functions
-------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Initialize display objects container
    self.objs = self.objs or {}

    -- Create display groups for organization
    local layers = displayManager.createSceneLayers(sceneGroup)
    self.objs.background = layers.background
    self.objs.characterGroup = layers.characters
    self.objs.uiGroup = layers.ui

    -- Create background
    local bg = display.newRect(self.objs.background, display.contentCenterX, display.contentCenterY,
        display.actualContentWidth, display.actualContentHeight)
    bg:setFillColor(layout.background.r, layout.background.g, layout.background.b)

    -- Create star shape
    -- Check if uiHandler has enableBehaviorTree to use common.createCharacter
    local uiHandler = self.UI and require("App.uiHandler")
    if uiHandler and uiHandler.enableBehaviorTree and self.UI then
        -- Use common.createCharacter to get object from UI.sceneGroup
        print("Using common.createCharacter to get star from UI.sceneGroup")
        common._env = { UI = self.UI }
        local model = { objects = { star = {} } }
        local starLayout = { objects = { star = {} } }
        self.objs.star = common.createCharacter("star", model, starLayout, self.objs.characterGroup, {
            visible = true,
            -- x = display.contentCenterX - 200,
            -- y = display.contentCenterY
        })
    else
        -- Create star shape directly
        local star = display.newPolygon(
            self.objs.characterGroup,
            display.contentCenterX - 200,
            display.contentCenterY,
            {0,-50, 15,-15, 50,-10, 20,10, 30,40, 0,20, -30,40, -20,10, -50,-10, -15,-15}
        )
        star:setFillColor(1, 1, 0) -- Yellow
        self.objs.star = star
    end
    print("Star created at position:", self.objs.star.x, self.objs.star.y)

    -- Create counter text display
    local counterText = display.newText({
        parent = self.objs.uiGroup,
        text = "Scene Count: 0",
        x = display.contentCenterX,
        y = 30,
        font = native.systemFontBold,
        fontSize = 20
    })
    counterText:setFillColor(1, 1, 1) -- White
    self.objs.counterText = counterText

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Initialize condition controller with scene objects
    conditionController.initialize(self.objs)

    -- Load behavior tree and register action handler
    self.behaviorTree = common.loadBehaviorTree("App/BTree_test/behaviorTree/animation_scene.tree", actionController, nil)

    print("Animation Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Animation Scene: Will show")

        -- Clear the transitioning flag - we're legitimately entering the scene now
        self.objs.isTransitioning = false

        -- Reset tree controller so it can restart
        if self.treeController then
            self.treeController.isComplete = false
            if self.treeController.timerId then
                timer.cancel(self.treeController.timerId)
                self.treeController.timerId = nil
            end
        end

        -- Always reset first tick flag when showing the scene
        -- This ensures animation starts properly regardless of how we got here
        self.objs.sceneFirstTickDone = false
        local composer = require("composer")
        local previousScene = composer.getSceneName("previous")
        print("Resetting first tick flag - transitioning from: " .. tostring(previousScene))

        -- Clear animation completion status early to prevent race conditions
        self.objs.animationComplete = self.objs.animationComplete or {}
        self.objs.animationComplete.star = false
        self.objs.animationInProgress = false
        print("Animation status cleared (will phase)")

        -- Initialize star position and animation status
        if self.objs.star then
            local uiHandler = self.UI and require("App.uiHandler")
            if uiHandler and uiHandler.enableBehaviorTree and self.UI then
                -- Reset to original position from Kwik editor using oriX/oriY
                if self.objs.star.oriX and self.objs.star.oriY then
                    self.objs.star.x = self.objs.star.oriX
                    self.objs.star.y = self.objs.star.oriY
                    print("Star position reset to oriX:", self.objs.star.oriX, "oriY:", self.objs.star.oriY)
                end
            else
                -- Reset to hardcoded position when not using UI mode
                self.objs.star.x = display.contentCenterX - 200
                self.objs.star.y = display.contentCenterY
                print("Star position initialized to start")
            end
        end
    elseif event.phase == "did" then
        print("Animation Scene: Did show - Starting behavior tree")

        -- Guard against spurious show events - if tree controller exists and is complete, skip
        if self.treeController and self.treeController.isComplete then
            print("Animation Scene: Spurious show event detected (tree already complete), ignoring")
            return
        end

        -- Clear animation completion status (again, for safety)
        self.objs.animationComplete = self.objs.animationComplete or {}
        self.objs.animationComplete.star = false
        self.objs.animationInProgress = false
        print("Animation status cleared (did phase)")

        -- Create manual tree controller
        if self.behaviorTree then
            self.treeController = {
                tree = self.behaviorTree,
                isComplete = false,
                timerId = nil,
                tick = function(self)
                    if not self.isComplete then
                        -- Update condition status before ticking
                        local sceneFirstTickStatus = conditionController.evaluate("scene first tick")
                        self.tree:setConditionStatus("scene first tick", sceneFirstTickStatus)

                        local animationCompletedStatus = conditionController.evaluate("star animation completed")
                        self.tree:setConditionStatus("star animation completed", animationCompletedStatus)

                        local status = self.tree:tick()

                        if status == bt.SUCCESS then
                            self.isComplete = true
                            -- Cancel any pending timer
                            if self.timerId then
                                timer.cancel(self.timerId)
                                self.timerId = nil
                            end
                        elseif status == bt.FAILED then
                            -- Tree failed (animation not complete yet), keep ticking
                            self.timerId = timer.performWithDelay(100, function()
                                if not self.isComplete then
                                    self:tick()
                                end
                            end)
                        elseif status == bt.RUNNING then
                            -- Tree is still running, schedule next tick
                            self.timerId = timer.performWithDelay(100, function()
                                if not self.isComplete then
                                    self:tick()
                                end
                            end)
                        end
                    end
                end
            }

            -- Store tree controller reference in objs for animation action to access
            self.objs.treeController = self.treeController

            -- Start the behavior tree
            self.treeController:tick()
        end
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Animation Scene: Will hide")

        -- Stop behavior tree and cancel pending timers
        if self.treeController then
            self.treeController.isComplete = true
            if self.treeController.timerId then
                timer.cancel(self.treeController.timerId)
                self.treeController.timerId = nil
            end
        end

        -- Cancel only star transitions, not all transitions globally
        if self.objs.star then
            transition.cancel(self.objs.star)
        end
    elseif event.phase == "did" then
        print("Animation Scene: Did hide")
    end
end

function scene:destroy(event)
    print("Animation Scene: Destroy")
end

-------------------------------------------------------------------------------
-- Scene event listeners
-------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
