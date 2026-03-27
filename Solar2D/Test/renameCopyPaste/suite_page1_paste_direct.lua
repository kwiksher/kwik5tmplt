local M = require("Test.base_suite").new({
  book = "renameCopyPaste",
  page = "page1",
  component = "iconOnly"
})

local PAGE2_BASELINE = {
  components = {
    layers = {
      {background = {}},
      {name = {}},
      {cat = {}},
      {cat_face1 = {}},
      {title_base = {}},
      {title3 = {}},
      {title2 = {}},
      {title1 = {}},
      {starfish = {}},
      {fish = {}},
    },
    audios = {},
    groups = {},
    timers = {},
    variables = {},
    joints = {},
    page = {}
  },
  commands = {}
}

local state = {
  calls = nil,
  page2 = nil,
  page2LuaRelPath = nil,
  page2LuaPath = nil,
  page2LuaMTimeBefore = nil,
  page2LuaSizeBefore = nil,
  paste = nil,
}

local helper = require("Test.renameCopyPaste.helper_renameCopyPaste").new(state, PAGE2_BASELINE)

local make_components = helper.make_components
local resolve_runtime_path = helper.resolve_runtime_path
local file_exists = helper.file_exists
local assert_layer_files_generated = helper.assert_layer_files_generated
local assert_page2_lua_written = helper.assert_page2_lua_written
local assert_page2_updated = helper.assert_page2_updated
local assert_page2_index_layer_class = helper.assert_page2_index_layer_class
local debug_print_paste_outputs = helper.debug_print_paste_outputs

function M.setup()
  helper.setup_stubs()
end

function M.teardown()
  helper.teardown_stubs()
end

function M.xtest_direct_paste_layer_class_from_starfish_button()
  local alreadyGenerated = pcall(assert_layer_files_generated, "starfish", "button")
  if alreadyGenerated then
    print("SKIP xtest_direct_paste_layer_class_from_starfish_button: generated files already exist")
    return
  end

  state.UI.editor.currentLayer = {layer = "starfish"}
  state.UI.editor.selections = {{layer = "starfish"}}

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_layer_class_from_starfish_button")

  assert_layer_files_generated("starfish", "button")
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_paste_layer_class_from_starfish_button", "\"button\"")
end

