local _M = {}
--
local _K = require "Application"
--
local xFactor = display.contentWidth / 1920
local yFactor = display.contentHeight / 1280
local swipeLength = {{swipeLength}} / 4

local props = {
  infinity = nil,
  backLayer = nil,
  backLayer_2 = nil,
  bookshelf = nil,
  readRight = false -- bidi
}


function _M:pageSwap(event)
  local options
  if event.phase == "ended" and event.direction ~= nil then
    local wPage = self.curPage
    if props.readRight then
      if event.direction == "left" then
        wPage = self.curPage - 1
        if wPage < 1 then
          wPage = 1
        end
        options = {effect = "fromLeft"}
      elseif event.direction == "right" then
        wPage = self.curPage + 1
        if wPage > self.numPages then
          wPage = self.curPage
        end
        options = {effect = "fromRight"}
      end
    else
      if event.direction == "left" then
        wPage = self.curPage + 1
        if wPage > self.numPages then
          wPage = self.curPage
        end
        options = {effect = "fromRight"}
      elseif event.direction == "right" then
        wPage = self.curPage - 1
        if wPage < 1 then
          wPage = 1
        end
        options = {effect = "fromLeft"}
      end
    end
    if props.bookshelf then
      local ui = require("components.store.UI")
      if tonumber(wPage) ~= tonumber(self.curPage) then
        if ui.setDir(wPage) then
          ui.showView(self.curPage, wPage, options)
        end
      else
        ui.gotoTOC(options)
      end
    else
      if tonumber(wPage) ~= tonumber(self.curPage) then
        _K.appInstance:showView("views.page0" .. wPage .. "Scene", options)
      end
    end
  end
end

--
function _M:init(UI)
end
--
function _M:create(UI)
  local sceneGroup = UI.scene.view
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  local sceneGroup = UI.scene.view
  local layer = UI.layer

  if props.backLayer == nil then return end

  self.curPage = UI.curPage
  self.numPages = UI.numPages
  self.pageSwipeHandler = function(event)
    self:pageSwipe(event)
  end

  _K.Gesture.activate(props.backLayer, {swipeLength = swipeLength})
  if props.infinity then
    if props.backLayer_2 then
      _K.Gesture.activate(props.backLayer_2, {swipeLength = swipeLength})
    end
  end

  props.backLayer:addEventListener(_K.Gesture.SWIPE_EVENT, self.pageSwipeHandler)
  if props.infinity then
    props.backLayer_2:addEventListener(_K.Gesture.SWIPE_EVENT, self.pageSwipeHandler)
  end
end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view
  local layer = UI.layer
  if props.backLayer and self.pageSwipeHandler then
    props.backLayer:removeEventListener(_K.Gesture.SWIPE_EVENT, self.pageSwipeHandler)
    if props.infinity then
      props.backLayer_2:removeEventListener(_K.Gesture.SWIPE_EVENT, self.pageSwipeHandler)
    end
  end
end
--
function  _M:destory()
end
--
return _M
