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
        value, yamltype = yaml.getYaml({math.floor(v[1]*255), math.floor(v[2]*255), math.floor(v[3]*255), v[4]} )
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

-- url
local function tapListenerURL(event)
  local assetEditor = require(parent.."asset.index")
  assetEditor.controller:show()
  local selectors = require(parent.."selectors")
  selectors.assetsSelector:show()
  selectors.assetsSelector:onClick(true, event.target.class.."s") --videos,audios, sprites..
end

-- layer
--
local function tapListenerLayer(event)
  local selectors = require(parent.."selectors")
  selectors.componentSelector:onClick(true,  "layerTable", true)
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


M.CommandForTapSet = table:mySet{"audio", "group", "timer", "variables", "action"}
--
M.handler = {
  url = tapListenerURL,
  layer = tapListenerLayer,
  color = tapListenerColor,
  audio = tapListenerAudio,
  imageFile = tapListenerImage,
  action = tapListenerAction
}

return M