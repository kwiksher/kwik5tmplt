local name = ...
local parent,root = newModule(name)
local mui = require("materialui.mui")
local muiIcon    = require("components.mui.icon").new()
local assetTableListener = require(parent.."assetTableListener")
local layerTable = require(root.."parts.layerTable")

local props = require(root.."model").assetTool
props.anchorName = "selectAction"
props.icons      = {"repVideo", "trash"}
props.objs       = {}
props.marginX = nil-- display.contentCenterX

------------
-- baseTable
-----------
local M, bt, tree = require(root.."baseTable").new(props)
--
M.x = display.contentCenterX - 480*0.75
M.y = 22
M.width = 100

local propsTable = require(root .. "parts.propsTable")
local selectors = require(root.."parts.selectors")

local layerTableCommands = require("editor.parts.layerTableCommands")
local contextButtons = require("editor.parts.buttons")
local posX = display.contentCenterX*0.75
local _marginX, _marginY = -16, 38

function M:createIcons (icons, class, tool)
  -- print("createIcons", self.anchorName,_marginX, _marginY)
  local marginX = _marginX or self.marginX
  local marginY = _marginY or 0
  ---
  for k, icon in next, self.icons do
    mui.removeWidgetByName(icon.name)
  end
  self.icons = {}
  ---
  for i=1, #icons do
    local name = icons[i]
    local actionIcon = muiIcon:create {
      icon = {name.."_over", name.."Color_over", name},
      text = "",
      name = name.."-icon",
      x = self.x + marginX + i*22,
      y = self.y,
      width = 22,
      height = 22,
      fontSize =16,
      fillColor = {1.0},
      listener = function(event) self:iconsHandler(event, class, tool) end
    }
    self.icons[i] = actionIcon
    self.group:insert(actionIcon)
  end
end

function M:init(UI)
end
--
function M:create(UI)
  if self.rootGroup then return end

  self:initScene(UI)

  self.option = {
    text = "",
    x = 0,
    y = 0,
    width = 100,
    height = 20,
    font = native.systemFont,
    fontSize = 10,
    align = "left"
  }


  M.selections = {}

  --

  local function render(models, class)

    local count = 0
    local marginX, marginY = 44, 50
    local option = self.option
    option.y = y
    for i = 1, #models do
      local asset = models[i]
      option.text =  asset.path .."/"..asset.name
      option.x = self.x + marginX
      option.y = self.y + option.height * (count-1) +marginY
      option.width = self.width + 80
      local obj = self.newText(option)
      obj.index = i
      obj.asset = asset
      obj.class = class
      -- obj.touch = commandHandler
      -- obj:addEventListener("touch", obj)

      obj.touch = function(eventObj, event)
        -- print("touch")
        self:touchHandler(eventObj, event)
        UI.editor.selections = self.selections
      end
      obj:addEventListener("touch", obj)
      obj:addEventListener("mouse", self.mouseHandler)

      local rect = display.newRect(obj.x, obj.y, obj.width + 10, option.height)
      rect:setFillColor(0.8)
      rect.strokeWidth = 1
      self.group:insert(rect)
      self.group:insert(obj)

      -- count = count + 1
      obj.rect = rect

      obj.links = {}
      if #asset.links == 0 then
        count = count + 1
      else
        for k=1, #asset.links do
          local link = asset.links[k]
          local pageObj
          if link.layers then
            option.text =  link.page
            option.x = self.x + option.width/2 + 10
            option.y = option.y - option.height/2 + 10 + option.height*(k-1)
            option.width = self.width
            pageObj = self.newText(option)
            pageObj.layers = {}
            ---
            local rect = display.newRect(pageObj.x, pageObj.y, pageObj.width + 10, option.height)
            rect:setFillColor(0.8)
            pageObj.rect = rect
            self.group:insert(rect)
            self.group:insert(pageObj)

           ----
            for j=1, #link.layers do
              option.text =  link.layers[j]
              option.x = option.x + option.width/2
              local layerObj = self.newText(option)
              layerObj.index = j
              layerObj.touch = function(eventObj, event)
                print(eventObj.text)
              end
              layerObj:addEventListener("touch", layerObj)
              table.insert(pageObj.layers, layerObj)
              local rect = display.newRect(layerObj.x, layerObj.y, layerObj.width + 10, option.height)
              rect:setFillColor(0.8)
              layerObj.rect = rect
              self.group:insert(rect)
              self.group:insert(layerObj)
            end
            count = count + 1
            -- print("count", count)
          else
            option.text =  link.page
            option.x = self.x + option.width/2 *k
            pageObj = self.newText(option)
            local rect = display.newRect(pageObj.x, pageObj.y, pageObj.width + 10, option.height)
            rect:setFillColor(0.8)
            pageObj.rect = rect
            self.group:insert(rect)
            self.group:insert(pageObj)
            count = count + 1
          end
          table.insert(obj.links, pageObj)
        end
      end
      self.objs[#self.objs + 1] = obj
    end

    --
    --
    self.rootGroup:insert(self.group)
    self.rootGroup.assetTable = self.group
    self.group:translate(self.width*0.5, 0)
    -- self.group.isVisible = true
  end

  UI.editor.assetStore:listen(function(foo, fooValue)
    self.x = self.rootGroup.layerTable.contentBounds.xMax
    self:storeListener(foo, fooValue, render)
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
        if self.objs[i].links then
          for k=1, #self.objs[i].links do
            local pageObj = self.objs[i].links[k]
            if pageObj and pageObj.layers then
              for j=1, #pageObj.layers do
                pageObj.layers[j].rect:removeSelf()
                pageObj.layers[j]:removeSelf()
              end
              pageObj.rect:removeSelf()
              pageObj:removeSelf()
            end
          end
        end
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
  self.rootGroup.assetTable = nil
end

local function copy(tbl)
	local newTbl = {}

	for key, value in pairs(tbl) do
		newTbl[key] = value
	end

	return newTbl
end
--
return setmetatable(copy(assetTableListener), {__index=M})

--[[
https://devforum.community/t/how-do-i-do-conditional-multiple-inheritance-in-lua-with-oop/343/2

-- Enemy:

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
	return setmetatable({}, Enemy)
end

-- Boss:

local Boss = setmetatable({}, Enemy)
Boss.__index = Boss

function Boss.new()
	return setmetatable({}, Boss)
end

-- Orc:

local Orc = {}

function Orc:method()

end

-- Orc methods and properties must be defined before you copy them!

local OrcBoss = setmetatable(copy(Orc), Boss)
OrcBoss.__index = OrcBoss

local OrcEnemy = setmetatable(copy(Orc), Enemy)
OrcEnemy.__index = OrcEnemy

-- You can construct the different orc types like this:

function Orc.enemy()
	return setmetatable({}, OrcEnemy)
end

function Orc.boss()
	return setmetatable({}, OrcBoss)
end

Orc.enemy()
Orc.boss()

-- or like this:

function OrcEnemy.new()
	return setmetatable({}, OrcEnemy)
end

function OrcBoss.new()
	return setmetatable({}, OrcBoss)
end

OrcEnemy.new()
OrcBoss.new()

--]]