function M.xtest_direct_paste_layer_class_from_title1_pulse()
  state.clipboard = {
    class = "pulse",
    page = "page1",
    components = make_components({
      layers = {
        {name = "title1", class = "pulse", properties = {target = "title1"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_layer_class_from_title1_pulse")

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("background", state.calls.updateIndexModel[1].layer)
  assert_equal("pulse", state.calls.updateIndexModel[1].class)
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_paste_layer_class_from_title1_pulse")
  assert_page2_index_layer_class("background", "pulse", true)
  assert_page2_index_layer_class("title1", "pulse", false)
end

function M.xtest_direct_paste_audios_long_and_short()
  state.clipboard = {
    class = "audio",
    page = "page1",
    components = make_components({
      audios = {
        {name = "long"},
        {name = "short"}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_audios_long_and_short")

  assert_equal(2, #state.calls.render)
  assert_equal("long", state.calls.render[1].name)
  assert_equal("short", state.calls.render[2].name)
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_paste_audios_long_and_short")
  assert_page2_index_layer_class("starfish", "button", false)
end

function M.xtest_direct_paste_group_groupCat()
  state.clipboard = {
    class = "group",
    type = "group",
    page = "page1",
    components = make_components({
      groups = {
        {name = "groupCat", type = "group"}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_group_groupCat")

  assert_equal(1, #state.page2.components.groups)
  assert_not_nil(state.page2.components.groups[1].groupCat)
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_paste_group_groupCat")
  assert_page2_index_layer_class("starfish", "button", false)
end

function M.xtest_direct_paste_timer_nameTimer()
  state.clipboard = {
    class = "timer",
    page = "page1",
    components = make_components({
      timers = {
        {name = "nameTimer"}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_timer_nameTimer")

  assert_equal(1, #state.page2.components.timers)
  assert_equal("nameTimer", state.page2.components.timers[1])
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_paste_timer_nameTimer")
  assert_page2_index_layer_class("starfish", "button", false)
end

function M.xtest_direct_paste_variable_myText()
  state.clipboard = {
    class = "variable",
    page = "page1",
    components = make_components({
      variables = {
        {name = "myText"}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_variable_myText")

  assert_equal(1, #state.page2.components.variables)
  assert_equal("myText", state.page2.components.variables[1])
  assert_page2_lua_written()
  assert_page2_updated(true, "test_direct_paste_variable_myText")
  assert_page2_index_layer_class("starfish", "button", false)
end

function M.xtest_direct_paste_one_to_many_for_selected_layers()
  state.UI.editor.selections = {
    {layer = "cat"},
    {layer = "fish"}
  }

  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_one_to_many_for_selected_layers")

  assert_equal(2, #state.calls.updateIndexModel)
  assert_equal("cat", state.calls.updateIndexModel[1].layer)
  assert_equal("fish", state.calls.updateIndexModel[2].layer)
  assert_layer_files_generated("cat", "button")
  assert_layer_files_generated("fish", "button")
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_paste_one_to_many_for_selected_layers")
  assert_page2_index_layer_class("cat", "button", true)
  assert_page2_index_layer_class("fish", "button", true)
end

function M.xtest_direct_paste_many_entries_keeps_payload_from_page1_components()
  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}},
        {name = "title1", class = "button", properties = {target = "title1"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_paste_many_entries_keeps_payload_from_page1_components")

  assert_equal(2, #state.calls.updateIndexModel)
  assert_equal("starfish", state.calls.updateIndexModel[1].layer)
  assert_equal("title1", state.calls.updateIndexModel[2].layer)
  assert_layer_files_generated("starfish", "button")
  assert_layer_files_generated("title1", "button")
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_paste_many_entries_keeps_payload_from_page1_components")
  assert_page2_index_layer_class("starfish", "button", true)
  assert_page2_index_layer_class("title1", "button", true)
end

function M.xtest_direct_multi_paste_skips_unmatched_layer_names()
  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}},
        {name = "ghost", class = "button", properties = {target = "ghost"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_multi_paste_skips_unmatched_layer_names")

  assert_equal(1, #state.calls.updateIndexModel)
  assert_equal("starfish", state.calls.updateIndexModel[1].layer)
  assert_equal("starfish", state.calls.render[1].name)

  local starfishPath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/starfish_button.lua")
  local ghostPath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/ghost_button.lua")
  assert_true(file_exists(starfishPath))
  assert_true(not file_exists(ghostPath))
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_multi_paste_skips_unmatched_layer_names")
  assert_page2_index_layer_class("starfish", "button", true)
  assert_page2_index_layer_class("title1", "button", false)
end

function M.xtest_direct_multi_paste_overwrites_without_unique_rename()
  state.clipboard = {
    class = "button",
    page = "page1",
    components = make_components({
      layers = {
        {name = "starfish", class = "button", properties = {target = "starfish"}},
        {name = "title1", class = "button", properties = {target = "title1"}}
      }
    })
  }

  state.paste.execute({UI = state.UI})
  debug_print_paste_outputs("test_direct_multi_paste_overwrites_without_unique_rename")

  assert_equal(2, #state.calls.render)
  assert_equal("starfish", state.calls.render[1].name)
  assert_equal("title1", state.calls.render[2].name)
  assert_layer_files_generated("starfish", "button")
  assert_layer_files_generated("title1", "button")

  local uniquePath = resolve_runtime_path("App/renameCopyPaste/components/page2/layers/starfish_1_button.lua")
  assert_true(not file_exists(uniquePath))
  assert_page2_lua_written()
  assert_page2_updated(false, "test_direct_multi_paste_overwrites_without_unique_rename")
  assert_page2_index_layer_class("starfish", "button", true)
  assert_page2_index_layer_class("title1", "button", true)
end

return M