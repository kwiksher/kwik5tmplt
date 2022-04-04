local original_require = require

require = function(...)
	local modName = ...
	modName = modName:gsub("com.gieson", "com.gieson")
	modName = modName:gsub("Tools", "extlib.com.gieson.Tools")
	modName = modName:gsub("TouchHandlerObj", "extlib.com.gieson.TouchHandlerObj")
	return original_require(modName)
end