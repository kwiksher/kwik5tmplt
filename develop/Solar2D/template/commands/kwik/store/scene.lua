local composer = require( "composer" )
local scene = composer.newScene()
--
local model       = require("components.store.model")
local UI          = require("components.store.UI")
local CMD         = require("components.store.command")
-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	--
	--Background
	local background = display.newRect(_W/2, _H/2,360,600)
	background:setFillColor({type="gradient", color1={ 0,0,0 }, color2={ 0,0,0.4 }, direction="down"})

	sceneGroup:insert(background)

    UI:init(sceneGroup)
    CMD:init(UI)
	UI:createBuyButton(model.episode02, _W/2, _H/2, 150, 50)
    UI:createBuyButton(model.episode03, _W/2, _H/2 + 50, 150, 50)
    UI:createRestoreButton(_W/2, _H/2+100, 150, 50)
    CMD:startDownload()
end

function scene:show( event )
	local phase = event.phase
	if "did" == phase then
	end
end

function scene:hide( event )
	local phase = event.phase
	if "will" == phase then
	end
end

function scene:destroy( event )
end
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene