local name = ...
local parent = name:match("(.-)[^%.]+$")

local exports = {test = {}}

local json = require("json")
local zip = require( "plugin.zip" )
local util = require(parent.."util")
local assets = require(parent.."assets")

local view       = null

local rootFolder = system.pathForFile("", system.ResrouceDirectory)

local unzip = function(filename, baseDirectory, foldername)
    --print(filename, baseDirectory)

    local lfs = require( "lfs" )
    local temp_path = system.pathForFile( "", system.TemporaryDirectory )
    local new_folder_path = system.pathForFile( foldername, system.TemporaryDirectory )
    -- local success = lfs.chdir( temp_path )  --returns true on success
    -- if ( success ) then
    --     lfs.mkdir(foldername )
    -- end
    -- new_folder_path = lfs.currentdir(system.TemporaryDirectory)
    --print(new_folder_path)

    local deferred = Deferred()
    local options = {
        zipFile = filename,
        zipBaseDir = baseDirectory,
        -- dstBaseDir = _K.DocumentsDir,
        dstBaseDir = system.TemporaryDirectory,
        listener = function(event)
            view:zipEvent(event)
            if ( event.isError ) then
                print( "Unzip error" )
                deferred:reject()
            else
                --print( "event.name:" .. event.name )
                --print( "event.type:" .. event.type )
                deferred:resolve(baseDirectory)
            end
        end,
    }
    zip.uncompress(options)
    return deferred:promise()
end

local accessFile = function (url, params, method, filename)
    local deferred = Deferred()

    --update the DB and send email
    network.download( url, method,
        function(event)
            view:networkEvent(event)
            if event.isError then
                deferred:reject()
            elseif ( event.phase == "ended" ) then
                deferred:resolve(event.response)
            end
        end, params, filename, system.TemporaryDirectory )
    return deferred:promise()
end

local access = function (url, params, method)
    local deferred = Deferred()
    network.request( url, method,
        function(event)
            view:networkEvent(event)
            if event.isError then
                deferred:reject(event.status)
            elseif ( event.phase == "ended" and event.status == 200 ) then
                deferred:resolve(event.response)
            else
                deferred:reject(event.status)
            end
        end, params )
    return deferred:promise()
end

-------------------------------
-- download & install
--
local function fetch(asset)
    print("fetch")
    local deferred = Deferred()
    accessFile(asset.url, assets.params, "GET", asset.latestName )
    :done(function(response)
        view.spinnerText.text = "uncompressing ".. asset.latestName.. "..."
        unzip(response.filename, response.baseDirectory, asset.latestName)
        :done(function(dir)
           -- view.spinnerText.text = "uncompressed ".. asset.latestName.. "..."
            deferred:resolve(dir) -- uncompressed
        end)
        :fail(function(error)
            print("unzip error")
            deferred:reject("unzip error")
        end)
        :always(function()
        end)
    end)
    :fail(function(error)
        print("download error")
        deferred:reject()
    end)
    :always(function()
    end)
    return deferred:promise()
end

function exports:processUpdate(onEvent)
    onEvent{name="started"}
    local d1, d2, d3
    if assets.editor.name ~= assets.editor.latestName then
        util.backup(assets.editor, rootFolder.."/backup")
        d1 = fetch(assets.editor)
    else
        d1 = Deferred()
        d1:resolve("")
    end
    if assets.template.name ~= assets.template.latestName then
        util.backup(assets.template, rootFolder.."/backup")
        d2 = fetch(assets.template)
    else
        d2 = Deferred()
        d2:resolve("")
    end
    if assets.framework.name ~= assets.framework.latestName then
      util.backup(assets.framework, rootFolder.."/backup")
      d3 = fetch(assets.framework)
  else
      d3 = Deferred()
      d3:resolve("")
  end
  when(d1, d2, d3)
    :done(function(dir1, dir2, dir3)
        if dir1 ~="" then
            util.install(assets.editor, dir1, rootFolder)
        end
        if dir2 ~="" then
            util.install(assets.template, dir2, rootFolder)
        end
        if dir3 ~="" then
          util.install(assets.framework, dir3, rootFolder)
      end
    end)
    :fail(function(error) onEvent{name="error", error = error} end)
    :always(function()
      onEvent{name="ended"}
    end)
end

exports.isNewVersion = function ()
   local deferred = Deferred()
   access(assets.API, assets.params, "GET")
   :done(function(assetsJson)
        local latestAssets = json.decode(assetsJson)

        if latestAssets.tag_name == assets.version then
                deferred:resolve(false)
        else
            assets.latestVersion = latestAssets.tag_name
            for i, asset in next, latestAssets.asssets do
              if asset.name:find("tempalte") > 0 then
                assets.template.latestName = asset.name
                asssets.template.url = asset.url
              elseif asset.name:find("editor") > 0 then
                assets.editor.latestName = asset.name
                asssets.template.editor = asset.url
              elseif asset.name:find("framework") > 0 then
                assets.framework.latestName = asset.name
                asssets.framework.url = asset.url
              end
            end

            if assets.template.latestName == template.name and
              assets.editor.latestName   == editor.name and
              assets.framework.latestName == framework.name then
              deferred:resolve(false)
            else
              deferred:resolve(true)
            end
        end
    end)

    return deferred:promise()
end

exports.test._install = _install
exports.test.unzip    = unzip
exports.test.fetch    = fetch

return exports
