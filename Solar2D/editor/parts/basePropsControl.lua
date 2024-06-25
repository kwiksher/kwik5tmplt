local name = ...
local parent, root = newModule(name)
--
local M = {}
--
local util = require("lib.util")
local yaml = require("server.yaml")
local editorUtil = require("editor.util")

local yamlArray = {}
local yamlHash = {}

function M._yamlValue(k, v, params)
  local value = nil
  local yamltype = nil
  local key = k
  if k == "name" then
    key = "_name"
  elseif k == "target" then
    key = "_target"
  elseif k =="type" then
    key = "_type"
  elseif k =="filename" then
    key = "_file"
  elseif key == "flipSet" then
    key = "flip."..params.flip
    value = yaml.getYaml(v[params.flip])
    yamlHash[key]=true
  end

  if value == nil then
    if type(v) == "table" and v~= NIL then
      if key == "color" then
        value, yamltype = yaml.getYaml({math.floor(v[1]*255), math.floor(v[2]*255), math.floor(v[3]*255), math.ceil(v[4] * 1000) / 1000})
      elseif key == "boundaries" then
        value, yamltype = yaml.getYaml({v.xMin, v.xMax, v.yMin, v.yMax})
     else
        value, yamltype = yaml.getYaml(v)
      end
      if yamltype == "array" then
        yamlArray[key]=true
      else
        yamlHash[key]=true
      end
        -- value = '[a, b, c]'
        -- value = '{ image: blackfire/blackfire, context: ./workspace, tty: true }'
        -- print('{'..value:sub(1, value:len()-1)..'}')
        -- local test = '{ yEnd: 0, yStart: 0, xStart: 0, xEnd: 0 }'
        --test = '{ image: blackfire/blackfire, context: ./workspace, tty: true }'
        -- for k, v in pairs (yaml.eval('{ '..value..' }')) do
        -- for k, v in pairs (yaml.eval(test)) do
          -- print(k, v, type(v))
        -- end
    else
      value = v
    end
  end
  return value
end
--
local keySets = table:mySet{"init", "create", "destroy", "didShow", "didHide", "getProps", "layerProps", "oriAlpha", "align", "dummy", "new", "newInstance"}

function M.filter(k)
    return keySets[k]
end

-- url or _filename or sheetInfo
local function tapListenerURL(event, classProps)
  local assetEditor = require("editor.asset.index")
  local assetTable  = require("editor.asset.assetTable")
  local assetButtons = require("editor.asset.buttons")
  assetTable.lastClass = nil
  assetEditor.controller:show()
  local selectors = require(parent.."selectors")
  selectors.assetsSelector:show()
  selectors.assetsSelector:onClick(true, event.target.class.."s") --videos,audios, sprites..
  assetTable:setClassProps(classProps)
  assetButtons:hide()
  local w, h = classProps:showThumnail(event.target.text,event.target.field.text, event.target.class)
  if event.target.text == "_filename" and classProps.class == "sprite" then
    classProps:updateSheetInfo(w, h)
  end
end

-- layer

local function tapListenerLayer(event)
  local selectors = require(parent.."selectors")
  selectors.componentSelector:onClick(true,  "layerTable", true)
end

-- group
local function tapListenerGroup(event)
  local selectors = require(parent.."selectors")
  selectors.componentSelector:onClick(true,  "groupTable", true)
end

local function tapListenerShape(event)
  print("action tap listener")
  local actionEditor = require("editor.action.index")
  actionEditor:showActionTable(event.actionbox)
end

