-- copyright 2022, kwiksher
--
local command = require("generate_models")
--
command.setProjectFolder("../mui-tool_tmp")
--
local scenes = {
 --   {folder = "editor", alias = "page"}, -- alias .. index can be used for using Kwik4 scheme, p1,p2 ...
    {folder = "editor", alias = "page"} -- change the order of this scenes table for the page order
    -- the page number is updated in each xxx.lua in scenes folder
}

local model = {
    name = "editor",
    -- pageNum = 1, this will be set in ApplicationContext
    layers = {
        {background = {}}, {plus = {}}, {
            sidepanel = {
                {
                    topbar = {
                        {deleteIcon = {types = {"button"}}},
                        {newIcon = {}},
                        events = {}
                    }
                }, {layersList = {events = {"select", "drag"}}}
            }
        }
    },
    events = {"initMenu", "printStack"}
}

local function generate()
    for i = 1, #scenes do
        local scene = scenes[i]
        command.generate(scene.folder, scene.alias, i)
    end
    --
    -- command.scaffold(model)
end
---
local function onComplete(event)
    if (event.action == "clicked") then
        local i = event.index
        if (i == 1) then
            generate()
            native.showAlert("Kwik", "Done", {"OK"},
                             function() native.requestExit() end)
        elseif (i == 3) then
            print("cancelled")
            native.requestExit()
        end
    end
end

local message = "Generate scenes for "
for i=1, #scenes do
    message = message .. scenes[i].folder.. " "
end
-- Show alert with two buttons
local alert = native.showAlert("Kwik", message,
                               {"Generate", "Cancel"}, onComplete)

