local current = ...
local parent, root = newModule(current)
local util = require("editor.util")
--
local model = {
  id = "timer",
  props = {
    {name = "actionName", value = ""},
    {name = "delay",      value = 0},
    {name = "iterations", value = 1},
    {name = "name",       value = ""}
  }
}

local selectbox = require(parent .. "timerTable")
local classProps = require(root .. "parts.classProps")
local actionbox = require(root .. ".parts.actionbox")
-- this set editor.timer.save, cacnel
local buttons = require(parent .. "buttons")

local controller = require("editor.controller.index").new("timer")
local M = require(root .. "baseClassEditor").new(model, controller)

function M:init(UI)
  self.UI = UI
  self.group = display.newGroup()
  -- UI.editor.viewStore = self.group

  selectbox:init()
  classProps:init(UI, self.x + self.width * 1.5, self.y, self.width, self.height)
  classProps.model = model.props
  --
  actionbox:init(UI)
  buttons:init(UI)
  -- --
  controller:init {
    selectbox = selectbox,
    classProps = classProps,
    actionbox = actionbox,
    buttons = buttons
  }
  --
  controller.view = self
  --
  UI.useClassEditorProps = function()
    return controller:useClassEditorProps()
  end
  --
end

function controller:render(book, page, class, name, model)
  local dst = "App/" .. book .. "/" .. page .. "/components/timers/" .. name .. ".lua"
  local tmplt = "editor/template/components/pageX/timers/timer.lua"
  util.mkdir("App", book, page, "components", "timers", class)
  util.saveLua(tmplt, dst, model)
  return dst
end

function controller:save(book, page, class, name, model)
  local dst = "App/" .. book .. "/models/" .. page .. "/timers/" .. class .. "/" .. name .. ".json"
  util.mkdir("App", book, "models", page, "timers", class)
  util.saveJson(dst, model)
  return dst
end

return M