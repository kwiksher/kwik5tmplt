local current = ...
local parent,  root = newModule(current)
--
local M = {}
local util = require("editor.util")
--
local json = require("json")
local lustache = require "extlib.lustache"
local actionTable = require("editor.action.actionTable")

function M:init(UI, commandMap, selectbox)
  self.commandMap = commandMap
  self.selectbox = selectbox
  self.UI = UI
end
-------
-- I/F
--
M.commandGroupHandler = function(event)
  local UI = M.UI
  print(event.target.muiOptions.name)
  -- local len = string.len("editor.action.actionEditor-")
  local name = event.target.muiOptions.name
  local obj = M.commandMap[name]
  --
  -- TBI
  --   dispatchEvent selectXXX for linking target and xxx componetns
  --

  if obj.model.commandClass then
    UI.scene.app:dispatchEvent {
      name = "editor.action.selectActionCommand",
      UI = UI,
      commandClass = obj.model.commandClass,
      isNew = true
    }
  else
    -- toggle hide/show the children
    -- print("@@@@", name)
    UI.editor.actionEditor:commandViewHandler(name, UI.editor.rootGroup.selectLayer)
  end
end

M.commandHandler = function(event)
  local UI = M.UI
  -- TBI
  --   dispatchEvent selectXXX for linking target and xxx componetns
  --
  -- print(event.name)
  UI.scene.app:dispatchEvent {
    name = "editor.action.selectActionCommand",
    UI = UI,
    commandClass = event.model.commandClass,
    isNew = true
  }
end

function M:useActionEditorProps()
end

function M:setValue(decoded, index, template)
end

function M:toggle()
end

function M:show()
  local UI = self.UI
  self.selectbox:show()
  --
  local scrollView = UI.editor.viewStore.commandView
  for k, v in pairs(self.commandMap) do
    v.alpha = 1
  end
  scrollView.isVisible = true
  --
  if UI.editor.viewStore.actionCommandTable then
    UI.editor.viewStore.actionCommandTable.isVisible = true
    if UI.editor.viewStore.actionCommandButtons.lastVisible then
        UI.editor.viewStore.commandbox:show()
        UI.editor.viewStore.actionCommandPropsTable:show()
        UI.editor.viewStore.actionCommandButtons:show()
    else
      UI.editor.viewStore.actionCommandButtons:show()
    end
  end
--
  if actionTable.newButton then
    actionTable.newButton.alpha = 1
    actionTable.editButton.alpha = 1
  end

end

function M:hide()
  local UI = self.UI
  self.selectbox:hide()
  --
  local scrollView = UI.editor.viewStore.commandView or {}
  if self.commandMap then
    for k, v in pairs(self.commandMap) do
      v.alpha = 0
    end
  end
  scrollView.isVisible = false

  if UI.editor.viewStore.actionButtons then
    UI.editor.viewStore.actionButtons:hide()
  end
  --
  if UI.editor.viewStore.actionCommandTable then
    UI.editor.viewStore.actionCommandTable.isVisible = false
    UI.editor.viewStore.commandbox:hide()
    UI.editor.viewStore.actionCommandPropsTable:hide()
    if cancel then
      UI.editor.viewStore.actionCommandButtons.lastVisible = false
    else
      UI.editor.viewStore.actionCommandButtons.lastVisible = UI.editor.viewStore.actionCommandButtons.isVisible
    end
    UI.editor.viewStore.actionCommandButtons:hide()
  end
  if actionTable.newButton then
    actionTable.newButton.alpha = 0
    actionTable.editButton.alpha = 0
  end
end

function M:reset()
end

function M:redraw()
end

--
-- [{"command":"animation.play","params":{"target":""}}]
--
function M:render(book, page, command, props)
  local dst = "App/"..book.."/commands/"..page .."/"..command..".lua"
  --local dst = layer.."_"..class ..".lua"
  local tmplt =  "editor/template/commands/pageX/actionX.lua"
  util.mkdir("App", book, "commands", page)
  -- util.saveLua(tmplt, dst, {actions = {
  --   {animation = {play = {target="layerOne", sec=1}}},
  --   {animation = {pause = {target="layerTwo", sec=2}}},
  -- }})
  local model ={}
  print(json.encode(props))
  for i=1, #props do
    local entry = {}
    local out = util.split(props[i].command, '.')
    print(unpack(out))
    entry[out[1]] = {}
    entry[out[1]][out[2]]  = props[i].params
    model[i] = entry
  end
  print("###", json.encode(model))
  util.saveLua(tmplt, dst, {actions = model})
  return dst
end

function M:save(book, page, command, model)
  local dst = "App/"..book.."/models/"..page .."/commands/"..command..".json"
  --local dst = layer.."_"..tool..".json"
  util.mkdir("App", book, "models", page, "commands")
  -- local decoded = util.copyTable(model)
  -- table.insert(decoded, entry)
  util.saveJson(dst,model)
  return dst
end

return M