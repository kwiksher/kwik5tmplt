local AC = require("commands.kwik.actionCommand")
local codes = require("commands.editor.models.printStack")
--
local command = function (params)
	local e     = params.event
	local UI    = params.UI
	print(debug.traceback())

	--_AC.Canvas:eraseCanvas(UI.canvas)
	--
	--_AC.Canvas:brushColor(UI.canvas, unpack(funcs[{{index}}].canvas.color))
	--_AC.Canvas:brushColor(UI.canvas, unpack(codes[2].canvas.color))
end
--[[
	for directly callint this command
	local cmd = require("commands.menu.printStack")
	local params = {UI = UI, event = nil}
	cmd.execute(params)
--]]
--
local instance = AC.new(command)
return instance
