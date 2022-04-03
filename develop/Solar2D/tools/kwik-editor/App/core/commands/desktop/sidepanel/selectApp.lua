local AC = require("commands.kwik.actionCommand")
--
local tfd = require("plugin.tinyfiledialogs")
local isWindows = system.getInfo("platform") == "win32"
local userHomeDocumentsPath = isWindows and "%HOMEPATH%\\Documents\\" or os.getenv("HOME")
local lfs = require( "lfs" )
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	print("commands.sidepanel.selectApp")

	for k, v in pairs(params.event) do print(k, v) end
	-- https://ggcrunchy.github.io/corona-plugin-docs/DOCS/tinyfiledialogs/api.html

	-- https://github.com/DanS2D/Solar2D-TinyFileDialogs-Plugin/releases/tag/1.0

	--

	--local appFolder = "C:\\Users\\ymmtny\\Documents\\GitHub\\kwik5\\sandbox\\Ps\\react-uxp-styles\\Project\\Solar2D\\src\\App"
	local appFolder = "/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App"

	if appFolder == nil then
		appFolder = tfd.selectFolderDialog({
			title = "select App folder",
			default_path = path
		})
	end

	local foundFolderType = type(appFolder)
	if (foundFolderType ~= nil and appFolder) then
		print(appFolder)
		local success = lfs.chdir( appFolder ) -- isDir works with current dir
		if success then
			local books = {}
			for file in lfs.dir( appFolder ) do
				if util.isDir(file) then
					print( "Found file: " .. file )
					-- set them to nanostores
					if file:len() > 3 then
						table.insert(books, {name = file, path= util.PATH(appFolder.."/"..file)})
					end
				end
			end
			if #books > 0 then
				UI.albumStore:set(books)
			end
			UI.appFolder = appFolder
		end
	end
end
--
local instance = AC.new(command)
return instance
