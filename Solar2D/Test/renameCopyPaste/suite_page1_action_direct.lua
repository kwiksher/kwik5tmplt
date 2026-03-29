local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local json = require("json")

local state = {
  paste = require("editor.action.controller.paste"),
  UI = nil,
  pageModel = nil,
  previousPageModel = nil,
  nameActModel = nil,
  nameActDecoded = nil,
}

local function deep_copy(v)
  if type(v) ~= "table" then
    return v
  end
  local out = {}
  for k, val in pairs(v) do
    out[k] = deep_copy(val)
  end
  return out
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function read_text(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local text = f:read("*a")
  f:close()
  return text
end

local function resolve_path(relPath)
  if system and system.pathForFile then
    local abs = system.pathForFile(relPath, system.ResourceDirectory)
    if abs then
      return abs
    end
  end
  return relPath
end

local function decode_json_file(path)
  local text = read_text(path)
  assert_not_nil(text, "json file missing: " .. tostring(path))
  local decoded = json.decode(text)
  assert_not_nil(decoded, "json decode failed: " .. tostring(path))
  return decoded
end

local function make_ui()
  return {
    book = "renameCopyPaste",
    page = "page1",
    scene = {
      model = deep_copy(state.pageModel)
    },
    editor = {
      currentBook = "renameCopyPaste",
      currentAction = {name = "previousPage"},
      selections = {},
      clipboard = {
        read = function()
          return state.clipboardData
        end
      }
    }
  }
end

local function find_command_name(commands)
  local names = {}
  for i = 1, #commands do
    names[commands[i]] = true
  end
  return names
end

local function prepare_ui_for_run()
  state.UI = make_ui()
end

function M.setup()
  state.pageModel = require("App.renameCopyPaste.page1").model
  state.previousPageModel = require("App.renameCopyPaste.commands.page1.previousPage").model
  state.nameActModel = require("App.renameCopyPaste.commands.page1.nameAct").model
  state.nameActDecoded = json.decode(state.nameActModel)
end

function M.teardown()
end

function M.test_paste_action_from_previousPage()
  state.clipboardData = {
    actions = {state.previousPageModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  prepare_ui_for_run()
  state.paste.execute({UI = state.UI, class = "action"})

  local luaPath = resolve_path("App/renameCopyPaste/commands/page1/previousPage_copied.lua")
  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/previousPage_copied.json")
  assert_true(file_exists(luaPath))
  assert_true(file_exists(jsonPath))

  local pageModel = require("App.renameCopyPaste.page1").model
  local names = find_command_name(pageModel.commands)
  assert_true(names.previousPage)
  assert_true(names.nameAct)
end

function M.test_paste_action_from_nameAct()
  state.clipboardData = {
    actions = {state.nameActModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  prepare_ui_for_run()
  state.paste.execute({UI = state.UI, class = "action"})

  local luaPath = resolve_path("App/renameCopyPaste/commands/page1/nameAct_copied.lua")
  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/nameAct_copied.json")
  assert_true(file_exists(luaPath))
  assert_true(file_exists(jsonPath))
end

function M.test_paste_multiple_actions_previousPage_and_nameAct()
  state.clipboardData = {
    actions = {state.previousPageModel, state.nameActModel},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  prepare_ui_for_run()
  state.paste.execute({UI = state.UI, class = "action"})

  assert_true(file_exists(resolve_path("App/renameCopyPaste/commands/page1/previousPage_copied.lua")))
  assert_true(file_exists(resolve_path("App/renameCopyPaste/commands/page1/nameAct_copied.lua")))
end

function M.test_paste_one_actionCommand_into_previousPage()
  state.clipboardData = {
    actions = {},
    actionCommands = {deep_copy(state.nameActDecoded.actions[1])},
    book = "renameCopyPaste",
    page = "page1",
  }

  prepare_ui_for_run()
  state.UI.editor.currentAction = {name = "previousPage"}
  state.paste.execute({UI = state.UI, class = "actionCommand", index = 1})

  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/previousPage.json")
  local decoded = decode_json_file(jsonPath)
  assert_equal("previousPage", decoded.name)
  assert_true(#decoded.actions >= 2)
  assert_equal("page.gotoPage", decoded.actions[1].command)
  assert_equal("variable.editVar", decoded.actions[2].command)
end

function M.test_paste_multiple_actionCommands_into_previousPage()
  state.clipboardData = {
    actions = {},
    actionCommands = {
      deep_copy(state.nameActDecoded.actions[1]),
      {
        command = "action.play",
        params = {
          actionName = "nameAct"
        }
      }
    },
    book = "renameCopyPaste",
    page = "page1",
  }

  prepare_ui_for_run()
  state.UI.editor.currentAction = {name = "previousPage"}
  state.paste.execute({UI = state.UI, class = "actionCommand", index = 1})

  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/previousPage.json")
  local decoded = decode_json_file(jsonPath)
  assert_equal("previousPage", decoded.name)
  assert_true(#decoded.actions >= 3)
  assert_equal("page.gotoPage", decoded.actions[1].command)
  assert_equal("variable.editVar", decoded.actions[2].command)
  assert_equal("action.play", decoded.actions[3].command)
end

return M
