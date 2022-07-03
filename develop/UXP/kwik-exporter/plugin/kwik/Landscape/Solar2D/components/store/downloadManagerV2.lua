local M = {}
local filename = "assets.json"
local onDownloadComplete
local onDownloadError
local assetsTableLocal = {}

local zip = require( "plugin.zip" )
local json = require("json")
local queue = require("extlib.queue")
local lfs = require( "lfs" )

local spinner = require("extlib.spinner").new("download server")
local model = require("components.store.model")

local URL       = model.URL

function isDir(name)
    if type(name)~="string" then return false end
    local cd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cd)
    return is
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

local jsonFile = function(filename, baseDir )
   local path = system.pathForFile(filename, baseDir )
   local contents
   local file = io.open( path, "r" )
   if file then
      contents = file:read("*a")
      io.close(file)
      file = nil
   end
   return contents
end

local function fetchAssetJson(aQueue)
    local item = aQueue:poll()
    if item then
        local deferred = Deferred()
        local selectedPurchase = item.name
        local version = item.version
        print("fetchAssetJson", selectedPurchase, version)
        --
        local url = URL ..selectedPurchase..version.."/"..filename
        print("---------------------")
        print(url)
        print("---------------------")
        local params    = {}
        params.progress = true
        network.download( url.."?a="..os.time(), "GET",
            function(event)
                if ( event.isError ) then
                    print( "Network error - assets.json failed" )
                    deferred:reject()
                elseif ( event.phase == "ended" ) then
                    if ( math.floor(event.status/100) > 3 ) then
                        print( "Network error - assets.json failed", event.status )
                        deferred:reject()
                        --NOTE: 404 errors (file not found) is actually a successful return,
                        --though you did not get a file, so trap for that
                    else
                        local options = {
                            jsonFile = event.response.filename,
                            jsonBaseDir = event.response.baseDirectory,
                        }
                        local downloadables, assets = M.saveDownloadablesAsJson(options, selectedPurchase,version)
                        deferred:resolve()
                    end
                end
            end,
            params, selectedPurchase..version..".json", system.TemporaryDirectory )
        return deferred:promise()
    else
        return  nil
    end
end

M.fetchAssets = function ()
    local aQueue = queue.new()
    -- also load bookName..version.."_assets.json" to assetsTableLocal[page] 
    for k, v in pairs(model.episodes) do
        print(k, v)
        if #v.versions > 0 then
            for i=1, #v.versions do
                local _version = v.versions[i]
                aQueue:offer({name=v.name, version=_version})
                local path = system.pathForFile(v.name.._version.."_assets.json", system.ApplicationSupportDirectory )
                if isFile(path) then
                    assetsTableLocal[v.name.._version] = json.decode(jsonFile(v.name.._version.."_assets.json", system.ApplicationSupportDirectory))
                else
                    assetsTableLocal[v.name.._version] = {}
                end
            end
        else
            aQueue:offer({name=v.name, version=""})
            local path = system.pathForFile(v.name.."_assets.json", system.ApplicationSupportDirectory )
            if isFile(path) then
                print(path)
                assetsTableLocal[v.name] = json.decode(jsonFile(v.name.."_assets.json", system.ApplicationSupportDirectory))
            else
                assetsTableLocal[v.name] = {}
            end
        end
    end
    local promise = fetchAssetJson(aQueue)
    if promise == nil then
        print("fetchAssets is finished")
    else
        promise:done(function()
            fetchAssetJson(aQueue)
        end)
        promise:fail(function(error)
            print("error in fetchAssets")
        end)
        promise:always(function()
        end)
    end
end

