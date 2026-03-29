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
  previousPageDecoded = nil,
  nameActModel = nil,
  nameActDecoded = nil,
}

local helper = require("Test.renameCopyPaste.helper_renameCopyPaste").new(state)
local deep_copy = helper.deep_copy
local file_exists = helper.file_exists
local resolve_path = helper.resolve_runtime_path
local decode_json_file = helper.decode_json_file
local find_command_name = helper.find_command_name
local prepare_ui_for_run = helper.prepare_action_ui

function M.setup()
  state.pageModel = require("App.renameCopyPaste.page1").model
  state.previousPageModel = require("App.renameCopyPaste.commands.page1.previousPage").model
  state.previousPageDecoded = json.decode(state.previousPageModel)
  state.nameActModel = require("App.renameCopyPaste.commands.page1.nameAct").model
  state.nameActDecoded = json.decode(state.nameActModel)
end

function M.teardown()
end

function M.test_paste_action_from_previousPage()
  state.clipboardData = {
    actions = {deep_copy(state.previousPageDecoded)},
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

function M.xtest_paste_action_from_nameAct()
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

function M.xtest_paste_multiple_actions_previousPage_and_nameAct()
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

function M.xtest_paste_one_actionCommand_into_previousPage()
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

function M.xtest_paste_multiple_actionCommands_into_previousPage()
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
