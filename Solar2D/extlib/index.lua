local original_require = require

-- TODO load once and set it for package.loaded[]

require = function(...)
	local modName = ...
	-- modName = modName:gsub("com.gieson", "extlib.com.gieson")
	-- modName = modName:gsub("Tools", "extlib.com.gieson.Tools")
	-- modName = modName:gsub("TouchHandlerObj", "extlib.com.gieson.TouchHandlerObj")
	modName = modName:gsub("materialui", "extlib.materialui")
  modName = modName:gsub("nanostores.index", "nanostores.nanostores")
	modName = modName:gsub("lib.clean%-stores","extlib.nanostores.lib.clean-stores")
	modName = modName:gsub("lib.create%-derived","extlib.nanostores.lib.create-derived")
	modName = modName:gsub("lib.create%-map","extlib.nanostores.lib.create-map")
	modName = modName:gsub("lib.create%-store","extlib.nanostores.lib.create-store")
	modName = modName:gsub("lib.define%-map","extlib.nanostores.lib.define-map")
	modName = modName:gsub("lib.effect","extlib.nanostores.lib.effect")
	modName = modName:gsub("lib.get%-value","extlib.nanostores.lib.get-value")
	modName = modName:gsub("lib.keep%-active","extlib.nanostores.lib.keep-active")
	modName = modName:gsub("lib.lualib_bundle","extlib.nanostores.lib.lualib_bundle")
	modName = modName:gsub("lib.update","extlib.nanostores.lib.update")
  return original_require(modName)
end

--dmc = require("extlib.dmc_utils")
