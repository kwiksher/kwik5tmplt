local current = ...
local parent,  root = newModule(current)
--
local M = {}
local util = require("editor.util")
--
local json = require("json")
local lustache = require "extlib.lustache"
local toolbar = require(root.."parts.toolbar")

function M:init(viewGroup)
  self.viewGroup = viewGroup or {}
  --
  if self.id == "physics" then
    -- print ("@@@@@", self.id)
   -- print(debug.traceback())
  end
  if viewGroup then
    -- self.selectbox      = viewGroup.selectbox
    -- self.classProps    = viewGroup.classProps
    -- self.actionbox = viewGroup.actionbox
    -- self.buttons       = viewGroup.buttons
    for k, v in pairs(viewGroup) do
      -- if self.id == "physics" then
      --   print(k)
      -- end
      self[k] = v
    end
  else
    self.viewGroup.selectbox = self.selectbox
    self.viewGroup.classProps = self.classProps
    self.viewGroup.actionbox = self.actionbox
    self.viewGroup.buttons = self.buttons
  end
  if self.buttons then
    self.buttons.useClassEditorProps = function() return self:useClassEditorProps() end
  end
  if self.selectbox then
    self.selectbox.useClassEditorProps = function() return self:useClassEditorProps() end
    self.selectbox.classEditorHandler = function(decoded, index)
      print("classEditorHandler", index)
      self:reset()
      self:setValue(decoded, index)
      self:redraw()
    end
  end
end
  -------
-- I/F
--
function M:useClassEditorProps()
  print(debug.traceback())
  print("editor.controller.useClassEditorProps", self.id)
  local props = { properties = {}}
  if self.selectbox.selectedObj and self.selectbox.selectedText then
    props = {
      name = self.selectbox.selectedObj.text, -- UI.editor.currentLayer,
      class= self.selectbox.selectedText.text:lower(),
      actionName = nil,
      -- the following vales come from read()
      page = self.page,
      layer = self.layer,
      isNew = self.isNew,
      --class = self.class,
      index = self.selectbox.selectedIndex,
      properties = {}
    }
  end
  --
  if self.classProps == nil then
    print("#Error self.classProps is nil for ", self.tool)
    return nil
  end
  local properties = self.classProps:getValue()
  for i, entry in next, properties do
    -- print("", properties[i].name, type(properties[i].value))
    props.properties[entry.name] = entry.value
  end
  --
  props.actionName =self.actionbox.value
  return props
end

