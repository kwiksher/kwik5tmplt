local name = ...
local parent,  root = newModule(name)

local Props = {
  name = "layer",
  anchorName = "selectLayer",
  id = "layer"
}

local M = require(root.."baseTable").new(Props)
local commands = require(parent.."layerTableCommands")

--
function M:create(UI)
  self.commandHandlerClass = commands.commandHandlerClass
  self.commandHandler = commands.commandHandler

  if self.rootGroup then return end
  self:initScene(UI)
  self.selections = {}

  self.UI = UI

  local function parse(model)
    local name = nil
    local children = nil
    local class = nil
    for k, v in pairs(model) do
      name = k
      -- print(k, v)
      if type(v) == "table" then
          for _name, value in pairs(v) do
            -- print("", _name)
            if not (_name == "weight" or _name == "class" or _name == "events") then
              local layer = {}
              layer[_name] = value
              if children == nil then
                children = {}
              end
              -- children[#children + 1] = layer
              children[_name] = value
              --print("", _name, class, #children)
            end
            if _name == "class" then
              if type (value) == "table" then
                class = value
              else
                print("Warning", value, "is not in table {} ")
              end
            end
          end
      end
    end
    -- print(name, class, children)
    return name, class, children
  end

  local function render(models, xIndex, yIndex, parentObj)
    local count = 0
    local objs = {}
    local marginX, marginY = 74, 20
    local option = self.option

    for i = 1, #models do
      local model = models[i]
      local entry = {}

      count = count + 1
      entry.name, entry.class, entry.children = parse(model)

      option.text = entry.name
      -- option.x = self.rootGroup.selectLayer.x + self.rootGroup.selectLayer.width/2 + xIndex *5
      --option.y = self.rootGroup.selectLayer.contentBounds.yMax + 10 + option.height * count
      option.x = self.rootGroup.selectLayer.x + marginX + xIndex * 5
      option.y = self.rootGroup.selectLayer.y + marginY + option.height * (count -1 + yIndex)
      -- print("#", count, yIndex, entry.name)
      option.width = 100

      local obj = self.newText(option)
      obj.layer = entry.name
      obj.class = ""
      obj.parentObj = parentObj
      -- obj.touch = commandHandler
      -- obj:addEventListener("touch", obj)

      obj.touch = function(eventObj, event)
        print("touch")
        self:commandHandler(eventObj, event)
        UI.editor.selections = self.selections
        return true
      end
      obj:addEventListener("touch", obj)
      obj:addEventListener("mouse", commands.mouseHandler)

      local rect = display.newRect(obj.x, obj.y, obj.width + 10, option.height)
      rect:setFillColor(0.8 + xIndex*0.05)
      rect.strokeWidth = 1
      self.group:insert(rect)
      self.group:insert(obj)

      obj.rect = rect
      objs[#objs + 1] = obj
      -- class
      if entry.class then
        obj.classEntries = {}
        local last_x = 10
        for k = 1, #entry.class do
          -- print("#", entry.class[k])
          option.text = entry.class[k]
          -- option.text = entry.class[k]:sub(1, 5)
          -- option.x = self.rootGroup.selectLayer.x + self.rootGroup.selectLayer.width/2 + last_x
          -- option.y = self.rootGroup.selectLayer.contentBounds.yMax + 10 + option.height * (count-1)
          option.x = self.rootGroup.selectLayer.x + marginX + last_x
          option.y = self.rootGroup.selectLayer.y + marginY + option.height * (count - 1)
          option.width = nil
          local classObj = self.newText(option)
          --classObj.width = 50
          classObj.layer = entry.name
          classObj.class = entry.class[k]
          classObj.touch = function(eventObj, event)
            self:commandHandlerClass(eventObj,event)
            return true
          end
          classObj:addEventListener("touch", classObj)
          classObj:addEventListener("mouse", commands.mouseHandler)

          last_x = classObj.width + 2

          local rect = display.newRect(classObj.x, classObj.y, classObj.width + 10, option.height)
          rect:setFillColor(0.8)
          self.group:insert(rect)
          self.group:insert(classObj)

          classObj.rect = rect
          objs[#objs + 1] = classObj
          obj.classEntries[k] = classObj
        end
      end
      --
      -- children
      if entry.children and  #entry.children > 0 then
        -- print(#entry.children)
        local childEntries, c = render(entry.children, xIndex + 1, count + yIndex, obj )
        count = count  + c
        obj.text = "(" ..obj.layer..")"
        --
        for k, v in pairs(childEntries) do
          objs[#objs + 1] = v
        end
        obj.childEntries = childEntries
      end
      --
    end
    self.rootGroup:insert(self.group)
    self.rootGroup.layerTable = self.group
    return objs, count
  end

  UI.editor.layerStore:listen(
    function(foo, fooValue)
      -- for k, v in pairs(foo) do print(k, v) end
      M:destroy()
      -- print("layerStore", #fooValue)
      M.selection = nil
      M.selections = {}
      -- local json = require("json")
      -- print(json.encode(fooValue))
      M.objs = render(fooValue, 0, 0)
    end
  )
end

local function findClassObj(obj, class)
  if obj.classEntries then
    --look for class
    for j=1, #obj.classEntries do
      local classObj = obj.classEntries[j]
      if classObj.class == class then
        -- create or create class
        classObj.index = j
        return classObj
      end
    end
  end
  return nil
end

--
-- args = {"book", "page", "groupOne", "groupTwo", "chidLayer"}
--  so findObj(layerTable.objs, args, 3) to start the function
--
local function findObj(objs, args, nLevel)
  local layer = args[nLevel]
  local argsLength = #args
  for i=1, #objs do
    local obj = objs[i]
    -- print(i, obj.layer, layer, nLevel, argsLength)
    if argsLength == nLevel then
      if obj.layer == layer then
        -- print("matched", i, obj.layer)
        return obj
      end
    elseif obj.layer == layer then
      obj = findObj(obj.childEntries, args, nLevel+1)
      if obj then
        return obj
      end
    end
  end
  return nil
end

M.findClassObj = findClassObj
M.findObj = findObj
--
--
return M
