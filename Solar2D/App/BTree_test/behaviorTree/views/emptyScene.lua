-------------------------------------------------------------------------------
-- Empty Scene - Simple test scene with back button
-------------------------------------------------------------------------------
local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

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

    -- Back button tap handler
    local function onBackTap()
        local prevScene = composer.getSceneName("previous")
        if prevScene then
            composer.gotoScene(prevScene, {
                effect = "slideRight",
                time = 300
            })
        else
            print("No previous scene available")
        end
    end

    backButton:addEventListener("tap", onBackTap)
    backButtonText:addEventListener("tap", onBackTap)

    print("Empty Scene: Created successfully")
end

function scene:show(event)
    if event.phase == "will" then
        print("Empty scene showing")
    elseif event.phase == "did" then
        print("Empty scene visible")
    end
end

function scene:hide(event)
    if event.phase == "will" then
        print("Empty scene hiding")
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
