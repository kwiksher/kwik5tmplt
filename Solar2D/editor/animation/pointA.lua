local M = {}
M.name = ...
M.weight = 6
local parent,  root = newModule(M.name)
local dragger = require("extlib.com.gieson.dragger")
local popup         = require(parent.."popup")

local Props = {
  popup 			= popup,
  ptTextFont = "Helvetica-Bold",
  ptTextSize = 18,
  ptTextColor = {255, 255, 255, 255},
}

---
function M:setValue(props)
end
--
function M:init(UI, x, y, width, height)
end
--
function M:create(UI)
    -- print("create", self.name)
    self.group = display.newGroup()
    self.objs = {}

    local ptAcolor = {255/255, 7/255, 17/255, 25/255}

    local obj = display.newGroup()

    local ptAdot = display.newCircle(0, 0, 15)
    ptAdot:setFillColor(unpack(ptAcolor))

    local ptAlabel = display.newText("A", 0, 0, Props.ptTextFont,
                                     Props.ptTextSize)
    ptAlabel:setTextColor(unpack(Props.ptTextColor))

    ptAlabel.x = 1.5
    ptAlabel.y = 0
    table.insert(self.objs, ptAdot)
    table.insert(self.objs, ptAlabel)

    local ptA = dragger:newDragger{
        img = self.group,
        callback = function() end,
        popup = Props.popup
    }
    self.group:insert(ptAdot)
    self.group:insert(ptAlabel
  )
    self.group:translate(display.contentCenterX-100, display.contentCenterY)
    self.group.ptA = ptA
end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
  if self.objs then
    for i, obj in next, self.objs do
      obj:removeSelf()
    end
  end
  self.objs = nil
end

--
function M:toggle()
  for i, obj in next, self.objs do
   obj.isVisible = not obj.isVisible
  end
end

function M:show()
  for i, obj in next, self.objs or {} do
    obj.isVisible = true
  end
end

function M:hide()
  for i, obj in next, self.objs or {} do
    obj.isVisible = false
  end
end


return M
