local M = {}
--
local json = require("json")
local app = require("Application")
local dragger = require("components.kwik.layer_drag")

local function readProps(path)
    print(path)
    local decoded, pos, msg = json.decodeFile( path )
    if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
        return nil
    else
        return decoded
    end
end

function M.displayLayers(layers, pagePath, folder, UI)
    app.imgDir = "../../../../../../.."..UI.currentAlbum.path .."/assets/images/"
    -- app.systemDir = system.ResourceDirectory
    app.systemDir = system.ResourceDirectory

    local folderPath =""
    if folder then
        folderPath = folder .."/"
    else
        local root = display.newGroup()
        UI.scene.view:insert(root)
        UI.rootScene = root
    end
    --
    local sceneGroup = UI.rootScene
    --
    local images = {}
    --
    for i=#layers, 1, -1  do
        local layer = layers[i]
        if #layer.layers == 0 then
            local path = pagePath.."/"..folderPath ..layer.name..".json"
            print("path:", path)
            --
            local props = readProps(path)
            --for k, v in pairs(props) do print(k, v) end
            if props then
                local obj = require("components.kwik.layer_image").new()
                obj.layerName = layer.name
                obj.randXEnd             = app.getPosition(props.randXEnd)
                obj.randXStart           = app.getPosition(props.randXStart)
                obj.dummy, obj.randYEnd   = app.getPosition(nil, props.randYEnd)
                obj.dummy, obj.randYStart = app.getPosition(nil, props.randYStart)
                obj.imageHeight          = props.height
                obj.imageWidth           = props.width
                obj.infinityDistance     = app.parseValue(props.infinityDistance or 0)/4
               -- obj.mX, obj.mY            = app.getPosition(props.x, props.y, props.align)
               obj.mX, obj.mY            = props.x, props.y
                obj.oriAlpha              = props.alpha
                if UI.currentPage.name == folder then
                    obj.imagePath = UI.currentPage.name.. "/"..layer.name ..".png"
                else
                    obj.imagePath = UI.currentPage.name.. "/"..folderPath..layer.name ..".png"
                end
                if obj.isSharedAsset then
                    obj.imagePath = layer.name ..".png"
                end
                print("imagePath:", obj.imagePath)
                print("system ressouce:", system.pathForFile(nil, system.ResourceDirectory))

                --/Users/ymmtny/Documents/GitHub/kwik5/sandbox/Solar2D_MENU/KwikLiveEditor
                --
                -- models/scenes/
                -- assets/images/
                local ret = obj:newImage(UI, sceneGroup)
                if ret then
                    table.insert(images, ret)
                end
                dragger.add(ret, function(t)print("dragged", t.name)end)
                -- ../../../../../../../Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/book01/assets/images/page01/sidepanel/layersList.png
                -- /Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/book01/assets/images/page01/sidepanel/layersList.png
                -- /Users/ymmtny/Documents/GitHub/kwik5/sandbox/Ps/react-uxp-styles/Project/Solar2D/src/App/book01/assets/images/page01/sidepanel/layersList.png
            end
        else
            local group = display.newGroup()
            group.name = layer.name
            group.type = "group"

            dragger.add(group, function(t) print("dragged", t.name) end)

            for k, v in pairs(layer.layers) do print(k, v) end

            local _layers = {}
            for k=1, #layer.layers do
                local entry = layer.layers[k]
                local _layer = {}
                for layerName, entries in pairs(entry) do
                    if layerName ~= "events" and layerName ~="types" then
                        _layer.name = layerName
                        _layer.layers = entries
                        table.insert(_layers, _layer)
                    elseif layerName == "types" then
                        _layer.types = entries
                    end
                end
            end
            local entries = M.displayLayers(_layers, pagePath.."/"..folderPath, layer.name , UI)
            for i=1, #entries do
                group:insert(entries[i])
            end
            sceneGroup:insert(group)
            table.insert(images, group)
        end
        --------
        -- types
        ---
        if layer.types then
            for j=1, #layer.types do
                table.insert(UI.types, {folder= folder, name=layer.name, type = layer.types[j], path=pagePath.."/"..folderPath ..layer.name.."_"..layer.types[j] ..".json"})
                print("####", pagePath.."/"..folderPath ..layer.name.."_"..layer.types[j] ..".json")
            end
        end
    end
    return images
end


return M