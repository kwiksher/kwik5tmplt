--===================================================================--
-- kNavi.lua (creates navigation for thumbnails)
--
-- by Kwiksher
-- version 1: April 12, 2012
-- version 2: October, 15, 2012 //ability to NOT show some pages (exclude={})
-- version 3: November, 19, 2012 //re-written to use scrollView widget
-- version 3.1: November 20, 2012 //dispose of animations and timers, when they exist
-- version 3.2: November 21, 2012 //starts the view with the current page as the first
-- version 3.3: November 27, 2012 //shows the correct pages in the navigation menu
-- version 3.4: December 10, 2012 //separates content from the background and fix scrolling when just 1-2 thumbs exist
-- version 3.5: December 13, 2012 //compatibility with Director/Storyboard 1.5
-- version 3.6: January 2, 2013 //hides the navigator if it is opened after 10s
-- version 3.7: March 13, 2013 //add variable to control disposal of Multiplier objects (under menuItemTap)
-- version 3.8: March 28, 2013 //scrollView compatibility with Widget 2.0
-- version 3.9: November 11, 2013 //compatibility with Graphics 2.0, do not swipe to next/previous page
-- version 4.0: February 19, 2014 //fixes issues after pre-loading next scene
-- version 4.1: March 19, 2014 //fixes issues with background color
-- version 4.2: March 20, 2014 //solves problem with preloads
-- version 4.3: June 22, 2014 //disposes current page
--===================================================================--
-- Sintaxe:
-- Navigation.show( g1, { backColor = {255,255,0}, alpha = alpha, totPages = numPages, curPage = curPage, thumbW = 120, thumbH = 70, imageDir = imgDir, dire = "right"} )
-- navBack holds the rect or image acting as background for the navigation
-- navItems holds all thumbnails
--
local _K = require "controller.Application"
--
local widget = require("widget")
local composer = require( "composer" )

local Navigation = {}
local navShow = 0
local navItems = nil
local bResponsive = true

Navigation.getItems = function()
    return navItems
end
--local _K.kNavig = nil
--local _K.kNavigation = nil

