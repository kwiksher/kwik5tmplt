require "extlib.lunatest"
local M = {
  run = function (props)
    print("============ lunatest =============")

    -- lunatest.suite("test.keyboard.suite_page1", props)
    -- lunatest.suite("test.lingualSample.suite_lingual_page2", props)

    lunatest.suite("test.book.suite_assets", props)
    -- lunatest.suite("test.book.suite_page1_page_props", props)
    -- lunatest.suite("test.book.suite_page1_interactions", props)
    -- lunatest.suite("test.book.suite_page1_replacements", props)
    -- lunatest.suite("test.book.suite_page1_animation", props)
    -- lunatest.suite("test.book.suite_page1_button", props)
    -- lunatest.suite("test.book.suite_page1_action", props)
    -- lunatest.suite("test.book.suite_page1_group", props)
    -- lunatest.suite("test.book.suite_page1_audio", props)
    -- lunatest.suite("test.book.suite_page1_select_copy_paste", props)

    -- lunatest.suite("test.book.suite_page2_sync2audio", props)
    -- lunatest.suite("test.book.suite_page3_drag", props)
    -- lunatest.suite("test.book.suite_page3_button", props)
    -- lunatest.suite("test.book.suite_page3_animation", props)

    -- lunatest.suite("test.book.suite_page4_physics", props)

    --lunatest.suite("test.book.suite_page12_canvas", props)

    -- lunatest.suite("test.book.suite_new_book_page_layer", props)
    -- lunatest.suite("test.book.suite_new_shape_transform", props)
    -- lunatest.suite("test.book.suite_new_timer", props)
    -- lunatest.suite("test.book.suite_new_variable", props)
    -- lunatest.suite("test.book.suite_page1_new_audio_timer_group_variable", props)

    -- lunatest.suite("test.bookTest.bookTest_importer", props)

    -- lunatest.suite("test.book.suite_controller")
    --  lunatest.suite("test.book.suite_open_vscode", props)
    -- lunatest.suite("test.book.suite_page3_audio", props)
    -- lunatest.suite("test.book.suite_selector", props)
    -- lunatest.suite("test.book.suite_settings", props)
    --lunatest.suite("test.book.suite_page_portrait", props)
    -- lunatest.suite("test.book.suite_page_portrait_replacements", props)
    -- lunatest.suite("test.book.suite_misc", props)

    lunatest.run()
    print("============   end    =============")
  end
}

return M