--
-- utility to archive asset page by page
--
local M = {}

local platform  = system.getInfo("platform")
print(platform)

if not (platform =="win32" or platform =="macos") then
    native.showAlert( "Kwik", "Please select Windows or macOS from View> View As > Custom", { "OK", "Cancel" })
end

local json = require("json")
local lfs = require( "lfs" )

local function PATH (path)
    local ret = path
    if platform =="win32" then
        ret = ret:gsub('/', '\\')
    end
    return ret
end

function isFile(name)
    if type(name)~="string" then return false end
    if not isDir(name) then
        return os.rename(name,name) and true or false
        -- note that the short evaluation is to
        -- return false instead of a possible nil
    end
    return false
end

function isFileOrDir(name)
    if type(name)~="string" then return false end
    return os.rename(name, name) and true or false
end

function isDir(name)
    if type(name)~="string" then return false end
    local cd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cd)
    return is
end

function changeDir(path, name, clean)
    local success = false
    local _path = system.pathForFile(path, system.ResourceDirectory )
    -- Change current working directory
    -- print("changeDir", _path)
    if _path == nil then
        local parent = getPath(path)
        local name = getFileName(path)
        print("   #", parent, name)
        if changeDir(parent) then
            if lfs.mkdir(name) then
                print("   #", path)
                _path = system.pathForFile(path, system.ResourceDirectory )
                print("   #", _path)
                success = lfs.chdir( _path )  --returns true on success
                if ( success ) then
                    if(clean) then
                        os.remove(system.pathForFile(parent .."/"..name, system.ResourceDirectory ))
                        lfs.mkdir(name)
                    end
                    print("   Done", _path)
                end
            else
                print("   #error")
            end
        end
    -- else
    --     local parent = _path:match("(.-)[^%.]+$")
    --     local name = _path:match("^.+/(.+)$")
    --     print(parent, name)
        --
    else
        success = lfs.chdir( _path )  --returns true on success
        if ( success ) then
            if(clean) then
                os.remove(system.pathForFile(parent .."/"..name, system.ResourceDirectory ))
                lfs.mkdir(name)
            end
            print("   Done", _path)
        end
    end
    --
    return success
end

M.changeDir = changeDir

function getPath(str, withSlash)
    -- x = "/home/user/.local/share/app/some_file"
    -- y = "C:\\Program Files\\app\\some_file"
    local folder = str:match("(.*[/\\])")
    if not withSlash then
        folder = folder:sub(1, folder:len()-1)
    end
    return folder
end

function getFileName(str)
   return str:match("^.+/(.+)$")
end

function copyFile(src, dst)
    local cmd = "cp "..src.." "..dst
    if platform =="win32" then
        local cmd = "copy "..src.." "..dst
        cmd = cmd:gsub('/', '\\')
    end
    print(cmd)
    os.execute(cmd)
end
-----------------------
-----------------------
local lustache = require "lustache"
local projectFolder
local sceneName
local tmpltPath = "../tmplt/"
local cmdModel = {}

function M.setProjectFolder(path)
    projectFolder = path
    changeDir(path)
end

local renderMap = {}

local function executeCopy()
    local ext = "command"
    if platform =="win32" then
        ext = "bat"
    end
    --
    local path = system.pathForFile( "copy_lua."..ext..".tmplt", system.ResourceDirectory )
    local file, errorString = io.open( path, "r" )
    local cmd = "copy_lua."..ext
    local cmdFile

    if not file then
        print( "File error: " .. errorString )
    else
        local contents = file:read( "*a" )
        io.close( file )
        local lustache = require "lustache"
        output = lustache:render(contents, cmdModel)

        local path = system.pathForFile(cmd, system.TemporaryDirectory)
        --print(path)
        local file, errorString = io.open( path, "w+" )
        if not file then
            print( "File error: " .. errorString )
        else
            output = string.gsub(output, "\r\n", "\n")
            file:write( output )
            io.close( file )
        end
        if platform =="win32" then
            cmdFile = '"'..path:gsub('/', '\\')..'"'
        else
            cmdFile = path:gsub(' ','\\ ')
        end
    end

    if platform =="win32" then
        print("copy "..cmdFile.." "..system.pathForFile("", system.ResourceDirectory))
        os.execute("copy "..cmdFile.." "..system.pathForFile("..\\", system.ResourceDirectory))
        os.execute("cd "..system.pathForFile("..\\", system.ResourceDirectory) ..' & start cmd /k call '..cmd)
    else
        os.execute("cp "..cmdFile.." "..system.pathForFile("../", system.ResourceDirectory))
        print("cd "..system.pathForFile("../", system.ResourceDirectory) ..'; source '..cmd)
        os.execute("cd "..system.pathForFile("../", system.ResourceDirectory) ..'; source '..cmd)
    end
