local AC = require("commands.kwik.actionCommand")
--
local command = function (params)
	local UI    = params.UI
  print("action.paste at", params.action, params.class)

  local clipboard = UI.editor.clipboard:read()
  -- clipboard.actions = {}
  -- clipboard.actionCommands = {}
  -- --
  if params.class == "action" then
    if params.selections then
    else
      if #clipboard.actions > 1 then
      else
      end
    end
  elseif params.class =="actoinCommand" then
  end
--
end
--
local instance = AC.new(command)
return instance
