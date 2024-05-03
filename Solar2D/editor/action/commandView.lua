name = ...
local parent,root = newModule(name)
local M = {name=name}

---
local muiIcon = require("components.mui.icon").new()
local mui     = require("materialui.mui")
local muiData = require("materialui.mui-data")
local widget  = require("widget")
---
local controller     = require(parent.."controller.index")

local function newText(option)
  local obj = display.newText(option)
  obj:setFillColor(0)
  return obj
end


function M:createTable( models, commandMap, group, selectLayer)

  local scrollListener  = function(e) end
  local  scrollView = widget.newScrollView{
       top                    = 22,
       left                   = display.contentCenterX-200,
       width                  = 100,
       height                 = 240,
    -- height                 = #models*18,
       scrollWidth            = display.contentWidth*0.5,
       scrollHeight           = display.contentHeight*0.8,
       hideBackground         = false,
       isBounceEnabled        = false,
       verticalScrollDisabled = false,
       backgroundColor        = {1.0},
       listener               = scrollListener
  }

  local option = {
    parent   = group,
    text     = "",
    x        = 0,
    y        = selectLayer.y or 0,
    width    = 100,
    height   = 16,
    font     = native.systemFont,
    fontSize = 10,
    align    = "left"
  }

  local count = 0
  for k, v in pairs(models or {}) do
    --print("actionEditor", self.name .. "-" .. v.name, v.icon)
    local obj = muiIcon:createImage {
      icon      = v.icon,
      text      = v.name,
      name      = self.name .. "-" .. v.name,
      x         = 60,
      y         = count*16,
      width     = 110,
      height    = 16,
      fontSize  = 10,
      listener  = controller.commandGroupHandler,
      fillColor = {1.0}
    }
    -- print(obj.name)
    --
    -- option.text = v.name
    -- option.x = 60
    -- option.y = option.height * count
    -- local obj = newText(option)
    -- obj.name = v.name
    -- obj.tap = commandHandler
    -- obj:addEventListener("tap", obj)
    --
    obj.model = v
    obj.children = v.children or {}
    --print("", obj.name)
    commandMap[obj.name] = obj
    scrollView:insert(obj)
    count = count + 1
    --
    if self.activeEntry ==  self.name .. "-" .. v.name then
      for i=1, #obj.children do
        local entry = v.children[i]
        -- local obj = muiIcon:createImage {
        --   icon = entry.icon,
        --   text = entry.name,
        --   name = self.name .. "-" .. v.name.. "-"..entry.name,
        --   x = 70,
        --   y = count*18,
        --   width = 120,
        --   height = 18,
        --   fontSize =12,
        --   listener = commandHandler
        -- }
        --
        option.text = entry.name
        option.x = 80
        option.y = option.height * count + 14
        --
        local obj = newText(option)
        obj.name = entry.name
        obj.tap = controller.commandHandler
        obj:addEventListener("tap", obj)
        obj.model = entry
        --
        commandMap[obj.name] = obj
        scrollView:insert(obj)
        count = count + 1
      end
    end
  end
  return scrollView
end
--
return M
