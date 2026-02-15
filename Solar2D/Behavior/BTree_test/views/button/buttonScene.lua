-------------------------------------------------------------------------------
-- Button Scene View - BTree Implementation
-- Shows a button that returns to animation scene
-------------------------------------------------------------------------------
local BaseScene = require("Behavior.baseScene")
local common = require("behaivor.common_helpers")
local displayManager = require("Behavior.display_manager")
local widget = require("widget")

-- Create scene inheriting from BaseScene
local scene = BaseScene:new("button")

-- BTree components
local bt = require("behaivor.btree")
local actionController = require("Behavior.BTree_test.actions.button.button_controller")
local conditionController = require("Behavior.BTree_test.conditions.button.button_condition_controller")

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
    self.behaviorTree = common.loadBehaviorTree("Behavior/BTree_test/button_scene.tree", actionController, nil)

    -- Store reference for button creation after tree controller is set up
    self.createButton = function()
        -- Check if uiHandler has enableBehaviorTree to use common.createCharacter
        local uiHandler = self.UI and require("App.uiHandler")
        if uiHandler and uiHandler.enableBehaviorTree and self.UI then
            -- Use common.createCharacter to get button from UI.sceneGroup
            print("Using common.createCharacter to get button from UI.sceneGroup")
            common._env = { UI = self.UI }
            local model = { objects = { button = {} } }
            local buttonLayout = { objects = { button = {} } }
            self.objs.button = common.createCharacter("button", model, buttonLayout, self.objs.uiGroup, {
                visible = true,
            })

            -- Set up tap handler for the button
            if self.objs.button then
                print("DEBUG: Setting up tap listener for button")
                self.objs.button:addEventListener("tap", function(event)
                    -- Prevent multiple clicks
                    if self.objs.buttonPressed then
                        print("Button already pressed, ignoring")
                        return true
                    end

                    print("Button pressed!")
                    self.objs.buttonPressed = true
                    -- Immediately tick the behavior tree when button is clicked
                    if self.treeController and not self.treeController.isComplete then
                        self.treeController:tick()
                    end
                    return true
                end)
            end
        else
            -- Create button directly with widget
            local button = widget.newButton({
                label = "Go to Animation",
                onRelease = function()
                    -- Prevent multiple clicks
                    if self.objs.buttonPressed then
                        print("Button already pressed, ignoring")
                        return
                    end

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
        end
        print("Button created at center of screen")
    end

    print("Button Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Button Scene: Will show")

        -- Reset tree controller so it can restart
        common.resetTreeController(self.treeController)

        -- Clear button pressed flag early
        self.objs.buttonPressed = false
        print("Button pressed flag cleared (will phase)")
    elseif event.phase == "did" then
        print("Button Scene: Did show - Starting behavior tree")

        -- Guard against spurious show events - if tree controller exists and is complete, skip
        if self.treeController and self.treeController.isComplete then
            print("Button Scene: Spurious show event detected (tree already complete), ignoring")
            return
        end

        -- Create manual tree controller if it doesn't exist
        if self.behaviorTree and not self.treeController then
            self.treeController = {
                tree = self.behaviorTree,
                isComplete = false,
                timerId = nil,
                tick = function(self)
                    if not self.isComplete then
                        -- Update condition status before ticking
                        local buttonClickedStatus = conditionController.evaluate("button clicked")
                        self.tree:setConditionStatus("button clicked", buttonClickedStatus)

                        local status = self.tree:tick()

                        common.handleTreeTickResult(self, status)
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

        -- Stop behavior tree and cancel pending timers
        common.stopTreeController(self.treeController)
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
