local name = ...
local parent,root = newModule(name)
local mui = require("materialui.mui")

local props = require(root.."model").pageTools.audio
props.anchorName = "selectAudio"
props.icons      = {"addAudio", "trash"}
props.objs       = {}

------------
-- baseTable
-----------
local M, bt, tree = require(root.."baseTable").new(props)

local propsTable = require(root .. "parts.propsTable")

local actionCommandPropsTable = require("editor.action.actionCommandPropsTable")
local classProps              = require("editor.parts.classProps")

local layerTableCommands = require("editor.parts.layerTableCommands")
local contextButtons = require("editor.parts.buttons")

local posX = display.contentCenterX*0.75

function M.mouseHandler(event)
  if event.isSecondaryButtonDown and event.target.isSelected then
    -- print("@@@@selected")
    contextButtons:showContextMenu(posX, event.y,  {type="audio", selections=M.selections})
  else
    -- print("@@@@not selected")
  end
  return true
end

-- target.class will be audio.long or audio.short or audio.sync
-- a sync audio can be multiple

function M:commandHandler(target, event)
  if event.phase == "began" or event.phase == "moved" then  return end
  layerTableCommands.clearSelections(self, "audio")
  if self.isAltDown() then
    if layerTableCommands.showLayerProps(self, target) then
      print("TODO show audio props")
      print(target.audio)
      --
      tree.backboard = {
        audio = target.audio,
        show = true,
        class = target.class,
        subclass = target.subclass
      }
      tree:setConditionStatus("select component", bt.SUCCESS, true)
      tree:setActionStatus("load audio", bt.RUNNING, true)
      tree:setConditionStatus("select audio", bt.SUCCESS)
    end
  elseif self.isControlDown() then -- mutli selections
    layerTableCommands.multiSelections(self, target)
  else
    if layerTableCommands.singleSelection(self, target) then
      UI.editor.currentLayer = target.audio
      -- target.isSelected = true
      UI.editor.currentClass = target.name
      --
      -- should we enable one of them?
      actionCommandPropsTable:setActiveProp(target.audio)
      classProps:setActiveProp(target.audio)
    end
  end
  return true
end

--
function M:create(UI)
  if self.rootGroup then return end
  self:initScene(UI)
  self.UI = UI

  self.option = {
    text = "",
    x = 0,
    y = self.rootGroup.selectAudio.y,
    width = 100,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }


  M.selections = {}

  --

  local function render(_models, xIndex, yIndex)
    local count = 0
    local marginX, marginY = 74, 20
    local option = self.option

    local function newAudio(models, subclass)
      if models == nil then
        return
      end
      for i = 1, #models do
        local name = models[i]
        print(i)

        option.text = name
        option.x = self.rootGroup.selectAudio.x + marginX + xIndex * 5
        option.y = self.rootGroup.selectAudio.y + marginY + option.height * (count-1)
        option.width = 100
        local obj = self.newText(option)
        obj.audio = name
        obj.class = "audio"
        obj.subclass = subclass
        obj.index =1
        -- obj.touch = commandHandler
        -- obj:addEventListener("touch", obj)

        obj.touch = function(eventObj, event)
          self:commandHandler(eventObj, event)
          UI.editor.selections = self.selections
        end
        obj:addEventListener("touch", obj)
        obj:addEventListener("mouse", self.mouseHandler)


        local rect = display.newRect(obj.x, obj.y, obj.width + 10, option.height)
        rect:setFillColor(0.8)
        self.group:insert(rect)
        self.group:insert(obj)

        count = count + 1
        obj.rect = rect
        self.objs[#self.objs + 1] = obj
      end
    end
    --
    newAudio(_models.short, "short")
    --
    marginX = marginX + option.width
    count = 0
    newAudio(_models.long, "long")
    --
    self.marginX = marginX
    self.rootGroup:insert(self.group)
    self.rootGroup.audioTable = self.group
    -- self.group.isVisible = true
  end

  UI.editor.audioStore:listen(
    function(foo, fooValue)
      self:destroy()
      -- print("layerStore", #fooValue)
      self.selection = nil
      self.selections = {}
      self.objs = {}
      if fooValue == nil then
        render({}, 0, 0)
      else
        render(fooValue, 0, 0)
        if fooValue.short == nil then
          self:createIcons(11, 22)
        else
          self:createIcons(self.marginX)
        end
      end
      self:show()
    end
  )
end
--

function M:show()
  self.group.isVisible = true
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = true
    end
  end
end

function M:hide()
  self.group.isVisible = false
  if self.objs then
    for i=1, #self.objs do
      self.objs[i].isVisible = false
    end
  end
end

--
function M:destroy()
  if self.objs then
    for i = 1, #self.objs do
      if self.objs[i].isMUI then
        -- print("@@@@@", self.objs[i].name)
        mui.removeWidgetByName(self.objs[i].name)
      else
        if self.objs[i].rect then
          self.objs[i].rect:removeSelf()
        end
        if self.objs[i].removeSelf then
          self.objs[i]:removeSelf()
        end
      end
    end
  end
  self.objs = nil
  self.selection = nil
  self.rootGroup.audioTable = nil
end
--
return M
