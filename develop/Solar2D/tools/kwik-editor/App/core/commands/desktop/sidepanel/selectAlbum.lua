local AC = require("commands.kwik.actionCommand")
local json = require("json")
local util = require("lib.util")
--
local command = function (params)
	local e     = params.event
	local UI    = e.UI
	local currentAlbum = UI.currentAlbum
	print(currentAlbum.path)
	local path = currentAlbum.path .."/models"

	local success = lfs.chdir( path ) -- isDir works with current dir
	if success then
		local pages = {}
		for file in lfs.dir( path ) do
			if util.isDir(file) then
				print( "Found file: " .. file )
				-- set them to nanostores
				if file:len() > 3 and file ~='assets' then
					table.insert(pages, {name = file, path= util.PATH(path.."/"..file)})
				end
			end
		end
		if #pages > 0 then
			UI.pageStore:set(pages)
		end
	end

	-- assets

	local decoded, pos, msg = json.decodeFile( currentAlbum.path.."/models/assets/index.json" )

	if not decoded then
		print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
	else
		UI.assetStore:set(decoded)
	end
--


end
--
local instance = AC.new(command)
return instance
