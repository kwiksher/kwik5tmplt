local AC = require("commands.kwik.actionCommand")
-- local App = require("controller.Application")
--
local command = function (params)
	local UI    = params.UI
  print("action.copy", params.action, params.class)
  print(#params.selections)

  local clipboard = UI.editor.clipboard
  clipboard.actions = {}
  clipboard.actionCommands = {}
  --
  if params.class == "action" then
    if params.selections then
      for i, v in next, UI.editor.selections do
        print(i, v.action)
        local model = require("App."..UI.book..".commands."..UI.page.."."..v.action).model
        decoded, pos, msg = json.decode( model )
        if not decoded then
          print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
          break
        end
        clipboard.actions[#clipboard.actions + 1] = decoded
      end
    else
      local model = require("App."..UI.book..".commands."..UI.page.."."..params.action).model
      decoded, pos, msg = json.decode( model )
      if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
        return
      end
      clipboard.actions[#clipboard.actions + 1] = decoded
    end
  elseif params.class == "actionCommand" then
  end
--
end
--
local instance = AC.new(command)
return instance
