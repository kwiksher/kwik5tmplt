
local M = {}

local root = system.pathForFile("", system.ResouceDirectory)
local projRoot = "/Applications/Corona/SampleCode/"

local projPath, project

M.init = function(path)
	projRoot = path
end


M.execute = function(ProjectName)
	local name = ProjectName:gsub("%.", "/")
	local cmd = 'open -n "corona://open?url=file:///'..projRoot..name..'/'..'&skin=iPadMini"'
	os.execute(cmd)
end

return M