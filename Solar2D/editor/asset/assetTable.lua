local name = ...
local parent,root = newModule(name)
local mui = require("materialui.mui")
local muiIcon    = require("components.mui.icon").new()


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
M.x = display.contentCenterX + 480/2
M.y = 22

local propsTable = require(root .. "parts.propsTable")
local selectors = require(root.."parts.selectors")

local layerTableCommands = require("editor.parts.layerTableCommands")
local contextButtons = require("editor.parts.buttons")

local posX = display.contentCenterX*0.75

function M.mouseHandler(event)
  if event.isSecondaryButtonDown and event.target.isSelected then
    -- print("@@@@selected")
    contextButtons.openEditorObj.text = "open folder"
    contextButtons:showContextMenu(posX, event.y,  {type="asset", folder=M.class.."s", selections=M.selections})
  else
    -- print("@@@@not selected")
  end
  return true
end

-- target.class will be audio.long or audio.short or audio.sync
-- a sync audio can be multiple

local handlerMap = {
  audios = {class = "audio", modify = require("editor.audio.audioTable").commandHandler, icons = {"addAudio", "trash"}, tool="selectAudio"},
  videos = {class = "video", modify = require("editor.parts.layerTableCommands").commandHandlerClass, icons={"repVideo", "trash"}, tool="selectTool"},

}
local _marginX, _marginY = -16, 38
local lastTool, lastClass
---
function M:iconsHandler(event, class, tool)
    if self.group.isVisible == false then
      self:show()
      selectors.assetsSelector:show()
    else
      -- self:hide()
      -- selectors.assetsSelector:hide()
      -- selectors.componentSelector:show()
      -- selectors.componentSelector:onClick(true,  "layerTable")

      -- should we use BT with "add component"?
      -- for k, v in pairs(event.target.muiOptions) do print(k, v) end
      local name = event.target.muiOptions.name
      if self.selection then
        if lastTool then
          -- print("#########", lastTool)
          self.UI.scene.app:dispatchEvent {
            name = "editor.selector."..lastTool,
            UI = self.UI,
            class = lastClass,
            hide = true
          }
          end
        lastTool = tool
        lastClass = class
        --
        self.UI.scene.app:dispatchEvent {
          name = "editor.selector."..tool,
          UI = self.UI,
          class = class,
          asset = self.selection.asset,
          isNew = (name ~= "trash-icon"),
          isDelete = (name == "trash-icon")
        }
        --
        if  #self.selections > 0 then
          for i = 1, #self.selections do
            if self.selections[i].rect then
              self.selections[i].rect:setFillColor(0.8)
            end
          end
        end
      else
        native.showAlert( "alert", "Please select a file")
      end
    end
  end

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

local function getHandler(assetName)
  -- print(assetName)
  local ret =  handlerMap[assetName]
  if ret then
    return ret.modify
  else
    return {}
  end
end

local function getClass(assetName)
  return handlerMap[assetName].class
end

local function getClassModule(class)
  return handlerMap[class.."s"].tool
end

function M:touchHandler(target, event)
  if event.phase == "began" or event.phase == "moved" then  return end
  layerTableCommands.clearSelections(self, "asset")
  -- print(self.controlDown)
  if self:isAltDown() then
    if layerTableCommands.showLayerProps(self, target) then
      print("---- none for assets ------?")
    end
  elseif self:isControlDown() then -- mutli selections
    print("multi", #self.selections)
    layerTableCommands.multiSelections(self, target)
  else
    if layerTableCommands.singleSelection(self, target) then
      -- TBI
      -- dispatchEvent to the class editor
      if class then
        -- print(getClassModule(class))
        self.UI.scene.app:dispatchEvent {
          name = "editor.selector."..getClassModule(class),
          UI = self.UI,
          class = class,
          asset = self.selection.asset,
          isUpdatingAsset = true,
          isNew = (name ~= "trash-icon"),
          isDelete = (name == "trash-icon")
        }
      end
    end
  end
  return true
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
      option.width = 180
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
            option.width = 100
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
    -- self.group.isVisible = true
  end

  UI.editor.assetStore:listen(
    function(foo, fooValue)
      self:destroy()
      --print("assetStore", #fooValue)
      self.selection = nil
      self.selections = {}
      self.objs = {}
      self.commandHandler = getHandler(fooValue.class)
      if fooValue == nil then
        --render({}, 0, 0)
      else
        local asset = handlerMap[fooValue.class]
        if asset then
          self.class = asset.class
          --
          -- local anchor = self.rootGroup[self.anchorName].rect
          render(fooValue.decoded or {}, asset.class )
          if asset then
            self:createIcons(asset.icons, asset.class, asset.tool)
          end
        else
          print("Error asset map", fooValue.class)
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
--
return M
