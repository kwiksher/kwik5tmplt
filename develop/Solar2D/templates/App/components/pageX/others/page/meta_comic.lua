-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {timer={}}
local _K = require("Application")
local widget = require( "widget" )
--
--
local _Duration        = 3000
local _SheetWidth      = 1440 -- iPhone X
local _SheetHeight     = 2772 -- iPhone X
local _ContentWidth    = 1280
local _ContentHeight   = 1920
local _BackgroundColor = { 0.8, 0.8, 0.8 }
local _Scale           = 1.5
---------------------
---------------------
function _M:localPos(UI)
  local sceneGroup  = UI.scene.view
  local layer       = UI.layer
  --
  UI.layerSet_{{mySet}} = {
  {{#layerSet}}
    {
      myLName = "{{myLName}}",
      x       = {{mX}},
      y       = {{mY}},
      width   = {{elW}},
      height  = {{elH}},
      frameSet = {
      {{#frameSet}}
      {
        myLName = "{{myLName}}",
        x       = {{mX}},
        y       = {{mY}},
        width   = {{elW}},
        height  = {{elH}},
      },
      {{/frameSet}}
      }
    },
  {{/layerSet}}
  }
end
--
local frameTransition = nil
local index = 1
local pause = false
--
local function reset(UI, panels, ballons)
  print("--- reset ---")
    UI.scrollView.alpha = 0
    -- UI.layer.pageCurl.alpha = 1
    for i=1, #panels do
      local target = panels[i]
      target.panel.alpha  = 1
      target.panel.xScale = 1
      target.panel.yScale = 1
      target.panel.x, target.panel.y = _K.ultimatePosition(target.x, target.y)
    end
    ballons.x, ballons.y = 0, 0
    for i=1, ballons.numChildren do
      local ballon = ballons[i]
      ballon.alpha = 1
      ballon.xScale = 1
      ballon.yScale = 1
      ballon.x = ballon.oriX
      ballon.y = ballon.oriY
    end
    ballons:toFront()
    ballons.alpha = 1
    index = 1
    UI.layer.background.alpha = 1
end
--
function showNextBallon(ballon, fX, fY, oriX, oriY, delay)
  local bX, bY = ballon.oriX - oriX, ballon.oriY-oriY
  local _x = fX  + bX*_Scale
  local _y = fY  + bY*_Scale
  if delay == 0 then
    ballon.x = fX  + bX*_Scale
    ballon.y = fY  + bY*_Scale
  end
  transition.to(ballon, {x=_x, y=_y, alpha=1, xScale = _Scale, yScale = _Scale, delay = delay})
  -- anim---
  if ballon.anim then
    for k, v in pairs(ballon.anim) do
        v:toBeginning()
        v:play()
    end
  end
end
--
local function showBallon(ballon, target, frame, next, oriX, oriY, preBallons, nextBallons)
  ballon.alpha = 0
  ballon:scale(0.1, 0.1)
  if string.find(ballon.name, frame.myLName) then
    showNextBallon(ballon, target.panel.x, target.panel.y, oriX, oriY, 0)
    table.insert( preBallons, ballon )
  end
  if string.find(ballon.name, next.myLName) then
    ballon.isNext = true
    table.insert(nextBallons, ballon)
  end
end
--
local function hideBallon(ballon, nextDeltaX, nextDeltaY)
  if not ballon.isNext then
    transition.to(ballon, {alpha = 0, delay = _Duration})
  else
    transition.moveBy(ballon, {x= -nextDeltaX, y=-nextDeltaY, delay = _Duration} )
  end
end
--
local function translatePanel(UI, target, frame)
  -- anim---
  if target.panel.anim then
    for k, v in pairs(target.panel.anim) do
        v:toBeginning()
        v:play()
    end
  end
  target.panel.x       = UI.scrollView.x
  target.panel.y       = UI.scrollView.y
  if frame then
    target.panel:translate( (target.x - frame.x)/4, (target.y - frame.y)/4 )
  end
  target.panel:toFront()
  target.panel.alpha = 1
  target.panel.xScale = _Scale
  target.panel.yScale = _Scale
end
--
local function showFrame(UI, ballons, target)
  local k              = 1
  local frame          = target.frameSet[k]
  local next           = target.frameSet[k+1]
  -- print("frame "..frame.myLName)
  UI.scrollView.width  = frame.width/4*_Scale
  UI.scrollView.height = frame.height/4*_Scale
  local oriX, oriY     = target.panel.x, target.panel.y
  translatePanel(UI, target, frame)
  -- show up the ballon
  local preBallons, nextBallons = {}, {}
  for i=1, ballons.numChildren do
    local ballon = ballons[i]
    showBallon(ballon, target, frame, next, oriX, oriY, preBallons, nextBallons)
  end
  --------------------------------
  -- next frame
  --------------------------------
  local nextDeltaX, nextDeltaY =  (next.x - frame.x)/4, (next.y - frame.y)/4
  local fX, fY = target.panel.x - nextDeltaX, target.panel.y - nextDeltaY
  -- change mask(scrollView)'s width and height
  transition.to(UI.scrollView, {width=next.width/4*_Scale, height=next.height/4*_Scale, delay = _Duration})
  -- hide the pre ballon
  for i=1, #preBallons do
    local ballon = preBallons[i]
    hideBallon(ballon, nextDeltaX, nextDeltaY)
  end
  -- show up the ballon
  for i=1, #nextBallons do
    local ballon = nextBallons[i]
    showNextBallon(ballon, fX, fY, oriX, oriY, _Duration)
  end
  --show next frame
  transition.to(target.panel, {x=fX, y = fY, delay = _Duration,
    onComplete = function ()
      if not pause then
        index = index + 1
        local t = timer.performWithDelay(_Duration, frameTransition,1)
        table.insert(_M.timer, t)
      end
    end})
end
--
local function showPanel(UI, ballons, target)
  UI.scrollView.width  = target.width/4*_Scale
  UI.scrollView.height = target.height/4*_Scale
  local oriX, oriY = target.panel.x, target.panel.y
  translatePanel(UI, target, frame)
  for i=1, ballons.numChildren do
    local ballon = ballons[i]
    ballon.alpha = 0
    if string.find(ballon.name, target.myLName) then
      showNextBallon(ballon, target.panel.x, target.panel.y, oriX, oriY, 0)
    end
  end
  if not pause then
    local t = timer.performWithDelay(_Duration,
      function()
        index = index + 1
        frameTransition()
        end, 1)
    table.insert(_M.timer, t)
  end
end
---------------
--
---------------
function _M:didShow(UI)
  local sceneGroup  = UI.scene.view
  local panels  = UI.layerSet_panels
  local ballons = UI.layer.ballons
  local layer = UI.layer
  -------------------------------
  -- scrollView
  -------------------------------
  local options = {
   frames ={},
    -- sheetContentWidth = _SheetWidth/4,
    -- sheetContentHeight = _SheetHeight/4
    sheetContentWidth = layer.background.width,
    sheetContentHeight = layer.background.height
  }
  --
  local widthDiff = options.sheetContentWidth - _ContentWidth/4
  local heightDiff = options.sheetContentHeight - _ContentHeight/4
  --
  for i=1, #panels do
    local target = panels[i]
    local _x = (target.x - target.width/2)/4 + widthDiff/2
    local _y = (target.y - target.height/2)/4 + heightDiff/2
    -- print(_x, _y)
    options.frames[i] = {
      x = _x,
      y = _y,
      width = target.width/4,
      height = target.height/4
    }
    -- print(target.width/4, target.height/4)
  end
  --
  local scrollView = widget.newScrollView(
      {
          top             = 0,
          left            = 0,
          width           = display.contentWidth,
          height          = display.contentHeight,
          scrollWidth     = options.sheetContentWidth,
          scrollHeight    = options.sheetContentHeight,
          backgroundColor = _BackgroundColor,
          listener        = function() end
      }
  )
  ---------------
  -- create panels out of layer.background and layerSet_panels
  ---------------
  local sheet = graphics.newImageSheet(_K.imgDir..layer.background.imagePath, options )
  for i=1, #panels do
    local target             = panels[i]
    local frame              = options.frames[i]
    local frame1             = display.newImageRect( sheet, i, frame.width, frame.height )
    frame1.x, frame1.y       = _K.ultimatePosition(target.x, target.y)
    frame1.oriX              = frame1.x
    frame1.oriY              = frame1.y
    frame1.oriXs             = _Scale
    frame1.oriYs             = _Scale
    frame1.oldAlpha          = 1
    frame1.anim              = {}
    frame1.scrollView        = scrollView
    target.panel             = frame1
    UI.layer[target.myLName] = frame1
    scrollView:insert( frame1 )
    frame1:addEventListener( "tap",
      function()
        index = index + 1
        _M:cancel()
        _M:start(index)
        return true
      end  )
  end
  UI.scrollView          = scrollView
  sceneGroup:insert(scrollView)
  self._reset = function()
      reset(UI, panels, ballons)
  end
  -----------------------------
  -----------------------------
  frameTransition = function()
    if index > #panels then
      timer.performWithDelay( 1000, function()
        self._reset()
        self:cancel()
      end, 1)
      table.insert(_M.timer, t)
      self.isPlaying = false
      return
    end
    local target = panels[index]
    local frames = target.frameSet
    if index > 1 then
      panels[index-1].panel.alpha = 0
    end
    if target.frameSet and #target.frameSet > 0 then
      showFrame(UI, ballons, target)
    else
      showPanel(UI, ballons, target)
    end
  end
  ----------------------
  -- init
  UI.scrollView.alpha    = 0
  for i=1, #panels do
    panels[i].panel.alpha = 0
  end
  UI.layer.background.alpha = 0
  UI.layer.ballons.alpha    = 0
  --
  self._start = function()
    self.isPlaying = true
    if index > #panels then
      index = 1
    end
    -- UI.layer.pageCurl.alpha   = 0
    UI.layer.background.alpha = 0
    UI.scrollView.alpha       = 1
    UI.layer.ballons.alpha = 1
    --
    for i=1, #panels do
      panels[i].panel.alpha = 0
    end
    ballons:toFront()
    frameTransition()
  end
  --
  UI.panels = self
  --
  local t =  timer.performWithDelay(50, -- need to wait for pageCurl obj processed
   self._reset, 1)
  table.insert(self.timer, t)
end
--
function _M:start(i, p)
  index = i or 1
  pause = p or false
  self._start()
end
--
function _M:reset()
  self:cancel()
  self._reset()
end
--
function _M:tap()
  if self.isPlaying then
    index = index + 1
  end
  self:cancel()
  self:start(index)
end
function _M:cancel()
  transition.cancel()
  for i=1, #self.timer do
    timer.cancel(self.timer[i])
  end
  self.timer = {}
  self.isPlaying = false
end
--
function _M:toDispose(UI)
  UI.scrollView:removeSelf()
  self:cancel()
end
--
function _M:localVars()
end
--
return _M