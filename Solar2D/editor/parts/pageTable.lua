local name = ...
local parent,  root = newModule(name)
local widget = require( "widget" )
local buttons    = require("editor.parts.buttons")

local Props = {
  name = "page",
  anchorName = "selectPage",
  id = "page"
}

local M, bt, tree = require(root.."baseTable").new(Props)

local btNodeName = "select page"

function M.btHandler(target)
  local self = M
  if self.selection and self.selection.rect then
    self.selection.rect:setFillColor(0.8)
    if self.selection.page ~= target.page then
      self.selection.rect:setFillColor(0.8)
      tree:setConditionStatus(btNodeName, bt.FAILED, true)
      tree:setActionStatus("load page", bt.RUNNING) -- need a tick to call self.group:tick()
    end
  else
    tree:setConditionStatus(btNodeName, bt.FAILED, true)
    tree:setActionStatus("load page", bt.RUNNING) -- need a tick to call self.group:tick()
  end

  self.selection = target
  if self.selection.rect then
    self.selection.rect:setFillColor(0,1,0)
  end

  tree.backboard = {
      page = target.page,
  }
  tree:setConditionStatus("select page", bt.SUCCESS)
  -- UI.scene.app:dispatchEvent {
  --   name = "editor.selector.selectPage",
  --   UI = self.UI,
  --   page = eventObj.page
  -- }
end

local function mouseHandler(event)
  if event.isSecondaryButtonDown then
    print(event.target.page, event.target.x, event.target.y, event.x, event.y)
    buttons:showContextMenu(event.x -10, event.y+10,
      {type=event.target.text, selections={event.target},
      contextMenu = {"create", "rename", "delete"}, orientation = "horizontal"})
  else
    -- print("@@@@not selected")
  end
  return true
end

-- use baseTable:commandHandler? no it does not have isReload yet
---[[
function M.commandHandler(target, event, isReload)
  -- local target = event.target
  local UI = M.UI
  local self = M
  -- print("touch", event.phase)
  buttons:hide()
  if event and (event.phase == "began" or event.phase == "moved") then  return end

  -- print("commandHandler", self.objs)
  -- print("", debug.traceback())
  self.isReload = isReload -- we will take if off when reload is ended
  if isReload and self.objs then
    for i=1, #self.objs do
      if self.objs[i].page == target.page then
        -- print("", self.objs[i].page)
        target = self.objs[i]
        self.selection = target
        break
      end
    end
  end

  self.btHandler(target)
end
--]]

function M:createTable(UI, columns, selection)
    -- print("-----pageStore", #models, self.selection)
    -- timer.performWithDelay( 500, function()
    local option = self.option
    -- local objs = {}

    local max = math.min(10, #columns)

    local scrollView = widget.newScrollView
    {
      top                      = option.y - option.height/2,
      left                     = option.x  - option.width/2,
      width                    =  max*option.width,
      height                   = option.height,
      scrollHeight             = option.height,
      scrollWidth            = #columns*option.width,
      verticalScrollDisabled   = true,
      horizontalScrollDisabled = false,
      -- width                    =  option.width,
      -- height                   = max*option.height,
      -- scrollHeight             = #columns*option.height,
      -- -- scrollWidth            = #columns*option.width,
      -- verticalScrollDisabled   = false,
      -- horizontalScrollDisabled = true,
      friction                 = 2,
    }


    local function createColumn(index, entry)
      local group = display.newGroup()
      --
      option.text = entry.name
      option.x =  option.width/2 + (index-1)*option.width
      option.y = option.height/2

      -- option.x = option.x
      -- option.y = option.height/2 + index*option.height

      local obj = self.newText(option)
      -- obj:setFillColor(0,1,0)
      obj.page = entry.name
      obj.tap = self.commandHandler

      -- function(eventObj)
      --   self:commandHandler(eventObj)
      --   self.selection.rect:setFillColor(0,1,0)
      -- end
      obj:addEventListener("tap", obj)
      obj:addEventListener("mouse", mouseHandler)

      index = index + 1
      obj.index = index

      local rect = display.newRect(obj.x, obj.y, obj.width, option.height)
      rect:setFillColor(0.8)

      group:insert(rect)
      group:insert(obj)
      scrollView:insert(group)
      obj.rect = rect
      return obj
    end

    for index=1, #columns do
      self.objs[index] = createColumn(index, columns[index])
    end


    if selection == nil then
      self.selection = self.objs[#self.objs]
      -- print("", "backboard", objs[#objs].page, objs[#objs])
      -- tree.backboard = {
      --   page = objs[#objs].page,
      -- }
      -- tree:setConditionStatus("select page", bt.SUCCESS)
    else
      for i=1, #self.objs do
        if self.objs[i].page == selection.page then
          self.selection = self.objs[i]
          break
        end
      end
    end
    --self.selection.rect:setFillColor(0, 1, 0)
    self.scrollView = scrollView
    self.group:insert(scrollView)
    self.rootGroup:insert(self.group)
    self.rootGroup.pageTable = self.group
    -- self.objs = objs
    -- print("-----------", "Done")
  -- end)

end
--
function M:create(UI)
  -- if self.rootGroup then return end
  self:initScene(UI)
  self.selections = {}
  ---


  UI.editor.pageStore:listen(
    function(foo, models)
      -- print(debug.traceback())
      self.option = {
        text = "",
        x = self.rootGroup.selectBook.x + 40,
        y = self.rootGroup.selectPage.y,
        width = 40,
        height = 20,
        font = native.systemFont,
        fontSize = 10,
        align = "left"
      }
      self:clean()
      self.objs = {}
      self:createTable(UI, models, self.selection )
    end
  )

  -- local function compare(a,b)
  -- 	return a.name < b.name
  -- end
  -- --
  -- table.sort(models,compare)
end
--
function M:didShow(UI)
  self.UI = UI
end
--
function M:didHide(UI)
end
--
function M:destroy()
  -- self:clean()
  -- print(debug.traceback())
  if self.objs then
    for k, obj in next, self.objs do
      obj.rect:removeSelf()
      obj:removeEventListener("touch", obj)
      obj:removeEventListener("mouse", mouseHandler)
      obj:removeSelf()
    end
  end
  self.objs = nil

end
--
--
return M
