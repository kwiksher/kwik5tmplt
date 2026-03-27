# Handoff: Multi-Paste Work (2026-03-27)

## Goal
Continue unit testing and implementation for multi-selection paste behavior, centered on renameCopyPaste.

## Current Status
- Simulator starts via Scripts/startSolar2D.command but currently crashes early with:
  - `PANIC: fatal Lua error: attempt to index a nil value`
- Current tmp log: Solar2D startup header + panic only.
- Last known successful direct suite run before adding stricter tests:
  - `Test.renameCopyPaste.suite_page1_paste_direct`
  - `8 passed, 0 failed`
- After adding 2 stricter tests (total 10), first test run shows failure marker `F`, and later runs now panic at startup.

## What Was Changed

### In kwik5-sample-books
- Added direct paste controller suite:
  - `Solar2D/Test/renameCopyPaste/suite_page1_paste_direct.lua`
- Enabled this suite in test runner:
  - `Solar2D/Test/index.lua`
- Updated simulator launcher to foreground app using AppleScript:
  - `Scripts/startSolar2D.command`

### In renameCopyPaste fixture content
- Page2 layer model expanded to include same layer names as page1:
  - `Solar2D/App/renameCopyPaste/page2.lua`
- Page2 component layer files were synchronized from page1 then filtered:
  - Removed class files and *_properties.lua files under:
    - `Solar2D/App/renameCopyPaste/components/page2/layers`
- Page2 images folder was created and partially/fully synchronized from page1 depending on run:
  - `Solar2D/App/renameCopyPaste/assets/images/page2`

### In kwik5-plugin
- Note: current working tree does **not** show an active modification to:
  - `kwik/editor/controller/paste.lua`
- Current plugin git status shows only:
  - `?? kwik/editor/controller/paste.lua.bak`
- This means earlier in-session paste.lua edits are not currently reflected in tracked file state.

## Key Files to Inspect First
- `kwik5-sample-books/Solar2D/Test/renameCopyPaste/suite_page1_paste_direct.lua`
- `kwik5-sample-books/Solar2D/Test/index.lua`
- `kwik5-sample-books/Scripts/startSolar2D.command`
- `kwik5-sample-books/Solar2D/App/renameCopyPaste/page2.lua`
- `kwik5-plugin/kwik/editor/controller/paste.lua`
- `kwik5-sample-books/tmp.log`

## Direct Test Cases in suite_page1_paste_direct.lua
Current tests include:
1. Paste layer class from starfish button
2. Paste layer class from title1 pulse
3. Paste audios long/short
4. Paste group groupCat
5. Paste timer nameTimer
6. Paste variable myText
7. One-to-many paste via selections
8. Many-entry layer payload
9. Multi-paste skips unmatched layer names (`ghost`)
10. Multi-paste overwrite without unique rename

## Outstanding Issues
1. Startup panic needs stack trace with file/line.
2. `paste.lua` behavior for multi-entry class paste likely still mismatched with tests (skip unmatched + avoid unique rename for matched entries).
3. Need to confirm page2 image/fileset consistency after filtering operations.

## Resume Plan (Recommended)
1. Get stack trace for startup panic:
   - Run simulator with console output/stderr capture, not just tmp.log.
   - Confirm exact file and line.
2. Fix panic first (blocking all tests).
3. Re-run direct suite only and capture output:
   - Expect 10 tests.
4. If failures remain in tests 9/10, update `kwik/editor/controller/paste.lua`:
   - For multi-entry class paste: process only entries matching destination layers.
   - Do not unique-rename matched entries in that mode.
   - Keep existing unique-rename behavior for non-class/non-layer-class modes.
5. Re-run simulator and verify:
   - `10 passed, 0 failed` in direct suite.
6. Continue integration suite activation in renameCopyPaste `suite_page1_copy_*` files.

## Useful Commands
- Restart simulator:
  - `bash ./Scripts/startSolar2D.command --scale 1x --singleton`
- Quick log check:
  - `tail -n 200 tmp.log`
- Repo statuses:
  - `cd /Users/ymmtny/Documents/GitHub/kwik5-sample-books && git status --short`
  - `cd /Users/ymmtny/Documents/GitHub/kwik5-plugin && git status --short`

## Working Tree Snapshot (at handoff)
- kwik5-sample-books:
  - `M Solar2D/Test/index.lua`
  - `M Solar2D/Test/renameCopyPaste/suite_page1_paste_direct.lua`
  - `M Solar2D/main.lua`
- kwik5-plugin:
  - `?? kwik/editor/controller/paste.lua.bak`

## Notes
- `Scripts/startSolar2D.command` now includes app activation:
  - tries `Corona Simulator`, then `Solar2D Simulator`.
- If panic persists with no stack in tmp.log, capture from direct console run and store into a dedicated debug log file for next handoff.
