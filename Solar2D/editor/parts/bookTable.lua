local name = ...
local parent,  root = newModule(name)
local nanostores = require("extlib.nanostores.index")
local buttons    = require("editor.parts.buttons")

local Props = {
  name = "book",
  anchorName = "selectBook",
  id = "book"
}

local M, bt, tree = require(root.."baseTable").new(Props)

local btNodeName = "select book"

function M.btHandler(target)
  local UI = M.UI
  local books = UI.editor.bookStore.value
  for i=1, #books do
    if books[i].name == target.book then
      print(i, books[i].name)
      UI.editor.currentBook = target.book
      tree:setConditionStatus(btNodeName, bt.FAILED, true)
      tree:setConditionStatus("select page", bt.FAILED, true)
      tree:setConditionStatus("select layer", bt.FAILED, true)
      tree:setActionStatus("load page", bt.RUNNING) -- need a tick to call self.group:tick()
      --
      tree:setConditionStatus(btNodeName, bt.SUCCESS)
      break
    end
  end
end
---
--local muiTable = require("components.mui.table").new()
---
function M:init(UI)
  self.selection = nil
  self.UI = UI
end

local function mouseHandler(event)
  if event.isSecondaryButtonDown then
    print(event.target.book)
    buttons:showContextMenu(event.x+20, event.y-10,
      {type=event.target.text, selections={event.target},
      contextMenu = {"create", "rename", "delete"}, orientation = "horizontal"})
  else
    -- print("@@@@not selected")
  end
  return true
end

--
function M.commandHandler(target, event, isReload)
  local UI = M.UI
  if event and (event.phase == "began" or event.phase == "moved") then return end
  buttons:hide()
  if isReload then
    for i=1, #M.objs do
      if M.objs[i].book == target.book then
        target = M.objs[i]
        break
      end
    end
  end

  if M.selection then
    M.selection.rect:setFillColor(0.8)
  end

  -- print(target.book,self.UI.editor.currentBook)
  -- if target.book == UI.editor.currentBook then
  --   M.btHandler(target)
  -- else
    UI.scene.app:dispatchEvent {
      name = "editor.selector.selectBook",
      UI = UI,
      book = target.book
    }
    target.rect:setFillColor(0,1,0)
    M.selection = target
  -- end
end

--
function M:create(UI)
  if self.rootGroup then return end
  self:initScene(UI)
    -- print("create", self.name)

  self.option = {
    parent = nil, -- self.rootGroup,
    text = "",
    x = self.rootGroup.selectBook.x + 40,
    y = self.rootGroup.selectBook.y,
    width = nil,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }

  UI.editor.bookStore:listen(
    function(foo, models)
      local option = self.option
      self:clean()
      -- print("bookStore", #models)
      -- timer.performWithDelay( 100, function()
        local last_x = 60
        local objs = {}
        for index = 1, #models do
          local model = models[index]
          option.text = model.name


          local obj = self.newText(option)
          obj.book = model.name
          obj.index = index
          obj.touch = self.commandHandler
          obj:addEventListener("touch", obj)
          obj:addEventListener("mouse", mouseHandler)
          -- print(obj.book)

          if index > 1 then
            obj.x = obj.width/2 + objs[index-1].contentBounds.xMax + 5
          end
          local rect = display.newRect(obj.x, obj.y, obj.width+10,option.height)
          rect:setFillColor(0.8)
          self.group:insert(rect)
          self.group:insert(obj)
          objs[index] = obj
          obj.rect = rect
        end
        self.rootGroup:insert(self.group)
        self.rootGroup.bookTable = self.group
        self.objs = objs
      -- end)
    end
  )
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function M:destroy()
end

--
return M
