local M = {}
M.name = ...
M.weight = 1
---
local mui = require("materialui.mui")
local mouseHover = require "extlib.plugin.mouseHover" -- the plugin is activated by default.

local prevHover, hoverObj

local onMouseHover = function(event)
  -- print(event.target.hoverText)
  if hoverObj == nil and prevHover ~= event.target.hoverText then
    local textOptions = {
      --   parent = group,
      text = event.target.hoverText,
      x = event.x,
       --display.contentCenterX,
      y = event.y + 20,
      width = event.target.hoverText:len() * 10,
      font = native.systemFont,
      fontSize = 12,
      align = "left" -- Alignment parameter
    }
    hoverObj = display.newText(textOptions)
    hoverObj:setFillColor(1, 1, 0)
    prevHover = event.target.text
    timer.performWithDelay(
      500,
      function()
        hoverObj:removeSelf()
        hoverObj = nil
      end
    )
  end
  --for k, v in pairs (event.target) do print(k ,v ) end
end

function M:create(Props)
  mui.createRectButton {
    parent = mui.getParent(),
    name = Props.name,
    text = Props.text or "",
    x = Props.x or display.contentCenterX,
    y = Props.y or display.contentCenterY,
    width = Props.width or 30,
    height = Props.height or 30,
    fontSize = Props.fontSize or 30,
    fillColor = {0, 0, 0},
    textAlign = "center",
    state = {
      value = "on",
      off = {
        textColor = {0, 0, 0, 1},
        fillColor = {0.25, 0.75, 1, 1},
        iconImage = "assets/images/icons/" .. Props.icon[1] .. ".png"
      },
      on = {
        textColor = {0, 0, 0, 1},
        fillColor = {.8, .8, .8, 1},
        iconImage = "assets/images/icons/" .. Props.icon[2] .. ".png"
      },
      disabled = {
        -- textColor = {.3, .3, .3, 1},
        -- fillColor = {0.3, 0.3, 0.3, 1},
        iconImage = "assets/images/icons/" .. Props.icon[3] .. ".png"
      }
    },
    callBack = Props.listener -- do not like wheel picker on native device.
  }
  local obj = mui.getWidgetBaseObject(Props.name)
  --obj:addEventListener("mouseHover", onMouseHover)
  obj.anchorY = 0
  return obj
end

function M:destory(name)
  mui.removeRectButton(name)
end

function M:createImage(Props)
  mui.createRectButton {
    parent =  Props.parent or mui.getParent(),
    name = Props.name,
    text = Props.text or "",
    x = Props.x or display.contentCenterX,
    y = Props.y or display.contentCenterY,
    width = Props.width or 16,
    rectWidth = 100,
    height = Props.height or 16,
    fontSize = Props.fontSize or 16,
    fillColor = {0, 0, 0},
    textAlign = "center",
    state = {
      value = "on",
      off = {
        textColor = {0, 0, 0, 1},
        fillColor = {1, 1, 1, 1}, --fillColor = {0.25, 0.75, 1, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. "_over.png"
      },
      on = {
        textColor = {0, 0, 0, 1},
        fillColor = {.8, .8, .8, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. "Color.png"
      },
      disabled = {
        textColor = {.3, .3, .3, 1},
        fillColor = {0.3, 0.3, 0.3, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. ".png"
      }
    },
    callBack = Props.listener -- do not like wheel picker on native device.
  }
  local obj = mui.getWidgetBaseObject(Props.name)
  obj.name = Props.name
  --obj:addEventListener("mouseHover", onMouseHover)
  obj.anchorY = 0
  return obj
end

function M:createToolImage(Props)
  mui.createRectButton {
    parent = Props.parent or mui.getParent(),
    name = Props.name,
    text = Props.text or "",
    x = Props.x or display.contentCenterX,
    y = Props.y or display.contentCenterY,
    width = Props.width or 30,
    rectWidth = 100,
    height = Props.height or 30,
    fontSize = 30,
    fillColor = {0, 0, 0},
    textAlign = "center",
    state = {
      value = "on",
      off = {
        textColor = {0, 0, 0, 1},
        fillColor = {0.25, 0.75, 1, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. ".png"
      },
      on = {
        textColor = {0, 0, 0, 1},
        fillColor = {1, 1, 1, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. "Color_over.png"
      },
      disabled = {
        textColor = {.3, .3, .3, 1},
        fillColor = {0.3, 0.3, 0.3, 1},
        iconImage = "assets/images/icons/" .. Props.icon .. "_over.png"
      }
    },
    callBack = Props.listener -- do not like wheel picker on native device.
  }
  local obj = mui.getWidgetBaseObject(Props.name)
  obj.hoverText = Props.hoverText
  obj.anchorY = 0
  obj:addEventListener("mouseHover", onMouseHover)
  return obj
end

M.new = function()
  local instance = {}
  return setmetatable(instance, {__index = M})
end
--
return M
