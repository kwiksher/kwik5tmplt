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

local function make_clipboard_data_from_copy(params)
  local data = {
    actions = {},
    actionCommands = {},
    book = "renameCopyPaste",
    page = "page1",
  }

  if params.class == "action" then
    if params.selections then
      for i = 1, #params.models do
        data.actions[#data.actions + 1] = deep_copy(params.models[i])
      end
    else
      data.actions[1] = params.model
    end
  elseif params.class == "actionCommand" then
    for i = 1, #params.commands do
      data.actionCommands[#data.actionCommands + 1] = deep_copy(params.commands[i])
    end
  end

  return data
end

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
  print("TRACE test_paste_action_from_previousPage START")
  state.clipboardData = make_clipboard_data_from_copy({
    class = "action",
    model = state.previousPageModel,
  })
  print("TRACE clipboard.actions count", #state.clipboardData.actions)
  print("TRACE clipboard.actionCommands count", #state.clipboardData.actionCommands)
  print("TRACE clipboard.action[1] type", type(state.clipboardData.actions[1]))

  prepare_ui_for_run()
  print("TRACE currentAction before paste", state.UI.editor.currentAction and state.UI.editor.currentAction.name)
  state.paste.execute({UI = state.UI, class = "action"})
  print("TRACE paste.execute done")

  local luaPath = resolve_path("App/renameCopyPaste/commands/page1/previousPage_copied.lua")
  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/previousPage_copied.json")
  print("TRACE luaPath", luaPath)
  print("TRACE jsonPath", jsonPath)
  print("TRACE lua exists", file_exists(luaPath))
  print("TRACE json exists", file_exists(jsonPath))
  assert_true(file_exists(luaPath))
  assert_true(file_exists(jsonPath))

  package.loaded["App.renameCopyPaste.page1"] = nil
  local pageModel = require("App.renameCopyPaste.page1").model
  local names = find_command_name(pageModel.commands)
  print("TRACE commands count", #pageModel.commands)
  for i = 1, #pageModel.commands do
    print("TRACE command", i, pageModel.commands[i])
  end
  print("TRACE has previousPage", names.previousPage)
  print("TRACE has nameAct", names.nameAct)
  print("TRACE has previousPage_copied", names.previousPage_copied)
  assert_true(names.previousPage)
  assert_true(names.nameAct)
  assert_true(names.previousPage_copied)
  print("TRACE test_paste_action_from_previousPage END")
end

function M.xtest_paste_multiple_actions()
  state.clipboardData = make_clipboard_data_from_copy({
    class = "action",
    selections = true,
    models = {state.previousPageDecoded, state.nameActDecoded},
  })

  prepare_ui_for_run()
  state.paste.execute({UI = state.UI, class = "action"})

  assert_true(file_exists(resolve_path("App/renameCopyPaste/commands/page1/previousPage_copied.lua")))
  assert_true(file_exists(resolve_path("App/renameCopyPaste/commands/page1/nameAct_copied.lua")))
end

function M.xtest_paste_one_actionCommand_into_previousPage()
  state.clipboardData = make_clipboard_data_from_copy({
    class = "actionCommand",
    commands = {state.nameActDecoded.actions[1]},
  })

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
  state.clipboardData = make_clipboard_data_from_copy({
    class = "actionCommand",
    commands = {
      state.nameActDecoded.actions[1],
      state.nameActDecoded.actions[2],
    },
  })

  prepare_ui_for_run()
  state.UI.editor.currentAction = {name = "previousPage"}
  state.paste.execute({UI = state.UI, class = "actionCommand", index = 1})

  local jsonPath = resolve_path("App/renameCopyPaste/models/page1/commands/previousPage.json")
  local decoded = decode_json_file(jsonPath)
  assert_equal("previousPage", decoded.name)
  assert_true(#decoded.actions >= 3)
  assert_equal("page.gotoPage", decoded.actions[1].command)
  assert_equal("variable.editVar", decoded.actions[2].command)
  assert_equal("layer.frontBack", decoded.actions[3].command)
end

return M