-- this handler should be called from selectbox to set one of animtations user selected
function M:setValue(decoded, index, template)
  print("editro.controller.setValue", self.id)
  if decoded == nil then return end
  if not template then
    -- print(json.encode(decoded[index]))
    self.selectbox:setValue(decoded, index)  -- "linear 1", "rotation 1" ...
    self.classProps:setValue(decoded[index].properties)
    local props = {}
    local actions = decoded[index].actions
    if actions then
      for k, v in pairs (actions) do
        props[#props+1] = {name=k, value=""}
      end
      self.actionbox:setValue(props)
      -- self.actionbox:initActiveProp(actions)
    end
  else
    self.selectbox:setTemplate(decoded)  -- "linear 1", "rotation 1" ...
    self.classProps:setValue(decoded.properties)
    local props = {}
    if decoded.actions then
      for k, v in pairs (decoded.actions) do
        props[#props+1] = {name=k, value=""}
      end
      self.actionbox:setValue(props)
      -- self.actionbox:initActiveProp(props)

    else
      print("no actionbox")
      --self.actionbox:hide()
      self.actionbox:setValue()
      -- print(#self.actionbox.objs)
    end
  end
end

function M:getValue()
   -- this will return decoded
  return self.selectbox.decoded, self.selectbox.selectedIndex
end

function M:toggle()
  for k, v in pairs(self.viewGroup) do
    if v.toogle then
      v:toggle()
    else
      print("missing toogle in", k)
    end
  end
  self.view.group.isVisible = not self.view.group.isVisible
end

function M:show()
  print(self.id)
  if self.viewGroup then
    for k, v in pairs(self.viewGroup) do
      v:show()
    end
    self.view.group.isVisible = true
  end
end

function M:hide()
  if self.viewGroup then
    for k, v in pairs(self.viewGroup) do
      v:hide()
    end
    self.view.group.isVisible = false
  end
end

function M:reset()
  local UI = self.view.UI
  self.view:didHide(UI)
  self.view:destroy(UI)
  self.view:init(UI)
end

function M:redraw()
  local UI = self.view.UI
  self.view:create(UI)
  self.view:didShow(UI)
  self:show()

  --

end

function M:renderAssets(book, page, layer, classFolder, class, model)
  local UI = self.view.UI
  local dst = "App/"..book .."/assets/model.lua"
  local tmplt =  "editor/template/assets/model.lua"

  util.mkdir("App", book, "assets")
  --
  -- update UI.editor.assets
  --
  if model then -- audio is a classFolder not a class
    UI.editor.assets = require("editor.asset.index").controller:updateAsset(book, page, layer, classFolder, class, model,  UI.editor.assets )
  end
  util.saveLua(tmplt, dst, UI.editor.assets )
  return dst
end

local Shapes = table:mySet{"new_image", "new_rectangle", "new_ellipse", "new_text"}
local Animations = table:mySet{"linear", "blink", "bounce", "pulse", "rotation", "shake"}

M.Shapes = Shapes

function M:render(book, page, layer, classFolder, class, model)
  print("render()", book, page, layer, classFolder, class, model.name)

  local tmplt =  "editor/template/components/pageX/"..classFolder.."/layer_"..class ..".lua"
  local dst = "App/"..book.."/components/"..page.."/layers/"..layer.."_"..class ..".lua"

  if classFolder == "physics" then
    tmplt =  "editor/template/components/pageX/"..classFolder.."/"..class ..".lua"
    if class == "joint" then
      dst = "App/"..book.."/components/"..page.."/joints/"..model.name ..".lua"
    end
  elseif (model.name and model.name:len()>0) and class then
    if model.name ~= "nil" then
      dst = "App/"..book.."/components/"..page.."/layers/"..layer.."_"..(model.name) ..".lua"
    end
  elseif Shapes[class] then
    dst = "App/"..book .."/components/"..page.."/layers/"..layer..".lua"
    --local dst = layer.."_"..class ..".lua"
    tmplt =  "editor/template/components/pageX/"..classFolder.."/"..class..".lua"
  elseif class then
    --local dst = layer.."_"..class ..".lua"
    if Animations[class] then
      tmplt =  "editor/template/components/pageX/"..classFolder.."/layer_animation.lua"
    end
  else
    dst = "App/"..book .."/components/"..page.."/layers/"..layer..".lua"
    --local dst = layer.."_"..class ..".lua"
    tmplt =  "editor/template/components/pageX/"..classFolder.."/layer_text.lua"
    -- if tool == "animation" then
    --   tmplt =  "editor/template/components/pageX/animations/layer_animation.lua"
    -- end
  end
  util.mkdir("App", book, "components", page, "layers")
  util.mkdir("App", book, "components", page, "joints")
  util.saveLua(tmplt, dst, model)
  return dst
end

function M:renderPage(book, page, class, name, model)
  print("", book, page, class, name, #model.properties)
  local dst, tmplt
  if class=="page" then
    if name == "physics" then
      dst = "App/"..book.."/components/"..page.."/"..class.."/"..name ..".lua"
      tmplt =  "editor/template/components/pageX/"..class.."/"..name ..".lua"
    else
      dst = "App/"..book.."/components/"..page.."/"..class.."/"..name ..".lua"
      tmplt =  "editor/template/components/pageX/"..class.."/"..class ..".lua"
    end
    util.mkdir("App", book, "components", page, class)
  else
    dst = "App/"..book.."/components/"..page.."/"..class.."s/"..name ..".lua"
    tmplt =  "editor/template/components/pageX/"..class.."/"..class ..".lua"
    util.mkdir("App", book, "components", page, class.."s")
  end
  util.saveLua(tmplt, dst, model)
  return dst
end


function M:save(book, page, layer, class, model, entry)
  local dst
  if class == nil then
    dst = "App/"..book.."/models/"..page .."/"..layer..".json"
  else
    dst = "App/"..book.."/models/"..page .."/"..layer.."_"..class..".json"
  end
  --local dst = layer.."_"..tool..".json"
  util.mkdir("App", book, "models", page)
  local decoded = util.copyTable(model)
  if entry then
    table.insert(decoded, entry)
  end
  util.saveJson(dst, decoded)
  return dst
end

function M:renderIndex(book, page,  model)
  return util.renderIndex(book, page, model)
end

function M:saveIndex(book, page, layer, class, model)
  return util.saveIndex(book, page, layer, class, model)
end


function M:read(book, page, layer,class, isNew)
  self.page = page
  self.layer = layer
  self.isNew = isNew
  self.class = class
  local decoded,  pos, msg
  if isNew then
    local path = "editor.template.components.pageX."..self.tool..".defaults."..class
    -- print(path)
    local data = require(path)
    -- for k, v in pairs(data) do
    --   print("@", k, v)
    -- end
    decoded = {data}
  elseif layer then
    local layerName = layer or "index"
    --local path      = page .."/"..layerName.."_"..self.tool..".json"
    local path      = system.pathForFile( "App/"..book.."/models/"..page .."/"..layerName.."_"..self.tool..".json", system.ResourceDirectory)

    decoded,  pos, msg = json.decodeFile( path )
    if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
    else
        print( "File successfully decoded!" )
    end
  else
    -- for audios, groups, timers, variables
    -- util.decode()

  end
  return decoded
end

function M:loadLua(book, page, layer,class, isNew)
  self.page = page
  self.layer = layer
  self.isNew = isNew
  self.class = class
  local decoded,  pos, msg
  if isNew then
    local path = "editor.template.components.pageX."..self.tool..".defaults."..class
    print(path)
    local data = require(path)
    decoded = {data}
    return decoded
  elseif layer then
    local layerName = layer or "index"
    --local path      = page .."/"..layerName.."_"..self.tool..".json"
    local path      =  "App."..book..".components."..page ..".layers."..layerName.."_"..class
    local mod = require(path)
    return {mod}
  else
    -- for audios, groups, timers, variables
    -- util.decode()
    return nil
  end
end

function M:mergeAsset(model, asset)
   print(json.encode(asset))
   model.properties["file"] = asset.name
   model.properties["folder"] = asset.path

   local tmps = util.split(asset.name, ".")
   model.properties["_name"] = tmps[1]

  return model
end

function M:updateAsset(text, asset)
  -- print("@@@@@", asset.path, asset.name, #asset.links)
  if self.classProps and self.classProps.objs then
    for i, v in next, self.classProps.objs do
      if v.text == self.classProps.activeProp then
        v.field.text = asset.name
        return
      end
    end
  end
end

function M:load(book, page, layer, class, isNew, asset)
  -- print("read", page, layer, class, isNew)
  -- the values are used in useClassEdtiorProps()
  self.page = page
  self.layer = layer
  self.isNew = isNew
  self.class = class

  if isNew then
    local decoded = self:read(book, page, layer, class, isNew)
    self:reset()
    local model = decoded[1]
    if asset then
      model = self:mergeAsset(decoded[1], asset)
    end
    self:setValue(model, nil, true)
    -- print(json.encode(model))
    self:redraw()
  elseif layer then

    -- this comes from clicking layerTable.class
    local layerName = layer or "index"
    --local path      = page .."/"..layerName.."_"..self.tool..".json"
    local path      = system.pathForFile( "App/"..book.."/models/"..page .."/"..layerName.."_"..self.tool..".json", system.ResourceDirectory)
    -- print("", path)
    if self.lastSelection ~= path then
      self.lastSelection   = path
      local decoded = self:loadLua(book, page, layer, class, isNew)
      self:reset()
      self:setValue(decoded, 1)
      self:redraw()
    else
      self.view.isNew = true
      toolbar:toogleToolMap()
    end
  else
    -- for audios, groups, timers, variables
    -- local cmd = self:command()
    -- cmd(params)
  end
end

-- this command for audios, groups, timers, variables. See util.decode only works for them, not working for layer's json
function M:command()
  local instance = require("commands.kwik.baseCommand").new(
  function (params)
    local UI    = params.UI
    local name =  params[params.class] or ""
    local book = params.book or UI.editor.currentBook
    local page  = params.page or UI.page

    for k, v in pairs(params) do print(k, v) end
    if params.hide then
      -- print("@@@@@")
      self:hide()
      return
    end
    ---
    local asset = params.asset
    if params.isUpdatingAsset then
      -- print("@@@@@", asset.path, asset.name, #asset.links)
      if self.classProps and self.classProps.objs then
        for i, v in next, self.classProps.objs do
          if v.text == self.classProps.activeProp then
            v.field.text = asset.name
            return
          end
        end
      end
    else
      -- read from models/{class}/{name}.json
      local decoded = util.decode(book, page, params.class, name, {subclass = params.subclass, isNew = params.isNew, isDelete = params.isDelete}) -- this reads models/xx.json
      --
      print("From selectors")
      self.classProps:didHide(UI)
      self.classProps:destroy(UI)
      self.classProps:init(UI)
      local model = decoded
      if params.isNew and params.asset then
        model = self:mergeAsset(decoded, params.asset)
      end
      if model and model.properties == nil then
          print("#Warning properties are missing", params.class, name)
      else
        print(json.encode(model.properties))
      end
      self.classProps:setValue(model)
      self.classProps.isNew = params.isNew
      --
      self.classProps:create(UI)
      self.classProps:didShow(UI)
      --
      -- self:show()
      self.classProps:show()
      self.actionbox:show()
      self.buttons:show()
      --
      UI.editor.editPropsLabel = name
      --
      UI.editor.rootGroup:dispatchEvent{name="labelStore",
        currentBook= UI.editor.currentBook,
        currentPage= UI.page,
        currentLayer = name}
    end
  end)
  return instance
end


M.new = function(tool)
  local instance = {tool = tool, id=tool}
  instance.classProps    = require(root.."parts.classProps")
  instance.actionbox     = require(root..".parts.actionbox")
  instance.selectbox     = require(root.."parts.selectbox")
  instance.buttons       = require(root.."parts.buttons")

	return setmetatable(instance, {__index=M})
end

return M