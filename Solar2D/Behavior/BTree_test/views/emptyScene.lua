-------------------------------------------------------------------------------
-- Empty Scene - Simple test scene with back button
-------------------------------------------------------------------------------
local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Store the return scene and sceneProps from params if provided
    if event.params then
        if event.params.returnToScene then
            self.returnToScene = event.params.returnToScene
            print("EmptyScene:create - returnToScene stored: " .. tostring(self.returnToScene))
        end
        if event.params.sceneProps then
            self.sceneProps = event.params.sceneProps
            print("EmptyScene:create - sceneProps stored")
        end
    end

    -- Create background
    local background = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
    background:setFillColor(0.2, 0.2, 0.3)

    -- Create title text
    local title = display.newText({
        parent = sceneGroup,
        text = "Empty Scene",
        x = display.contentCenterX,
        y = 100,
        font = native.systemFontBold,
        fontSize = 40
    })
    title:setFillColor(1, 1, 1)

    -- Create back button
    local backButton = display.newRoundedRect(
        sceneGroup,
        display.contentCenterX,
        display.contentCenterY,
        200,
        60,
        12
    )
    backButton:setFillColor(0.3, 0.5, 0.3)
    backButton.strokeWidth = 3
    backButton:setStrokeColor(0.8, 0.8, 0.8)

    local backButtonText = display.newText({
        parent = sceneGroup,
        text = "Go Back",
        x = display.contentCenterX,
        y = display.contentCenterY,
        font = native.systemFontBold,
        fontSize = 24
    })
    backButtonText:setFillColor(1, 1, 1)

    -- Store button references for reuse
    self.backButton = backButton
    self.backButtonText = backButtonText

    -- Flag to prevent double-tap
    self.isNavigating = false

    -- Back button tap handler
    local function onBackTap(event)
        if self.isNavigating then
            print("EmptyScene: Already navigating, ignoring tap")
            return true
        end

        self.isNavigating = true

        -- Use the stored returnToScene instead of getSceneName("previous")
        local targetScene = self.returnToScene
        print("EmptyScene: Using stored returnToScene: " .. tostring(targetScene))

        if targetScene then
            -- Remove listeners immediately to prevent double-tap
            self.backButton:removeEventListener("tap", onBackTap)
            self.backButtonText:removeEventListener("tap", onBackTap)

            -- Don't pass sceneProps back - let the scene recreate fresh
            -- The Kwik component scene will be recreated properly
            local options = {
                effect = "slideRight",
                time = 300
            }

            -- Don't set recycleOnSceneChange here - we don't want to destroy the narration scene
            -- The emptyScene will be removed in its hide:did phase
            composer.gotoScene(targetScene, options)
        else
            print("No returnToScene stored, falling back to getSceneName")
            local prevScene = composer.getSceneName("previous")
            if prevScene then
                self.backButton:removeEventListener("tap", onBackTap)
                self.backButtonText:removeEventListener("tap", onBackTap)
                composer.recycleOnSceneChange = true
                composer.gotoScene(prevScene, {effect = "slideRight", time = 300})
            else
                print("No previous scene available")
                self.isNavigating = false
            end
        end

        return true
    end

    -- Store the tap handler for reuse
    self.onBackTap = onBackTap

    self.backButton:addEventListener("tap", self.onBackTap)
    self.backButtonText:addEventListener("tap", self.onBackTap)

    print("Empty Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Empty scene showing")
        -- Re-add tap listeners and reset navigation flag when showing
        if self.backButton and self.onBackTap then
            self.isNavigating = false
            self.backButton:addEventListener("tap", self.onBackTap)
            self.backButtonText:addEventListener("tap", self.onBackTap)
            print("EmptyScene: Tap listeners re-added")
        end
    elseif event.phase == "did" then
        print("Empty scene visible")
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Empty scene hiding")
        -- Hide the view to prevent overlay issues
        self.view.isVisible = false
    elseif event.phase == "did" then
        print("Empty scene hidden completely")
        -- Don't remove event listeners or the scene
        -- Let composer manage the scene lifecycle naturally
    end
end

function scene:destroy(event)
    print("Empty Scene: Destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
