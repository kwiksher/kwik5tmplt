local M = {}
--
local zip = require( "plugin.zip" )
local spinner = require("extlib.spinner").new("download server")
local queue = require("extlib.queue")
local model = require("components.store.model")
local V2 = require("components.store.downloadManagerV2")
--
local onDownloadComplete
local onDownloadError
-- local selectedPurchase
local downloadQueue
--
local URL       = model.URL
local filename = "/assets.zip"
--
local function zipListener( event, deferred , selectedPurchase, version)
    if ( event.isError ) then
        print( "Unzip error" )
        onDownloadError(selectedPurchase, version, "Unzip error")
        deferred:reject()
    else
        print( "event.name:" .. event.name )
        print( "event.type:" .. event.type )
        if ( event.response and type(event.response) == "table" ) then
            -- for i = 1, #event.response do
            --     print( event.response[i] )
            -- end
            -- local selectedPurchase = event.response[1]
            -- selectedPurchase = selectedPurchase:sub(1, selectedPurchase:len()-1)
            print("zipListener:"..selectedPurchase..version)
            onDownloadComplete(selectedPurchase, version)
        end
        deferred:resolve()
    end
    spinner:remove()
end
--
local function networkListener(event, deferred, selectedPurchase, version)
    if ( event.isError ) then
        print( "Network error - download failed" )
        onDownloadError(selectedPurchase, version, "Network error - download failed")
        deferred:reject()
    elseif ( event.phase == "began" ) then
        print( "Progress Phase: began" )
        spinner:show()
    elseif ( event.phase ==  "progress" ) then
        spinner:setBytesTransferred(event)
    elseif ( event.phase == "ended" ) then
        spinner:remove()
        if ( math.floor(event.status/100) > 3 ) then
            print( "Network error - download failed", event.status )
            onDownloadError(selectedPurchase, version, event.status)
            deferred:reject()
            --NOTE: 404 errors (file not found) is actually a successful return,
            --though you did not get a file, so trap for that
        else
            local options = {
                zipFile = event.response.filename,
                zipBaseDir = event.response.baseDirectory,
                -- dstBaseDir = _K.DocumentsDir,
                dstBaseDir = system.ApplicationSupportDirectory,
                listener = function(event) zipListener(event, deferred, selectedPurchase, version) end,
            }
            spinner:show()
            zip.uncompress(options)
        end
    end
end
-- 
--
local function _startDownload(selectedPurchase, version)
    local deferred = Deferred()
    local path = system.pathForFile(selectedPurchase..version..".zip", system.TemporaryDirectory)
    local _time     = os.time()
    print(path)
    local fh, reason = io.open( path, "r" )
    if fh then
        io.close( fh )
        if M.hasDownloaded(selectedPurchase, version) then
            local episode = selectedPurchase
            timer.performWithDelay(50, function()
                onDownloadComplete(episode, version)
                deferred:resolve()
                end )
        else
            local options = {
                zipFile = selectedPurchase..version.._time..".zip",
                zipBaseDir = system.TemporaryDirectory,
                -- dstBaseDir = _K.DocumentsDir,
                dstBaseDir = system.ApplicationSupportDirectory,
                listener = function(event) zipListener(event, deferred, selectedPurchase, version) end,
            }
            spinner:show()
            zip.uncompress(options)
        end
    else

        local url = URL ..selectedPurchase..version..filename
        print("---------------------")
        print(url)
        print("---------------------")
        local params    = {}
        params.progress = true
        network.download( url.."?a=".._time, "GET",
            function(event)
                networkListener(event, deferred, selectedPurchase, version)
            end,
            params, selectedPurchase..version.._time..".zip", system.TemporaryDirectory )
    end
    return deferred:promise()
end

function M.hasDownloaded(episode, version)
    print("hasDownloaded", episode, version)
    if not model.URL then 
        print ("no model.URL means it is embedded")
       return  true  
    end
    local _ver = version or ""
    local path = system.pathForFile( model.episodes[episode].dir.._ver, system.ApplicationSupportDirectory )
    return os.rename(path,path) and true or false
end

function M.isUpdateAvailable(name, version)
    if model.downloadManager == "V2" then 
        return V2.isUpdateAvailable(name,version)
    else
        return false
    end
end

function M.isUpdateAvailableInVersions(name)
    if model.downloadManager == "V2" then 
        return V2.isUpdateAvailableInVersions(name)
    else
        return false
    end
end

function M:init(onSuccess, onError)
    onDownloadComplete = onSuccess
    onDownloadError    = onError
    downloadQueue = queue.new()
    Runtime:addEventListener("downloadManager:purchaseCompleted", function(event)
        local selectedPurchase = event.target
        local version = event.version
        if M.hasDownloaded(selectedPurchase, version) then
            onDownloadComplete(selectedPurchase, version)
        else
            downloadQueue:offer({product=selectedPurchase, version=version})
        end
    end)
    -- fetch assets.json for all books
    if model.downloadManager == "V2" then 
        V2.fetchAssets()
    end
end

function M.isDownloadQueue()
   -- print(downloadQueue:length())
    return downloadQueue:length() > 0
end

function M:startDownload(episode, version)
    local selectedPurchase = episode
    local _version = version or ""

    if selectedPurchase == nil then
        local item = downloadQueue:poll()
        if item then
            print("downloadManager:startDownload Queue", item)
            selectedPurchase = item.product
            _version = item.version  or ""
        end
        print("nothing to be donwloaded")
    end

    if selectedPurchase then
        print("downloardManager:startDownload:"..selectedPurchase, _version)
        if model.downloadManager == "V2" then
            V2.init(onDownloadComplete, onDownloadError)
            promise = V2.startDownload(selectedPurchase, _version)
                :done(function()
                        self:startDownload()
                    end)
                :fail(function(error)
                    print("Download Error ", error)
                    end)
                :always(function()
                    end)
        else
            promise = _startDownload(selectedPurchase, _version)
                :done(function()
                        self:startDownload()
                    end)
                :fail(function(error)
                    print("Download Error ", error)
                    end)
                :always(function()
                    end)
        end
    end
end
--
M.setButtonImage = function (_button, id, version)
    local params = {}
    local version = version or ""
    local button = _button
    local imgName = model.backgroundImg or button.imagePath:sub(1, button.imagePath:len()-4).. display.imageSuffix ..".png"
    local _time = os.time()
    params.progress = true
    
    --
    local function buttonImageListener( event )
        if ( event.isError ) then
            print( "Network error - download failed: ", event.response )
            local path = system.pathForFile( button.name.._time..".png", system.TemporaryDirectory)
            local fhd = io.open( path )
            -- Determine if file exists
            if fhd then
                button.fill = {
                    type = "image",
                    filename = button.name.._time..".png",
                    baseDir = system.TemporaryDirectory
                }
               fhd:close()
            else
                print( "File does not exist!" )
            end
        elseif ( event.phase == "began" ) then
            print( "Progress Phase: began" )
        elseif ( event.phase == "ended" ) then
            print( "Displaying response image file with " ..button.name ..".png")
            button.fill = {
                type = "image",
                filename = button.name.._time..".png",
                baseDir = system.TemporaryDirectory
            }
        end
    end
    print("download image", button.name, URL..id..version.."/"..imgName)
    --
    network.download(
        URL..id..version.."/"..imgName.."?time=".._time,
        "GET",
        buttonImageListener,
        params,
        button.name.._time..".png",
        system.TemporaryDirectory
    )
end

return M
