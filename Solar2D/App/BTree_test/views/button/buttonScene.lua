-------------------------------------------------------------------------------
-- Button Scene View - BTree Implementation
-- Shows a button that returns to animation scene
-------------------------------------------------------------------------------
local BaseScene = require("views.baseScene")
local common = require("utils.common_helpers")
local displayManager = require("views.display_manager")
local widget = require("widget")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("button")

-- BTree components
local bt = require("utils.btree")
local actionController = require("actions.button.button_controller")
local conditionController = require("conditions.button.button_condition_controller")

-- Layout configuration
local layout = {
    background = {r=0.2, g=0.1, b=0.1}, -- Dark red background
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

    -- Initialize action controller with scene objects
    actionController.initialize(self.objs)

    -- Initialize condition controller with scene objects
    conditionController.initialize(self.objs)

    -- Load behavior tree and register handlers
    self.behaviorTree = common.loadBehaviorTree("button.tree", actionController, nil)

    -- Store reference for button creation after tree controller is set up
    self.createButton = function()
        -- Create button with immediate tree tick on click
        local button = widget.newButton({
            label = "Go to Animation",
            onRelease = function()
                print("Button pressed!")
                self.objs.buttonPressed = true
                -- Immediately tick the behavior tree when button is clicked
                if self.treeController and not self.treeController.isComplete then
                    self.treeController:tick()
                end
            end,
            emboss = false,
            shape = "roundedRect",
            width = 200,
            height = 50,
            cornerRadius = 10,
            fillColor = { default={0.2,0.5,1}, over={0.3,0.6,1} },
            labelColor = { default={1,1,1}, over={0.9,0.9,0.9} }
        })
        button.x = display.contentCenterX
        button.y = display.contentCenterY
        self.objs.uiGroup:insert(button)
        self.objs.button = button
        print("Button created at center of screen")
    end

    print("Button Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Button Scene: Will show")
    elseif event.phase == "did" then
        print("Button Scene: Did show - Starting behavior tree")

        -- Clear button pressed flag
        self.objs.buttonPressed = false
        print("Button pressed flag cleared")

        -- Create manual tree controller
        if self.behaviorTree then
            self.treeController = {
                tree = self.behaviorTree,
                isComplete = false,
                tick = function(self)
                    if not self.isComplete then
                        print("\n=== BTree Tick ===")

                        -- Update condition status before ticking
                        local buttonClickedStatus = conditionController.evaluate("button clicked")
                        self.tree:setConditionStatus("button clicked", buttonClickedStatus)

                        local status = self.tree:tick()
                        print("Tree status: " .. tostring(status))

                        if status == bt.SUCCESS then
                            print("Behavior tree completed with status: SUCCESS")
                            self.isComplete = true
                        elseif status == bt.FAILED then
                            -- Tree failed (button not clicked), keep ticking
                            print("Tree tick failed (button not clicked yet), will tick again")
                            timer.performWithDelay(100, function()
                                if not self.isComplete then
                                    self:tick()
                                end
                            end)
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

            -- Create the button now that tree controller is set up
            self.createButton()

            -- Start the behavior tree
            self.treeController:tick()
        end
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Button Scene: Will hide")

        -- Stop behavior tree
        if self.treeController then
            self.treeController.isComplete = true
        end
    elseif event.phase == "did" then
        print("Button Scene: Did hide")
    end
end

function scene:destroy(event)
    print("Button Scene: Destroy")
end

-------------------------------------------------------------------------------
-- Scene event listeners
-------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
