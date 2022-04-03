local sceneName = ...

local scene = require('contexts.scene').new(sceneName, {
    name = "desktop",
    layers = {
        {slidepanel={}},
        {albumTable={}},
        {pageTable={}},
        {layerTable={}},
        {assetTable={}},
        {eventTable={}},
        {toolBar={}},
        {editPropsTable={}},
        {tools={
            {animationPanel={}},
            {actionPanel={}},
        }},
        {actionMenu = {}},
        {layerInstancePanel = {}}
    },
    components = {
        {others = {
            {nanostores={}}
        }}

        -- {audios = {}},
        -- page = {App.mui}
    },
    --------------------
    -- events
    -- a command can be associated with more than one events
    --------------------
    events = {"sidepanel.selectApp","sidepanel.selectAlbum","sidepanel.selectPage", "sidepanel.selectLayer", "sidepanel.selectAction", "sidepanel.selectTool"},
    onInit = function(scene)
        local mui = require("materialui.mui")
        mui.init(nil, {parent = scene.view, useSvg = true})

    end
})

return scene