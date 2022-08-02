local _M = {}
-- https://forums.coronalabs.com/topic/9760-buffered-movieclip-image-sequence/

-----------------------------
-- LOCALS
-----------------------------
local _W = display.contentWidth
local _H = display.contentHeight

--display.newRect(_W/2, _H/2, _W, _H)
-----------------------------
-- INCLUDES
-----------------------------
local MC         = require "extlib.movieclip"
local bufferNum  = 10
local prefix     = "test_HTML5 Canvas"
local clipNum    = 35
local movie      = nil --MC.new(bufferNum, _W/2, _H/2, _W, _H) -- x, y, width, height
local buff       = nil --MC.new(bufferNum, _W/2, _H/2, _W, _H)

--[[
local FPSCalculator = require("extlib.FPSCalculator")
local fpsCalculator = FPSCalculator.new(
    function(fps, fpsRatio)
        print("fps = " .. fps .. ", ratio = " .. fpsRatio)
        -- Do things here to handle a drop in frame rate, such as disable animations
    end,
    {
        fpsRatioWarningThreshold = 0.95,
        timeBetweenCalculationsMs = 10000,
    }
)
fpsCalculator:start()
--]]
-----------------------------
-- MOVIE
-----------------------------
local function _init(self) --set sequence
    local clip = {}
    local _len = string.len(self.preNum)
    if string.find(self.preNum, "1") then
    for i=1, self.clipNum do
        local j = "00000000" .. i
        j = j:sub(-_len)
        clip[i] = self.prefix..j..".png"
    end
    else
        for i=1, self.clipNum do
            local j = self.preNum .. (i-1)
            j = j:sub(-_len)
            clip[i] = self.prefix..j..".png"
        end
    end
    --set table
    local clipSet = {}
    local count = 1
    for  i = 1, 5 do
        local smallclip = {}
        for j = 1, 20 do
            smallclip[j] = clip[count]
            count = count + 1
        end
        clipSet[i] = smallclip
    end
    self.clip = clip
    self.clipSet = clipSet
end

function _M:init(name, preNum, num, x, y, width, height, sceneGroup)
	self.prefix = name
    self.preNum = preNum
	self.clipNum = num
  	self.movie      = MC.new(bufferNum, 0, 0, width, height)
	self.buff       = MC.new(bufferNum, 0, 0, width, height)
	self.buff.group.x = x
	self.buff.group.y = y
	self.movie.group.x = x
	self.movie.group.y = y
    _init(self)
    if sceneGroup then
        sceneGroup:insert(self.buff.group)
        sceneGroup:insert(self.movie.group)
        self.sceneGroup = sceneGroup
    end
end

function _M:removeSelf()
    self:stop()
    if self.sceneGroup then
        self.sceneGroup:remove(self.movie.group)
        self.sceneGroup:remove(self.buff.group)
    end
    self.movie.group:removeSelf()
    self.buff.group:removeSelf()
end

function _M:visible()
    if self.visibleWas == "movie" then
        self.movie.group.alpha = 1
    elseif (self.visibleWas == "buff") then
        self.buff.group.alpha = 1
    end
end

function _M:invisible()
    self.visibleWas = ""
    if self.movie.group.alpha == 1 then
        self.movie.group.alpha = 0
        self.visibleWas = "movie"
    end
    if self.buff.group.alpha == 1 then
        self.buff.group.alpha = 0
        self.visibleWas = "group"
    end
end
-----------------------------
-- MOVIE FUNCTION
-----------------------------

function _M:play(option)
    local param = option or {}
    local loop = 0
	local slide , count, isLastBuffer
    local newset = {}
    --
    local function _init ()
        slide = 1
        count = 1
        isLastBuffer = false
        for i = 1, bufferNum do newset[i] = self.clip[count]; count = count + 1 end
        self.movie:newAnim(newset)
        self.movie:play()
        self.movie.group.alpha = 1
        self.buff.group.alpha = 0
    end
    --
    _init()
	--Event Listener
	self.playing = function ( event )
		--print( display.fps )
		if self.movie.group.alpha == 1 then
            --print( self.movie:currentFrame(), self.movie:totalFrames())
			if self.movie:currentFrame() == self.movie:totalFrames() * 0.5 then
				--slide = slide + 1
				if slide < bufferNum then
					--print("  1", count)
					local newset = {}
                    for i = 1, bufferNum do
                        if count <= self.clipNum then
                            newset[i] = self.clip[count]
                            count = count + 1
                        else
                            isLastBuffer = true
                            --print("##")
                        end
                    end
					self.buff:newAnim(newset)
					self.buff:stop()
					self.buff.group.alpha = 0
				end
			elseif self.movie:currentFrame() == self.movie:totalFrames() then
                --print("  2", count, isLastBuffer, param.loop, loop)
                if isLastBuffer then
                    if param.loop == loop then
                        self.movie:stop()
                        if param.onComplete then param.onComplete() end
                    else
                        _init ()
                    end
                    loop = loop + 1
                else
                    self.buff:play()
                    self.buff.group.alpha = 1
                    self.movie:stop()
                    self.movie.group.alpha = 0
                end
			end
        else
            --print( self.buff:currentFrame(), self.buff:totalFrames())
			if self.buff:currentFrame() == self.buff:totalFrames() * 0.5 then
				--slide = slide + 1
				if slide < bufferNum then
					--print("  3", count)
					local newset = {}
                    for i = 1, bufferNum do
                        if count <= self.clipNum then
                            newset[i] = self.clip[count]
                            count = count + 1
                        else
                            isLastBuffer = true
                            --print("$$")
                        end
                    end
					self.movie:newAnim(newset)
					self.movie:stop()
					self.movie.group.alpha = 0
				end
			elseif self.buff:currentFrame() == self.buff:totalFrames() then
                --print("  4", count, isLastBuffer)
                if isLastBuffer then
                    if param.loop == loop then
                        self.buff:stop()
                        if param.onComplete then param.onComplete() end
                    else
                        _init()
                    end
                    loop = loop + 1
                else
                    self.buff:stop()
                    self.buff.group.alpha = 0
                    self.movie:play()
                    self.movie.group.alpha = 1
                end
			end
		end
	end

	Runtime:addEventListener("enterFrame", self.playing)
	--timer.performWithDelay(50, self.playing, 10)
	--movie:play()
end

function _M:pause()
    self.isPaused = true
	if self.movie.group.alpha == 1 then
		self.movie:stop()
	else
		self.buff:stop()
	end
    Runtime:removeEventListener("enterFrame", self.playing)
    --self.playing = nil
end

function _M:resume()
    self.isPaused = false
	if self.movie.group.alpha == 1 then
		self.movie:resume()
	else
		self.buff:resume()
	end
	Runtime:addEventListener("enterFrame", self.playing)
end

function _M:stop()
	if self.movie.group.alpha == 1 then
		self.movie:stop()
	else
		self.buff:stop()
	end
    Runtime:removeEventListener("enterFrame", self.playing)
    self.playing = nil
end

return _M