Navigation.new = function( obj, params, naviListener)
	params = params or {}
    local spacer = 10 --pixels distance between images

	local audios = params.audio

	local _W = display.contentWidth
	local _H = display.contentHeight
    if bResponsive then
        _W = display.safeActualContentWidth
        _H = display.safeActualContentHeight
    end

	local numAnim = params.anim
	local numTimers = params.timer

	local thumbW = params.thumbW
	local thumbH = params.thumbH
	local dire = params.dire

	-- version 4

	local cpage = params.curPage --- 1 -- the minus 1 is because the next page is already loaded in memory
	if params.totPages == params.curPage then cpage = params.curPage end


	--creates group for the full navigation
	_K.kNavig = display.newGroup()
	--_K.kNavig.anchorChildren = true
	--_K.kNavig.anchorX = 0; _K.kNavig.anchorY = 0;

	--_K.kNavig.x = 0; _K.kNavig.y = 0

	local pageList = {}
	local notShow --table with pages who should not appear in the navigation

	--Loads all images to the table
	for i = 1,params.totPages do
		--checks if page shows
		local k, v
		if (params.exclude == nil) then
		  notShow = {-1}
		else
		  notShow = params.exclude
		end

		local c = 0 --control
		--builds the navigation
		for xc = 1,#notShow do
			--print("i: "..i.." xc: "..xc.." notShow[xc]: ".. notShow[xc].." c: "..c)
			if (i==notShow[xc]) then
				c = notShow[xc]
				break
			else
				c = 0
			end
		end

		if (c==0) then
			--print ("show "..i)
			table.insert(pageList, {params.imageDir.."p"..i.."_thumb.png", i})
		else
			--print("do not show "..i)
		end

    end


    --sets background
    local nTop, nLeft, nWidth, nHeight, nVert, nHor
    local nTop1, nLeft1, nWidth1, nHeight1
    if (params.dire == "top") then
    	nTop = 0;
    	nLeft = 0;
    	nWidth = _W;
    	nHeight = (spacer * 2) + params.thumbH;
    	nVert = true; nHor = false

    	nTop1 = (params.thumbH + (spacer * 2)) / 2;
    	nLeft1 = _W / 2;

    	nWidth1 = _W;
    	nHeight1 = (spacer * 2) + params.thumbH;
    elseif (params.dire == "bottom") then
    	nTop = _H - (params.thumbH + (spacer * 2));
    	nLeft = 0; nWidth = _W;
    	nHeight = (spacer * 2) + params.thumbH;
    	nVert = true; nHor = false

    	nTop1 = _H - ((params.thumbH + (spacer * 2))/2);
    	nLeft1 = _W / 2;

    	nWidth1 = _W;
    	nHeight1 = (spacer * 2) + params.thumbH;

    elseif (params.dire == "left") then
    	nTop = 0;
    	nLeft = 0;
    	nWidth = params.thumbW + (spacer * 2);
    	nHeight = _H;
    	nVert = false; nHor = true

    	nTop1 = _H / 2 ;
    	nLeft1 = (params.thumbW + (spacer * 2)) / 2;

    	nWidth1 = params.thumbW + (spacer * 2);
    	nHeight1 = _H;

    elseif (params.dire == "right") then
    	nTop = 0;
    	nLeft = _W - (params.thumbW + (spacer * 2));
    	nWidth = params.thumbW + (spacer * 2);
    	nHeight = _H;
    	nVert = false; nHor = true

    	nTop1 = _H / 2;
    	nLeft1 = _W - ((params.thumbW + (spacer * 2)) /2);

    	nWidth1 = params.thumbW + (spacer * 2);
    	nHeight1 = _H;
	end


	--creates the background
	local naviBackground = display.newRect( nLeft1, nTop1, nWidth1, nHeight1 )
       naviBackground:setFillColor (params.backColor[1]/255,params.backColor[2]/255,params.backColor[3]/255)
       naviBackground.alpha = params.alpha;
       _K.kNavig:insert(naviBackground);

	--create navigation
    navItems = display.newGroup()

	--controls thumbnails actions
	local menuItemTap = function ( event )
	print("current page: "..cpage.." clicked: "..event.target.id)

		if cpage  ~= event.target.id then -- director.getCurrBookPageNum() ~= event.target.id then
			local togo = "views.page0"..event.target.id.."Scene"

			--variable to control disposal on runtime events for multipliers
			_K.disposeMultiplier = 1

			if (#audios > 0) then
				--dispose audios
				for x = 1,#audios do
					audio.stop(audios[x][1]); audio.dispose(audios[x][2]); audios[x][2] = nil
				end
			end
			if (numAnim==1) then
				--_K.cancelAllTweens()
				--_K.cancelAllTransitions()
			end
			if (numTimers==1) then
				_K.cancelAllTimers()
			end
			--director:changeScene ( imgDir..togo, true )
			--director:changeScene ( togo, true )
			--director:changeScene ( togo)
			Navigation.hide()

			--composer.gotoScene(composer.getCurrentSceneName(),{recreate=true})
			if nil~= composer.getScene(togo) then composer.removeScene(togo, true) end
			Navigation.hide()
			--4.3 removes the current scene from memory
			--print(togo, params.curPage, "page_"..params.curPage)
            if naviListener then
                naviListener()
            end

			composer.gotoScene( togo )
			-- composer.removeScene("page_"..params.curPage, true) ymmt
			return true
		end
	end
    --builds thumbnails
    local menuTab = {}
    for i=1, table.maxn( pageList ) do
    	-- print(pageList[i][1])
			local path = system.pathForFile( pageList[i][1],  _K.systemDir )
			if path then
	 		   menuTab[i] = display.newImage( pageList[i][1], _K.systemDir)
			else
			   print(pageList[i][1].. " does not exist!" )
	 		   menuTab[i] = display.newRect(0,0,100,100 )
		  end
   		   --1.0
		   --menuTab[i]:setReferencePoint( display.TopLeftReferencePoint )
		   --2.0
		   menuTab[i].anchorX = 0; menuTab[i].anchorY = 0.5;

		   menuTab[i].id = pageList[i][2]; --i
		   menuTab[i]:addEventListener( "tap", menuItemTap )

		   -- navigation positioning
		   if i == 1 and params.dire == "bottom" then
			  menuTab[i].x = spacer
			  menuTab[i].y = ( params.thumbH / 2 ) + (spacer / 2)
		   elseif i == 1 and params.dire == "top" then
			  menuTab[i].x = spacer
			  menuTab[i].y = ( params.thumbH / 2 ) + (spacer / 2)  --0 + spacer + menuTab[i].y
		   elseif i == 1 and params.dire == "left" then
			  menuTab[i].x = spacer + menuTab[i].x
			  menuTab[i].y = 0 + spacer + (menuTab[i].height / 2)
		   elseif i == 1 and params.dire == "right" then
			  menuTab[i].x = 0 + spacer + menuTab[i].x
			  menuTab[i].y = 0 + spacer + (menuTab[i].height / 2)
		   elseif i ~= 1 and params.dire == "bottom" then
			  menuTab[i].x = menuTab[i-1].x + spacer + menuTab[i-1].width
			  menuTab[i].y = menuTab[i-1].y
		   elseif i ~= 1 and params.dire == "top" then
			  menuTab[i].x = menuTab[i-1].x + spacer + menuTab[i-1].width
			  menuTab[i].y = ( params.thumbH / 2 ) + (spacer / 2)
		   elseif i ~= 1 and params.dire == "left" then
			  menuTab[i].x = menuTab[i-1].x
			  menuTab[i].y = menuTab[i-1].y + spacer + menuTab[i].height
		   elseif i ~= 1 and params.dire == "right" then
			  menuTab[i].x = menuTab[i-1].x
			  menuTab[i].y = menuTab[i-1].y + spacer + menuTab[i].height
		   end

		   navItems:insert( menuTab[i] )
	end

	   -- Scroll objects
	   --Position of the scrollview
	   _K.kNavigation = widget.newScrollView {
          top = nTop,
          left = nLeft,
          width = nWidth,
          height = nHeight,
          hideScrollBar = false,
          hideBackground = true,
          verticalScrollDisabled = nVert;
          horizontalScrollDisabled = nHor;
          --bgColor = { 255,255,255,255 }
       }


       --_K.kNavigation.verticalScrollDisabled = nVert;
       --_K.kNavigation.horizontalScrollDisabled = nHor;


       _K.kNavigation:insert(navItems)
       _K.kNavig:insert(_K.kNavigation)

    if (params.dire == "top") then
        _K.kNavig:translate(0, (display.contentHeight - display.safeActualContentHeight)/2)
    elseif (params.dire == "bottom") then
        _K.kNavig:translate(0, (display.contentHeight - display.safeActualContentHeight)/2)
    elseif (params.dire == "left") then
        _K.kNavig:translate((display.contentWidth - display.safeActualContentWidth)/2, 0)
    elseif (params.dire == "right") then
        _K.kNavig:translate((display.contentWidth - display.safeActualContentWidth)/2, 0)
    end

     local function touchNavig(event)
          --do not allow swipe of the next/previous page
          return true
       end
     _K.kNavig:addEventListener( "touch", touchNavig )


     Navigation.hide = function( obj, params )
		_K.kNavig.alpha = 0
	end

	Navigation.show = function( obj, params )
		_K.kNavig.alpha = 1
    	--calculates current page in the scroll
    	local tGo = 1
    	local xx = 1

    	for i=1, table.maxn( pageList ) do
    		if (pageList[i][2] == cpage) then
    			xx = i
    		end
    	end

	    --compatibility with widget 2.0 library
	    if (dire == "bottom") then
			local tGo = ( ((xx - 1) * spacer) + ((xx - 1) * thumbW) ) -- - (thumbW / 2)
			_K.kNavigation:scrollToPosition{ x = tGo*-1, y = nil } --, time = 500, onComplete = scrollCompleted}
    	elseif (dire == "top") then
			local tGo = ( ((xx - 1) * spacer) + ((xx - 1) * thumbW) ) -- - (thumbW / 2) + ((spacer*1)+(thumbW / 2) - 10)
			_K.kNavigation:scrollToPosition{ x = tGo*-1, y = nil } --, time = 500, onComplete = scrollCompleted}
		elseif (dire == "left") then
			local tGo = ( ((xx - 1) * spacer) + ((xx - 1) * thumbH) ) --  - (thumbH / 2)

			_K.kNavigation:scrollToPosition{ x = nil, y = tGo*-1 }
		elseif (dire == "right") then
			local tGo = ( ((xx - 1) * spacer) + ((xx - 1) * thumbH) ) -- - (thumbH / 2)
			_K.kNavigation:scrollToPosition{ x = nil, y = tGo*-1 }
		end

		--starts a timer. If nothing is pressed in 10 seconds, hide the panel
		local function hideAgain()
			if _K.kNavig.alpha == 1 then
				Navigation.hide()
			end
		end
		_K.timerStash.timer_nav = timer.performWithDelay( 5000, hideAgain )

	end

	return obj

end







return Navigation
