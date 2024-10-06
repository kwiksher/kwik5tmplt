local M = {}
--
local widget = require("widget")
local App = require("controller.application")
--
function M:setScroll(UI)
  local sceneGroup = UI.sceneGroup
  local layerName = self.properties.target
  self.obj = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end

  local sceneGroup = UI.scene.view
  local layerName = self.properties.target
  local obj = UI.sceneGroup[layerName]
  if obj == nil then
    return
  end
  ---
  local props = self.properties
  local _top = 0
  local _left = 0
  local _width = 0
  local _height = 0
  local _scrollWidth = 0
  local _scrollHeight = 0
  --
  if props.type == "group" or props.type == "page" then
    if props.area == "paragraph" then
      _top = obj.contentBounds.yMin
      _left = obj.contentBounds.xMin
      _width = obj.width + 10 - props.width
      _height = obj.height
      _scrollWidth = obj.width
      _scrollHeight = obj.height
    end

    if props.area == "page" then
      _top = obj.contentBounds.yMin
      _left = obj.contentBounds.xMin
      _width = props.width or 0
      _height = props.height or 0
      _scrollWidth = props.scrollWidth or 0
      _scrollHeight = props.scrollHeight or 0
    end

    if props.area == "object" then
      _top = obj.contentBounds.yMin
      _left = obj.contentBounds.xMin
      _width = obj.width + 10 - props.width
      _height = obj.height
      _scrollWidth = obj.width
      _scrollHeight = obj.height
    end

    if props.area == "manual" then
      _top = props.top or _top
      _left = props.left or _left
      _width = props.width or _width
      _height = props.height or _height
      _scrollWidth = props.scrollWidth or _scrollWidth
      _scrollHeight = props.scrollHeight or _scrollHeight
    end
    --
    local _width = (_width == 0) and obj.width or _width
    local _height = (_height == 0) and obj.height or _height
    local _scrollWidth = (_scrollWidth == 0) and obj.width or _scrollWidth
    local _scrollHeight = (_scrollHeight == 0) and obj.height or _scrollHeight

    local options = {
      top = _top,
      left = _left,
      width = _width,
      height = _height,
      scrollWidth = _scrollWidth,
      scrollHeight = _scrollHeight,
      baseDir = App.getProps().systemDir
    }

    if props.hideScrollBar then
      options.hideScrollBar = true
    end
    if props.hideBackGround then
      options.hideBackground = true
    end
    if props.horizontalScrollDisabled then
      options.horizontalScrollDisabled = true
    end
    if props.verticalScrollDisabled then
      options.verticalScrollDisabled = true
    end
    --
    local scrollObj = widget.newScrollView(options)

    if props.maskFile then
      local mask = graphics.newMask(_K.imgDir .. props.maskFile)
      obj:setMask(mask)
    end

    sceneGroup:insert(scrollObj)
    scrollObj:insert(obj)

    if props.type ~= "manual" then
      scrollObj.x = scrollObj.width / 2
      scrollObj.y = scrollObj.height / 2
    else
      if props.horizontalScrollDisabled then
        scrollObj.x = scrollObj.width / 2
      --scrollObj.y = scrollObj.height / 2
      end
      if props.verticalScrollDisabled then
        -- scrollObj.x = scrollObj.width / 2
        scrollObj.y = scrollObj.height / 2
      end
    end
  else --- normal layer
    if props.area == "paragraph" then
      _top = obj.y
      _left = obj.x
      _width = obj.layerProps.widht
      _height = obj.layerProps.height
      _scrollWidth = props.scrollWidth
      _scrollHeight = props.scrollHeight
    end
    if props.area == "page" then
      _top = obj.y
      _left = obj.x
      _width = obj.width + 10
      _height = props.height
      _scrollWidth = props.scrollWidth
      _scrollHeight = props.scrollHeight
    end
    if props.area == "object" then
      _top = obj.y
      _left = obj.x
      _width = obj.width + 10
      _height = obj.height
      _scrollWidth = props.scrollWidth
      _scrollHeight = props.scrollHeight
    end
    if props.area == "manual" then
      _top = props.top
      _left = props.left
      _width = props.width
      _height = props.height
      _scrollWidth = props.scrollWidth
      _scrollHeight = props.scrollHeight
    end
    --
    _width = (_width == 0) and obj.width or _width
    _height = (_height == 0) and obj.height or _height
    _scrollWidth = (_scrollWidth == 0) and obj.width or _scrollWidth
    _scrollHeight = (_scrollHeight == 0) and obj.height or _scrollHeight
    --
    local options = {
      top = _top,
      left = _left,
      width = _width,
      height = _height,
      scrollWidth = _scrollWidth,
      scrollHeight = _scrollHeight,
      baseDir = App.getProps().systemDir
    }

    if props.hideScrollBar then
      options.hideScrollBar = true
    end
    if props.hideBackGround then
      options.hideBackground = true
    end
    if props.horizontalScrollDisabled then
      options.horizontalScrollDisabled = true
    end
    if props.verticalScrollDisabled then
      options.verticalScrollDisabled = true
    end

    local scrollObj = widget.newScrollView(options)

    if props.maskFile then
      local mask = graphics.newMask(_K.imgDir .. props.maskFile)
      obj:setMask(mask)
    end
    --
    scrollObj:insert(obj)
    sceneGroup:insert(scrollObj)
    --
    if props.area ~= "manual" then
      scrollObj.x = scrollObj.width / 2
      scrollObj.y = 0
    end
  end
end

end
--
--
function M:didShow(UI)
end
--
return M
