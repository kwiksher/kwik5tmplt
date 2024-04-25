local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--local models = require("editor.model").layerTools

local propsButtons = require("editor.parts.propsButtons")
local propsTable = require("editor.parts.propsTable")

--
-- see index.lua
--   self.editorTools['editor.parts.toolbar-'..layerTools[i].icon] = module
--   self.editorTools['editor.baseTable-'..v.id] = module
--
-- local classMap = {
--      animation = "animation",
--      linear    = "animation",
--      blink     = "animation",
--      bounce    = "animation",
--      pulse     = "animation",
--      rotation  = "animation",
--      shake     = "animation",
--      switch    = "animation",
--   -- filter    = "animation",
--   -- path      = "animation",
--   --
--     button     = "interaction",
--     drag       = "interaction",
--     canvas     = "interaction",
--   --
--     spritesheet   = "replacement",
--     particles     = "replacement",
--     syncTextAudio = "replacement",
--     video         = "replacement"
-- }
--
local lastTool
--
local command = function (params)
	local UI    = params.UI
 	print("selectTool", UI.editor:getClassModule(params.class), params.class, params.isNew )
  if params.asset then
    -- links is an array of layer names
    for k, v in pairs(params.asset) do print(k, v) end
  end

  -- print(debug.traceback())

  local tool = UI.editor:getClassModule(params.class)
  if tool then
    if lastTool then
      lastTool.controller:hide()
    end
    lastTool= tool

    if params.hide then
      tool.controller:hide()
      return
    end

    if params.toogle then
      tool.controller:toggle()
      tool.group:toFront()
    else
      propsButtons:hide()
      propsTable:hide()

      -- read json
      tool:show()
      UI.editor.currentTool = tool
      if params.layer then -- this measn user clicks one of class, anim, button, drag ...
        UI.editor.currentLayer = params.layer
      end
      -- should we use name of UI.editor.editor.currentClass?
      -- timer.performWithDelay( 1000, function()
      if params.isUpdatingAsset then
        tool.controller:updateAsset(params.classField, params.asset)
      else
        tool.controller:load(UI.editor.currentBook, UI.page, UI.editor.currentLayer, params.class, params.isNew, params.asset)
      end
      -- end)
    end
  else
    print("tool is not found for", params.class)
    -- let's use a generic one, should getClassModule return a generic tool?
    --
  end

  -- if params.class then
  --     -- for Animations, Interactions, Replacements ...
  --     for i=1, #models do
  --       local model = models[i]
  --       if "editor.view.toolbar-"..model.icon == params.class then
  --         UI.editor.currentToolbar = params.class
  --         --toolbar:toogleToolMap()
  --         break
  --       end
  --     end
  --     print("", "currentToolbar", UI.editor.currentToolbar)
  -- end

  --
    --
    --[[
    if UI.editor.currentTool =="Animations" then
        UI.currentPanel = UI.animationPanel
        UI.animationStore:set(fooValue)
        UI.actionEditor:hide()
        UI.actionPanel:destroy()
        UI.layerInstancePanel:destroy()
      else
        --local buttons = require(parent.."buttons")
      end
    --]]


--[[
		local path = UI.currentPage.path .."/commands/"..UI.currentAction.name..".json"
		print(path)

		UI.editPropsLabel = UI.currentAction.name
		local decoded, pos, msg = json.decodeFile( path )
		if not decoded then
			print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
			print( "File successfully decoded!" )
			UI.actionCommandStore:set(decoded)
			UI.actionEditor:show()
		end
	--]]
  --
  --

end
--
local instance = AC.new(command)
return instance
