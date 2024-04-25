local M = {}
M.name = ...
M.weight = 7
local parent,  root = newModule(M.name)
local dragger = require("extlib.com.gieson.dragger")
local popup         = require(parent.."popup")


local Props = {
  popup 			= popup,
  ptTextFont = "Helvetica-Bold",
  ptTextSize = 18,
  ptTextColor = {255, 255, 255, 255},
}

--
function M:setValue(props)
end
---
function M:init(UI, x, y, width, height)
end
--
function M:create(UI)
    -- print("create", self.name)
    local group = UI.editor.rootGroup

    local ptBcolor = {0/255, 178/255, 255/255, 255/255}

    local obj = display.newGroup()

    local ptBdot = display.newCircle(0, 0, 15)
    ptBdot:setFillColor(unpack(ptBcolor))

    local ptBlabel = display.newText("B", 0, 0, Props.ptTextFont,
                                     Props.ptTextSize)
    ptBlabel:setTextColor(unpack(Props.ptTextColor))

    obj:insert(ptBdot)
    obj:insert(ptBlabel)
    ptBlabel.x = 1.5
    ptBlabel.y = 0

    local ptB = dragger:newDragger{
        img = obj,
        callback = function() end,
        popup = Props.popup
    }
    group:insert(obj)
    obj:translate(display.contentCenterX+100, display.contentCenterY)
    group.ptB = ptB
    self.obj = obj

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
  if self.obj then
    self.obj:removeSelf()
  end
  self.obj = nil
end
--
function M:toggle()
  self.obj.isVisible = not self.obj.isVisible
end
function M:show()
  self.obj.isVisible = true
end

function M:hide()
  self.obj.isVisible = false
end
return M
