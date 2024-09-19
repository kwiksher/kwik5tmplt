local AC = require("commands.kwik.actionCommand")
--
local tfd = require("plugin.tinyfiledialogs")
local isWindows = system.getInfo("platform") == "win32"
local userHomeDocumentsPath = isWindows and "%HOMEPATH%\\Documents\\" or os.getenv("HOME")
local lfs = require( "lfs" )
local util = require("lib.util")

--
local command = function (params)
  local UI    = params.UI

  --print(debug.traceback())
	-- print("initApp")

	-- https://ggcrunchy.github.io/corona-plugin-docs/DOCS/tinyfiledialogs/api.html

	-- https://github.com/DanS2D/Solar2D-TinyFileDialogs-Plugin/releases/tag/1.0

	--

	--local appFolder = "C:\\Users\\ymmtny\\Documents\\GitHub\\kwik5\\sandbox\\Ps\\react-uxp-styles\\Project\\Solar2D\\src\\App"
  -- "/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App"
	local appFolder = params.appFolder or system.pathForFile( "App", system.ResourceDirectory )
  -- print("", appFolder)

	if params.useTinyfiledialogs == nil then
		appFolder = tfd.selectFolderDialog({
			title = "select App folder",
			default_path = path
		})
    -- print("", appFolder)
	end

	local foundFolderType = type(appFolder)
	if (foundFolderType ~= nil and appFolder) then
		local success = lfs.chdir( appFolder ) -- isDir works with current dir
		if success then
			local books = {}
			for file in lfs.dir( appFolder ) do
				if util.isDir(file) then
					-- print("",  "Found file: " .. file )
					-- set them to nanostores
					if util.isFile(file.."/index.lua")  and file:len() > 3 and file ~="kwikEditor" then
            local w = util.readWeight(file.."/index.lua")
            -- print(w)
						table.insert(books, {name = file, path= util.PATH(appFolder.."/"..file), weight = w})
					end
				end
			end
			if #books > 0 then
        local function compare(a,b)
          return a.weight < b.weight
        end
        --
        table.sort(books,compare)

				UI.editor.bookStore:set(books)
			end
			UI.appFolder = appFolder
		end
	end
end
--
local instance = AC.new(command)
return instance