-- posXY
local pointA        = require("editor.animation.pointA")
local pointB        = require("editor.animation.pointB")
--
local function tapListenerPosXY(event, classProps)
  print("show pointA pointB with popup", event.target.text)
  local objX, objY = event.target, nil
  local name = event.target.text:gsub("_x", "_y")
  for i, v in next,  classProps.objs do
    if name == v.text then
      objY = v
      break
    end
  end

  local bodyA, bodyB, type = classProps.objs[1], classProps.objs[2], classProps.objs[3]
  local UI = classProps.UI
  -- use bodyB
  if objX.text:find("B") ~=nil or (type and type.field.text == "wheel") then
    if objX.field.text:len() > 0 then
      -- pointA:setValue(objX.field.text)
      print("", objX.field.text)
      local obj = UI.sceneGroup[bodyB.field.text]
      -- for k, v in pairs(UI.sceneGroup) do print("", k) end
      local x = objX.field.text:gsub(bodyB.field.text..".x", tostring(obj.x))
      local y = objY.field.text:gsub(bodyB.field.text..".y", tostring(obj.y))
      pointB:setBodyName(bodyB.field.text)
      pointB:setValueXY(x, y)
      pointB:setActiveEntry(objX, objY )
   end
  else -- use bodyA
    if objX.field.text:len() > 0 then
      -- pointA:setValue(objX.field.text)
      print("", objX.field.text)
      local obj = UI.sceneGroup[bodyA.field.text]
      -- for k, v in pairs(UI.sceneGroup) do print("", k) end
      local x = objX.field.text:gsub(bodyA.field.text..".x", tostring(obj.x))
      local y = objY.field.text:gsub(bodyA.field.text..".y", tostring(obj.y))
      pointA:setBodyName(bodyA.field.text)
      pointA:setValueXY(x, y)
      pointA:setActiveEntry(objX, objY )
   end
  end

end

-- color
local colorPicker = require("extlib.colorPicker")
local converter = require("extlib.convertcolor")
---
local function tapListenerColor(event)
  -- print("tap")
  local obj = event.target
  --
  local function pickerListener(r, g, b, a)
    -- print(r, g, b, a)
    -- print("#"..converter.tohex(r)..converter.tohex(g)..converter.tohex(b))
    -- print(converter.tohex(r, g, b))
    local RGB = {math.floor(r*255), math.floor(g*255), math.floor(b*255)}
    if obj.fieldAlpha then
      obj.field.text = M._yamlValue("color", RGB)
      obj.fieldAlpha.text = a
    else
      obj.field.text = M._yamlValue("color", {r, g, b, a})
      -- obj.field.text = M._yamlValue("color", {RGB[1],RGB[2], RGB[3], a})
    end

    obj.targetObject:setFillColor(r, g, b, a)

  end
  local fieldText = obj.field.text
  local value = '[ '..fieldText..' ]'
  value = yaml.eval(value)
  --
  local json = require("json")
  --print(obj.text, json.encode(value))
  if obj.fieldAlpha then
    print(obj.fieldAlpha.text)
    colorPicker.show(pickerListener, tonumber(value[1])/255, tonumber(value[2])/255, tonumber(value[3])/255, tonumber(obj.fieldAlpha.text))
  else
    local alpha = 1.0
    if value[4] then
      alpha  = tonumber(value[4])
    end
    colorPicker.show(pickerListener, tonumber(value[1])/255, tonumber(value[2])/255, tonumber(value[3])/255, alpha)
  end
end
--
local function tapListenerAudio(event)
  print("audio tap listener")
end

-- asset images
--
local imagePicker = require("editor.parts.imagePicker")
---
local function tapListenerImage(event)
  print("tap")
  local obj = event.target
  --
  local function pickerListener(path)
    local fullpath = path or  "App/bookFree/assets/images/canvas/bigCandice.png"
    local splited = editorUtil.split(fullpath, '/')
    local filename = splited[#splited]
    local folder = fullpath:gsub(filename, "")
    obj.field.text = filename
    obj.imageFolder.field.text = folder

   filename = editorUtil.split(filename, ".")

   local is2x4x = util.isFile(filename[1]..display.imageSuffix.."."..filename[2])
   local paint = {type= "image"}
   if is2x4x then
    paint.filename = filename[1]..display.imageSuffix.."."..filename[2]
   else
    paint.filename = fullpath -- "bookOne/images/bigCandice.png",
   end

    obj.targetObject.fill =  paint
  end

  local value = obj.field.text or ""
  imagePicker.show(pickerListener, value, obj.page)

end

local function tapListenerAction(event)
  print("action tap listener")
  local actionEditor = require("editor.action.index")
  actionEditor:showActionTable(event.actionbox)
end


-- used in actionCommandPropsStore:listener
M.CommandForTapSet = table:mySet{"audio", "group", "timer", "variables", "action"}
--
M.handler = {
  url = tapListenerURL,
  layer = tapListenerLayer,
  color = tapListenerColor,
  audio = tapListenerAudio,
  imageFile = tapListenerImage,
  action = tapListenerAction,
  posXY = tapListenerPosXY,
  group = tapListenerGroup,
  boundaries = tapListenerShape
}

return M