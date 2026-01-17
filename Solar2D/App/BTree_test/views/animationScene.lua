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
local actionController = require("actions.animation_controller")

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
    local star = display.newPolygon(
        self.objs.characterGroup,
        display.contentCenterX - 200,
        display.contentCenterY,
        {0,-50, 15,-15, 50,-10, 20,10, 30,40, 0,20, -30,40, -20,10, -50,-10, -15,-15}
    )
    star:setFillColor(1, 1, 0) -- Yellow
    self.objs.star = star
    print("Star created at position:", star.x, star.y)

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Load behavior tree and register action handler
    self.behaviorTree = common.loadBehaviorTree("App/BTree_test/animation.tree", actionController, nil)

    print("Animation Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Animation Scene: Will show")
    elseif event.phase == "did" then
        print("Animation Scene: Did show - Starting behavior tree")

        -- Create manual tree controller
        if self.behaviorTree then
            self.treeController = {
                tree = self.behaviorTree,
                isComplete = false,
                tick = function(self)
                    if not self.isComplete then
                        print("\n=== BTree Tick ===")
                        local status = self.tree:tick()
                        print("Tree status: " .. tostring(status))

                        if status == bt.SUCCESS or status == bt.FAILED then
                            print("Behavior tree completed with status: " .. tostring(status))
                            self.isComplete = true
                        elseif status == bt.RUNNING then
                            -- Tree is still running, schedule next tick
                            timer.performWithDelay(100, function()
                                if not self.isComplete then
                                    self:tick()
                                end
                            end)
                        end
                    end
                end
            }

            -- Start the behavior tree
            self.treeController:tick()
        end
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Animation Scene: Will hide")

        -- Stop behavior tree
        if self.treeController then
            self.treeController.isComplete = true
        end

        -- Clean up transitions
        transition.cancel()
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
