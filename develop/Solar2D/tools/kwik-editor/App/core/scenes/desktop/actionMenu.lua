local M = {}
M.name = ...
M.weight = 1
---
local muiIcon = require("components.mui.icon").new()
local util = require("lib.util")
local mui = require("materialui.mui")
local muiData = require( "materialui.mui-data" )


---

local function getTools(name)
    return {{name = "test1", icon = ""}, {name = "test2", icon = ""}}
end

function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local models = {
        {name = "Animation", icon = "toolAnim", tools = getTools("animation")},
        {name = "Audio", icon = "addAudio", tools = getTools("audio")},
        {name = "Image", icon = "toolLayer", tools = getTools("image")},
        {name = "Layer", icon = "toolLayer", tools = getTools("layer")},
        {name = "Page", icon = "toolPage", tools = getTools("page")}, {
            name = "Controls",
            icon = "Actions",
            lists = {
                {name = "Action", icon = "Actions", tools = getTools("action")},
                {name = "Condition", icon = "", tools = getTools("condition")},
                {
                    name = "external",
                    icon = "AddCode",
                    tools = getTools("external")
                },
                {name = "Language", icon = "Lang", tools = getTools("language")},
                {name = "Random", icon = "", tools = getTools("random")},
                {name = "Timer", icon = "Timers", tools = getTools("timer")},
                {
                    name = "Variables",
                    icon = "addVar",
                    tools = getTools("variables")
                }
            }
        }, {
            name = "Interactions",
            icon = "toolInter",
            lists = {
                {
                    name = "Button",
                    icon = "intButton",
                    tools = getTools("button")
                }, {name = "App Rating", icon = "", tools = getTools("app")},
                {
                    name = "canvas",
                    icon = "intCanvas",
                    tools = getTools("canvas")
                },
                {name = "Screenshot", icon = "", tools = getTools("screenshot")},
                {name = "Purchase", icon = "", tools = getTools("purchase")}
            }
        }, {
            name = "Replacements",
            icon = "toolLayer",
            lists = {
                {name = "Countdown", icon = "", tools = getTools("countdown")},
                {
                    name = "filter",
                    icon = "animFilter",
                    tools = getTools("filter")
                },
                {
                    name = "Multiplier",
                    icon = "repMultiplier",
                    tools = getTools("multiplier")
                },
                {
                    name = "Partciles",
                    icon = "repParticles",
                    tools = getTools("particles")
                },
                {name = "ReadMe", icon = "repSync", tools = getTools("readme")},
                {
                    name = "Sprite",
                    icon = "repSprite",
                    tools = getTools("sprite")
                },
                {name = "Video", icon = "repVideo", tools = getTools("video")},
                {name = "Web", icon = "repWeb", tools = getTools("web")}
            }
        }, {name = "Physics", icon = "toolPhysics", tools = getTools("physics")}
    }

    local categoryMap = {}
    local toolMap = {}

    local toolListener = function(event)
        print(event.target.muiOptions.name)
        for k, v in pairs(toolMap) do
            if k ~= event.target.muiOptions.name then
                mui.turnOnButtonByName(k)
            else
                --
                -- dispatchEvent to display AnimationEditor, overlay?
                --   hide EditpPropsTable (Layer Props)?
                --
            end
        end
    end

	local function onRowTouchPopover(event)
		local muiTarget = mui.getEventParameter(event, "muiTarget")
		local muiTargetValue = mui.getEventParameter(event, "muiTargetValue")
		local muiTargetIndex = mui.getEventParameter(event, "muiTargetIndex")

		if muiTargetIndex ~= nil then
			print("row index: "..muiTargetIndex)
		end

		if muiTargetValue ~= nil then
			print("row value: "..muiTargetValue)
		end

		if event.row.miscEvent ~= nil and event.row.miscEvent.name ~= nil then
			local parentName = string.gsub(event.row.miscEvent.name, "-List", "")
			timer.performWithDelay(500, function() mui.finishPopover(parentName) end, 1)
		end
		muiData.dialogInUse = false
		muiData.dialogName = nil
		return true -- prevent propagation to other controls
	end
	--
	local function showPopover(Props)
        mui.newPopover({
            parent = mui.getParent(),
            name = "popovermenu_demo1",
            font = native.systemFont,
            textColor = { 0.4, 0.4, 0.4 },
            backgroundColor = {0.94,0.94,0.94,1},
            touchpointColor = { 0.4, 0.4, 0.4 }, -- the touchpoint color
            activeColor = { 0.12, 0.67, 0.27, 1 },
            inactiveColor = { 0.8, 0.8, 0.8, 1 },
            strokeColor = { 0.8, 0.8, 0.8, 1 },
            strokeWidth = 0,
            leftMargin = 10,
            width = 200,
            height = 18,
            listHeight = 18 * #Props.list,
            x = Props.x,
            y = Props.y,
            callBackTouch = onRowTouchPopover,
            list = Props.list

			-- { -- if 'key' use it for 'id' in the table row
            --     { key = "Row1", text = "Popover Item 1", value = "Popover Item 1", },
            --     { key = "Row2", text = "Popover Item 2", value = "Popover Item 2", },
            --     { key = "Row3", text = "Popover Item 3", value = "Popover Item 3", },
            --     { key = "Row4", text = "Popover Item 4", value = "Popover Item 4", },
            -- },
        })
    end

    local listener = function(event)
        local target = event.target
        --
        -- for k, v in pairs(event.target.muiOptions) do print(k, v) end
        for k, v in pairs(categoryMap) do
            if k ~= event.target.muiOptions.name then
                mui.turnOnButtonByName(k)
            elseif (v.lists) then
				print("----------------")
				local model = {}
                for i = 1, #v.lists do
                    local tool = v.lists[i]
					model[#model + 1] = {key=tool.name, text=tool.name, value=tool.name}
                end
				showPopover{x= v.x, y= v.y, list=model}
            end
        end

        --
    end

    for k, v in pairs(models) do

		local dx = (k-1) % 3
		local dy = math.floor((k-1)/3)
		print("actionMenu", dx, dy)
        local obj = muiIcon:createImage{
            icon = v.icon,
			text = v.name,
            name = self.name .. "-" .. v.name,
            x = display.contentCenterX - 360 + dx * 120,
            y = dy * 60 + 100,
            width = 120,
            height = 36,
			fontSize = 16,
            listener = listener
        }
        obj.lists = v.lists
        categoryMap[self.name .. "-" .. v.name] = obj
    end

    UI.actionMenu = self

    function self:show()
        for k, v in pairs(categoryMap) do v.alpha = 1 end
    end

    function self:hide ()
        for k, v in pairs(categoryMap) do v.alpha = 0 end
    end

    self:hide()

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy() end
--
return M

