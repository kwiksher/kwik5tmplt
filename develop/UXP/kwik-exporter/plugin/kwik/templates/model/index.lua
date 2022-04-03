local model = {}
---------------------
--
model.layers = {
	layer_image = {},
	butBlue   = {"button", "animation"}
}
--
model.components =	{
	page = {"common", "navigation", "swipe"}
}
--------------------
-- events
-- a command can be associated with more than one events
--------------------
model.events = 	{
	act_erase = {}, 
	Undo = {},
	Redo = {},
	eventA = "act_erase"
}
--
return model

--[[
	local layers = {
		{name = "layer_image"},
		{name = "butBlue", props = {"button", "animation"}}
	}
	
	{{#props}}
	"{{.}}",
	{{/props}}

	--]]