function M.startDownload(selectedPurchase, version)
    local deferred = Deferred()
    local downloadables = M.getDownloadables(selectedPurchase, version)
    print("------ V2 -------")
    local _version = version or ""
    --local assetsRemote = json.decode(jsonFile("downloadable_"..selectedPurchase.._version..".json", system.TemporaryDirectory))
    print("downloadable_"..selectedPurchase.._version..".json")
    if #downloadables > 0 then
        local aQueue = queue.new()
        print("startDownload #downlodables", #downloadables)
        local size = 0
        for i=1, #downloadables do
            print(downloadables[i].size)
            aQueue:offer(downloadables[i])
            size = size + downloadables[i].size
        end
        spinner:show()
        spinner.startTime = os.time()
        spinner.numOfDownloadables = #downloadables
        spinner.book = selectedPurchase .." ".._version
        spinner.bookSize = math.floor(size/(1024*1024))
        spinner.size = 0
        M.processDownload(aQueue, deferred, selectedPurchase, version)
    else
        timer.performWithDelay(10, function()
            deferred:resolve()
        end)
    end
    return deferred:promise()
end

function updatedAssetsTable(item, bookName, version)
    print("updateAssetsTable", filename, bookName, version)
    local page = "p"..item.page -- filename:sub(bookName:len()+1, filename:find("_")-1)
    local type = item.type -- filename:sub(filename:find("_") + 1, filename:find(".zip")-1)
    print("--- updateAssetsTable ---", page, type)

    local _version = version or ""
    
    if assetsTableLocal[bookName.._version][page] == nil then
        assetsTableLocal[bookName.._version][page] = {}
    end
    
    if assetsTableLocal[bookName.._version][page][type] == nil then
        assetsTableLocal[bookName.._version][page][type] = {}
    end

    assetsTableLocal[bookName.._version][page][type].date = item.date
    ---
    local path = system.pathForFile(bookName..version.."_assets.json", system.ApplicationSupportDirectory )
    local file = io.open( path, "w+" )
    jsonString = json.encode(assetsTableLocal[bookName.._version])
    contents = file:write( jsonString )
    io.close( file )
end

function isUpdated(book,page, type, date)
    if assetsTableLocal[book][page] and assetsTableLocal[book][page][type]then
        return not (assetsTableLocal[book][page][type].date == date)
    end
    return true
end

M.saveDownloadablesAsJson = function(options, name, version)
    print("saveDownloadablesAsJson")
    local _version = version or ""
    local downloadables = {}
    local assets = json.decode(jsonFile(options.jsonFile, options.jsonBaseDir))
    for i=1, #assets do
        for k, v in pairs(assets[i]) do
            if type (v) == "table" then
                if isUpdated(name.._version, "p"..i, k, v.date) then
                    table.insert(downloadables, {page=i, type=k, size = v.size, date= v.date})
                end
            end
        end
    end
    local path = system.pathForFile( "downloadable_"..name.._version..".json", system.TemporaryDirectory )
    local fh, reason = io.open( path, "w+" )
    if fh then
        fh:write( json.encode(downloadables) )
        io.close( fh )
    else
        print("error",reason)
    end
    return downloadables, assets
end

M.getDownloadables = function(name, version)
    local _version = version or ""
    local path = system.pathForFile("downloadable_"..name.._version..".json", system.TemporaryDirectory)
    print("getDownloadables", path)
    if isFile(path) then
        return json.decode(jsonFile("downloadable_"..name.._version..".json", system.TemporaryDirectory))
    else
        print("getDownloadables None")
        return {}
    end
end

local function setFlagDownloaded(episode, version)
    local _ver = version or ""
    local path = system.pathForFile( model.episodes[episode].dir.._ver, system.ApplicationSupportDirectory )
    -- io.open opens a file at path. returns nil if no file found
    local fh, reason = io.open( path.."/copyright.txt", "w+" )
    if fh then
        fh:write( "downloaded\n" )
        io.close( fh )
    else
        print("error",reason)
    end
end

M.processDownload = function (downloadables, deferred, selectedPurchase, version)
    local promise = M.downloadAsset(downloadables, selectedPurchase,version)
    if promise == nil then
        setFlagDownloaded(selectedPurchase,version)
        onDownloadComplete(selectedPurchase, version)
        deferred:resolve()
        spinner:remove()
    else
        promise:done(function(item)
            print(item.type)
            spinner.size = spinner.size + math.floor(item.size/(1024*1024))
            spinner:updateText()
            updatedAssetsTable(item, selectedPurchase, version)
            M.processDownload(downloadables, deferred, selectedPurchase, version)
        end)
        promise:fail(function(error)
            onDownloadError(selectedPurchase, version)
            deferred:reject()
            spinner:remove()
            print("Download Finished", error)
        end)
        promise:always(function()
        end)
    end
end

local function moveAsset(bookProject, version, item)
    local const = {
        audios = "audios", 
        read2me = "audios",
        videos  = "videos",
        PNGs    = "videos",
        sprites = "sprites",
        particles = "particles",
        WWW       = "WWW",
        thumbnails = "thumbnails",
        images     = "images/p"..item.page,
        shared     = "images"
    }

    local path = system.pathForFile("", system.ApplicationSupportDirectory)
    local success = lfs.chdir( path )  --returns true on success    
    if ( success ) then
        if not isFileOrDir(bookProject..version) then
            lfs.mkdir( bookProject..version)
        else
            --os.remove(system.pathForFile(bookServerFolder .."/"..bookProject, system.ResourceDirectory ))
            --lfs.mkdir( bookProject)
        end
        path = system.pathForFile(bookProject..version, system.ApplicationSupportDirectory)
        lfs.chdir(path) 
        print(item.type, const[item.type])
        if item.type ~= "images" then
            if not isFileOrDir(const[item.type]) then
                -- print("############ ", item.type)
                lfs.mkdir(const[item.type])
            end
        else
            if not isFileOrDir("images") then
                -- print("############ images ")
                lfs.mkdir("images")
            end
            path = system.pathForFile(bookProject..version.."/images", system.ApplicationSupportDirectory)
            lfs.chdir(path) 
            if not isFileOrDir("p"..item.page) then
                lfs.mkdir("p"..item.page)
            end
        end
    end

    -- assets sub dir
    print("moveAsset", const[item.type], bookProject..version.."/"..const[item.type])
    print(system.pathForFile(const[item.type], system.ApplicationSupportDirectory), 
        system.pathForFile(bookProject..version.."/"..const[item.type], system.ApplicationSupportDirectory))
    --[[
        os.rename(system.pathForFile(const[item.type], system.ApplicationSupportDirectory), 
            system.pathForFile(bookProject.."/"..const[item.type], system.ApplicationSupportDirectory))
    ]]
 
    local function _move(src, dst)
        local assetFolder = system.pathForFile(src, system.ApplicationSupportDirectory )
        for file in lfs.dir(assetFolder) do
            -- "file" is the current file or directory name
            print( "Found file: " .. file )
            if isDir(file) then
                if file:len() > 3 then
                    _move(file, dst.."/"..file)
                end
            else
                local _src = system.pathForFile(src.."/"..file, system.ApplicationSupportDirectory)
                local _dst  = system.pathForFile(dst .."/"..src.."/"..file, system.ApplicationSupportDirectory)
                local result, error = os.rename(_src, _dst)
                if error and  error:find("File exists") then
                    os.remove(_dst)
                    result, error = os.rename(_src, _dst)
                end
            end
        end
    end
    _move(const[item.type], bookProject..version)

end


local function uncompressZip(filename, baseDir, bookProj, version, item, deferred)
    print("uncompressZip", filename, baseDir)
    local options = {
        zipFile = filename,
        zipBaseDir = baseDir,
        dstBaseDir = system.ApplicationSupportDirectory,
        listener = function(event) 
            if ( event.isError ) then
                print( "Unzip error" )
                deferred:reject()
                spinner:remove()
            else
                print( "event.name:" .. event.name )
                print( "event.type:" .. event.type )
                if ( event.response and type(event.response) == "table" ) then
                    -- for i = 1, #event.response do
                    --     print( event.response[i] )
                    -- end
                    -- local selectedPurchase = event.response[1]
                    -- selectedPurchase = selectedPurchase:sub(1, selectedPurchase:len()-1)
                    print("zipListener:"..filename)
                    moveAsset(bookProj, version, item)
                end
                deferred:resolve(item)
            end
        end,
    }
    zip.uncompress(options)
end

local function downloadZip(url, filename, bookProj, version, item,  deferred)
    print ("downloadZip", url, filename)
    local params    = {}
    params.progress = true
    network.download( url.."?a="..os.time(), "GET",
        function(event)
            if ( event.isError ) then
                print( "Network error - pageX.json failed" )
                deferred:reject()
                spinner:remove()

            elseif ( event.phase == "ended" ) then
                if ( math.floor(event.status/100) > 3 ) then
                    print( "Network error - assets.json failed", event.status )
                    deferred:reject()
                    spinner:remove()
                    --NOTE: 404 errors (file not found) is actually a successful return,
                    --though you did not get a file, so trap for that
                else
                    uncompressZip(filename, event.response.baseDirectory, bookProj,version, item, deferred)
                end
            end
        end,
    params, filename, system.TemporaryDirectory )
end

M.downloadAsset = function (aQueue, selectedPurchase, version)
    local _version = version or ""
    local item = aQueue:poll()
    if item then
        local deferred = Deferred()
        local url = URL ..selectedPurchase.._version.."/page"..item.page..".json"
        print("------- downloadAsset --------------")
        print(url)
        print("---------------------")
        local params    = {}
        params.progress = true
        network.download( url.."?a="..os.time(), "GET",
            function(event)
                if ( event.isError ) then
                    print( "Network error - pageX.json failed" )
                    deferred:reject()
                    spinner:remove()
                elseif ( event.phase == "ended" ) then
                    if ( math.floor(event.status/100) > 3 ) then
                        print( "Network error - assets.json failed", event.status )
                        deferred:reject()
                        spinner:remove()
                        --NOTE: 404 errors (file not found) is actually a successful return,
                        --though you did not get a file, so trap for that
                    else
                        local url = URL ..selectedPurchase.._version.."/p"..item.page.."/"..item.type..".zip"
                        downloadZip(url, selectedPurchase.._version.."p"..item.page.."_"..item.type..".zip", 
                            selectedPurchase, _version, item, deferred)
                    end
                end
            end,
            params, selectedPurchase.."page"..item.page..".json", system.TemporaryDirectory )
        return deferred:promise()
    else
        return nil
    end
end

M.isUpdateAvailable = function(name, version)
    
    local downloadables = M.getDownloadables(name, version)
    --print("isUpdateAvailable", #downloadables)
    return #downloadables > 0  
end

function M.isUpdateAvailableInVersions(name)
    print("M.isUpateAvailableInVersions", name)
    if #model.episodes[name].versions > 0 then
        for k, v in pairs(model.episodes[name].versions) do
            --print(k, v)
            local b = M.isUpdateAvailable(name, v )
            if b then
                return true
            end
        end
        return false
    else
        return  M.isUpdateAvailable(name)
    end
end


M.init = function(onSuccess, onError)
    onDownloadComplete = onSuccess
    onDownloadError    = onError
end

return M