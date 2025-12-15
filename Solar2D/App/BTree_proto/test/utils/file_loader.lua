local M = {}

function M.loadTree(path)
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  if not fullPath then
    return nil, ("Cannot resolve path '%s'"):format(path)
  end
  local file, err = io.open(fullPath, "r")
  if not file then
    return nil, err
  end
  local contents = file:read("*a")
  file:close()
  return contents
end

return M
