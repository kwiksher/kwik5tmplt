require "lunatest"
--

local M = {
  --
  run = function (props)
    --print("============ lunatest =============")
    lunatest.reset_suites()
    --
    local UI = props.UI
    --
    local function set (book, page)
      local pagePart = page:match("([^_]+)")
      if book == UI.book and pagePart == UI.page then
        -- print("  ", "test."..book..".suite_"..page)
        lunatest.suite("Test."..book..".suite_"..page, props)
      end
    end

    set("book", "landscape")

    -- set("renameCopyPaste", "page1_rename")
    -- set("renameCopyPaste", "page1_edit_delete")
    -- set("renameCopyPaste", "page1_copy_paste")
    set("renameCopyPaste", "page1_action_direct")
    -- set("renameCopyPaste", "page1_paste_direct")
    -- set("renameCopyPaste", "page1_action")
    -- set("renameCopyPaste", "page1_copy_paste_in_page2")
    -- set("renameCopyPaste", "page1_copy_many")
    -- set("renameCopyPaste", "page1_copy_many_paste_in_page2")
    -- set("renameCopyPaste", "page1_copy_one_paste_many")
    -- set("renameCopyPaste", "page1_copy_one_paste_many_in_page2")

    set("animation", "linear")
    set("animation", "filter")
    set("animation", "path_animation")

    set("asset", "audio")
    set("asset", "particles")
    set("asset", "sync")
    set("asset", "video")


    set("interaction", "canvas")
    set("interaction", "swipe")
    set("interaction", "spin")
    set("interaction", "shake")
    set("interaction", "pinch")
    set("interaction", "parallax")


    set("keyboard", "page1")
    set("lingualSample", "lingual_page2")

    set("replacement","counter")
    set("replacement","dynamicText")
    set("replacement","inputText")
    set("replacement","map")
    set("replacement","mask")
    set("replacement","multiplier")
    set("replacement","particles")
    set("replacement","sprite")
    set("replacement","sync")
    set("replacement","text")
    set("replacement","textinput")
    set("replacement","vector")
    set("replacement","video_png")
    set("replacement","video")
    set("replacement","web")

    set("page", "audio")
    set("page", "group")
    set("page", "timer")
    set("page", "variable")

    set("layer", "lang")
    set("layer", "properties")

    -- lunatest.suite("test.book.suite_assets", props)

    -- set("kwikTheCat", "page1_action")
    -- set("kwikTheCat", "page1_animation")
    -- set("kwikTheCat", "page1_audio")
    -- set("kwikTheCat", "page1_button")
    -- set("kwikTheCat", "page1_group")
    -- set("kwikTheCat", "page1_interactions")
    -- set("kwikTheCat", "page1_page_props")
    -- set("kwikTheCat", "page1_replacements")
    -- set("kwikTheCat", "page1_select_copy_paste")

    -- set("kwikTheCat", "page2_sync2audio")
    -- set("kwikTheCat", "page3_drag")
    -- set("kwikTheCat", "page3_button")
    -- set("kwikTheCat", "page3_animation")
    -- set("kwikTheCat", "page4_physics")
    -- set("kwikTheCat", "page12_canvas")

    -- set("snowMan", "page2")


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
    -- print("============   end    =============")
  end
}

return M