end

local function createLua(type, path, weight)
    print("ceateLLua", type, path)
    local tmplt = tmpltPath.."commands/base.lua"
    local pathDst = projectFolder.."/commands/"..sceneName .."/"
    local fileName = path:gsub("%.+", "/")
    if type ~= "event" then
        pathDst = projectFolder.."/components/"..sceneName.."/"
        tmplt = tmpltPath.."components/base.lua"
        if type then
            tmplt = tmpltPath.."components/"..type..".lua"
            fileName = fileName .."_"..type
        end
    end
    local contens = renderMap[tmplt]
    if contens == nil then
        local pathTmplt = system.pathForFile( tmplt, system.ResourceDirectory )
        local file, errorString = io.open( pathTmplt, "r" )
        contents = file:read( "*a" )
        renderMap[tmplt] = contens
        io.close( file )
    end
    ---
    local output = lustache:render(contents, {weitht=weight})
    ---
    -- make sure output path
    ---
    pathDst = pathDst..fileName..".lua"
    print("",pathDst)
    local folder = getPath(pathDst)
    local name = getFileName(pathDst)
    print("", folder, name)
    if folder:len() > 0  then
        changeDir(folder)
    end
    ---
    -- write
    ---
    local tmp = system.pathForFile(name, system.TemporaryDirectory)
    file, errorString = io.open( tmp, "w+" )
    if not file then
        print( "File error: " .. errorString )
    else
        output = string.gsub(output, "\r\n", "\n")
        file:write( output )
        io.close( file )
    end
    ---
    -- copy src dst
    ---
    if platform =="win32" then
        tmp = '"'..tmp:gsub('/', '\\')..'"'
    else
        tmp = tmp:gsub(' ','\\ ')
    end
    --
    if platform =="win32" then
        cmdModel[#cmdModel+1] = "copy "..tmp.." "..pathDst
        --os.execute("copy "..tmp.." "..pathDst)
    else
        -- print ("cp "..tmp.." "..pathDst)
        cmdModel[#cmdModel+1]="cp "..tmp.." "..pathDst
        --os.execute("cp "..tmp.." "..pathDst)
    end
end

function M.scaffold (model)
    sceneName = model.name
    print("scaffold")
    local function iterator(parent, layers, path)
        local children = {}
        if type(layers) == "table" then
            local parentPath = path or ""
            for i = 1, #layers do
                local layer = layers[i]
                for name, value in pairs(layer) do
                    --print("", name, value)
                    -- print("", "string")
                    if value.events then
                        -- do nothing
                        for e=1, #value.events  do
                            createLua("event", name.."."..value.events[e])
                        end
                    end
                    if value.types then
                        for k, type in pairs(value.types) do
                            -- print("", type, parentPath .. name)
                            table.insert(children, {type=type, path = parentPath .. name})
                        end
                    end

                    if #value == 0 then
                        createLua(nil, parentPath .. name, i)
                    else
                        createLua(nil, parentPath .. name .. ".index")
                        local ret = iterator(name, value, parentPath .. name .. ".")
                        for j=1, #ret do
                            createLua(ret[j].type, ret[j].path)
                        end
                    end
                    -- print("", value, parent)
                end
            end
        end
        return children
    end
    local ret = iterator(nil, model.layers, nil)
    for j=1, #ret do
        createLua(ret[j].type, ret[j].path)
    end
    --
    executeCopy()
end

-- function string:split( inSplitPattern )

--     local outResults = {}
--     local theStart = 1
--     local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )

--     while theSplitStart do
--         table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
--         theStart = theSplitEnd + 1
--         theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
--     end

--     table.insert( outResults, string.sub( self, theStart ) )
--     return outResults
-- end

function M.generate (folder, alias, index)
    print("generate")
    local events = {}
    local layers = {}
    --
    local path = system.pathForFile(projectFolder.."/commands/"..folder, system.ResourceDirectory )
    local function eventIterator (path, parent)
        print("", path)
        local parentPath = ""
        if parent then
            parentPath = parent .."."
        end
        for file in lfs.dir(path ) do
            if file:find(".lua") ~=nil then
                print( "Found file: " .. file )
                events[#events + 1] = parentPath .. file:gsub(".lua", "")
            else
                if isDir(path.."/"..file) and file:len() > 2 then
                    -- lfs.chdir(path.."/"..file)
                    eventIterator(path.."/"..file, file)
                end
            end
        end
    end
    --
    eventIterator(path)
    --
    print("-------- eventsMap ------- ")
    local eventsMap = {}
    for i=1, #events do
        local e = events[i]
        local splitTable = e:split("\.")
        print(splitTable[1], splitTable[2])
        if #splitTable > 1 then
            local t = eventsMap[splitTable[1]]
            if t == nil then
                t = {}
                eventsMap[splitTable[1]] = t
            end
            t[#t + 1] = splitTable[2]
        end
    end

    ---
    local function readWeight(_path, file)
        local weight = 0
        local path = _path.."/"..file
               -- Open the file handle
        local file, errorString = io.open( path, "r" )

        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- Output lines
            for line in file:lines() do
                if line:find(".weight") then
                    local pos = line:find("=")
                    weight = line:sub(pos + 1)
                   -- print( line, weight )
                    break
                end
            end
            -- Close the file handle
            io.close( file )
        end
        file = nil
        return tonumber(weight) or 0
    end
    ---
    print("----------")
    local types = {"button", "animation"}
    path = system.pathForFile(projectFolder.."/components/"..folder, system.ResourceDirectory )
    print("", path)
    local function layerIterator (path, parent)
        local layerMap = {}
        local children = {}
        --
        for file in lfs.dir(path ) do
            if file:find(".lua") ~=nil then
                print( "---- ", file )
                local layerName = file:gsub(".lua", "")
                if layerName ~= "index" then
                    local layer = layerMap[layerName]
                    if layer == nil then
                        layer = {}
                        layer.weight = readWeight(path, file)
                        layerMap[layerName] = layer
                        layer.events = eventsMap[layerName]
                    end
                    for k, type in pairs (types) do
                        if file:find("_"..type..".lua") then
                            if layer.types == nil then
                                layer.types = {}
                            end
                            layer.types[#layer.types + 1] = type
                        end
                    end
                end
            elseif isDir(path.."/"..file) and file:len() > 2 then
                --lfs.chdir(file)
                local elements = layerIterator(path.."/"..file)
                children[file] = elements
                children.weight = readWeight(path.."/"..file, "index.lua")
            end
        end

        -- layerMap = {
        --     layerName = {types = {},events = {}, weight = 1}),
        -- },
        -- convert to
        -- {layerName = {types = {}, events = {}}, weight=1}
        local temp = {}

        for k, v in pairs(layerMap) do
            local t = {}
            -- print(k, v)
            -- for kk, vv in pairs(v) do print("", kk, vv) end
            t[tostring(k)] = {}
           --types = v[types], events = v[events]
           if v.types then
            t.types = v.types
           end
           if v.events then
            t.events = v.events
           end
           t.weight = v.weight or 0
           temp[#temp + 1] = t
        end

        -- we don't know the directory name in chidren table thougn there is weight from index.lua
        for k, v in pairs(children) do
            -- print("child key", k)
            local t = {}
            if tostring(k) ~= "weight" then
                t[tostring(k)] = v
                temp[#temp +1] = t
                if t.weight == nil then
                    -- set the weight from index.lua
                    t.weight = children.weight
                end
            end
        end

        table.sort(temp,
        function(a,b)
            return (a.weight < b.weight)
        end)

        for index, value in pairs(temp) do
            temp[index].weight = nil
        end

        return temp
    end
    --
    local children = layerIterator(path)
    --table.insert(layers, children)
    layers = children

    -- local dump = {
    --     {background = {}}, {plus = {}}, {
    --         sidepanel = {
    --             {
    --                 topbar = {
    --                     {deleteIcon = {types = {"button"}}},
    --                     {newIcon = {}},
    --                     events = {}
    --                 }
    --             }, {layersList = {events = {"select", "drag"}}}
    --         }
    --     }
    -- }

    -- print(json.encode(dump))

    ---
    -- save it to json
    ---
    local output = json.encode(layers)
    print("#",output)
    --
    local name = alias or folder
    local tmp = system.pathForFile(name..".json", system.TemporaryDirectory)
    file, errorString = io.open( tmp, "w+" )
    if not file then
        print( "File error: " .. errorString )
    else
        output = string.gsub(output, "\r\n", "\n")
        file:write( output )
        io.close( file )
    end
    ---
    -- copy src dst
    ---
    if platform =="win32" then
        tmp = '"'..tmp:gsub('/', '\\')..'"'
    else
        tmp = tmp:gsub(' ','\\ ')
    end

    local pathDst = projectFolder.."/scenes/"..name..".json"

    if platform =="win32" then
        cmdModel[#cmdModel+1] = "copy "..tmp.." "..pathDst
    else
       -- print ("cp "..tmp.." "..pathDst)
        cmdModel[#cmdModel+1]="cp "..tmp.." "..pathDst
    end

    executeCopy()

end

return M