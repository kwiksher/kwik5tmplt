local M = {}
local json = require("json")
local lfs = require( "lfs" )

function M.isDir(name)
	if type(name)~="string" then return false end
	local cd = lfs.currentdir()
	local is = lfs.chdir(name) and true or false
	lfs.chdir(cd)
	return is
end

M.split = function(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
        table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

local COPY, MOVE, MKDIR
if system.getInfo("platform") =="win32" then
   COPY = function(src, dst)
      local _src = src:gsub('/', '\\')
      local _dst = dst:gsub('/', '\\')
      os.execute('xcopy "'..src..'" "'..dst..'" /s/e/i/Y')
   end
   MOVE = function (name)
    local _src = src:gsub('/', '\\')
    local _dst = dst:gsub('/', '\\')
    os.execute('xcopy "'..src..'" "'..dst..'" /s/q')
   end
   MKDIR = function(path)
    local _path = pathc:gsub('/', '\\')
    os.execute('mkdir "'.._path..'"')
   end

elseif system.getInfo("platform") == "macos" then
   COPY = function(src, dst)
      local _src = src:gsub(' ','\\ ')
      local _dst = dst:gsub(' ','\\ ')
      os.execute('cp -Rf '.._src..' '.._dst)
   end
   MOVE = function (src, dst)
    local _src = src:gsub(' ','\\ ')
    local _dst = dst:gsub(' ','\\ ')
    os.execute('mv '.._src..' '.._dst)
  end
   MKDIR = function(path)
    local _path= path:gsub(' ','\\ ')
     os.execute('mkdir -p '.._path)
   end
end

M.install = function(asset, src, dst)
  if asset.folders == nil then
    COPY(src.."/"..asset.path, dst.."/"..asset.path)
  else
    for i, folder in next, asset.folders do
      COPY(src.."/"..asset.path.."/"..folder, dst.."/"..asset.path.."/"..folder)
    end
  end
end

M.backup = function(asset, dst)
  --
  if not M.isDir(dst) then
    MKDIR(dst)
  end
  --
  if asset.folders == nil then
    COPY(asset.path, dst.."/"..asset.path)
  else
    for i, folder in next, asset.folders do
      COPY(asset.path.."/"..folder, dst.."/"..asset.path.."/"..folder)
    end
  end
end

return M

