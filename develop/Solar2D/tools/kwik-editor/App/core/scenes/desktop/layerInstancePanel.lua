local M = {}
M.name = ...
M.weight = 1
---
local muiIcon = require("components.mui.icon").new()
local util = require("lib.util")
local mui = require("materialui.mui")
local muiText   = require("components.mui.text").new()

---
function M:init(UI) end
--
function M:create(UI)
    print("create", self.name)

    local icons = {
        {
            name = "Properties",
            icon = "toolPage",
            tools = {
                {name = "Properties", icon = "LayerProp"},
                {name = "Language", icon = "Lang"},
                {name = "setLanguage", icon = "setLang"}
            }
        }, {
            name = "Replacements",
            icon = "toolLayer",
            tools = {
                {name = "Particles", icon = "repParticles"},
                {name = "Counter", icon = "repCounter"},
                {name = "DynamicText", icon = "repDyn"},
                {name = "InputText", icon = "repInput"},
                {name = "Map", icon = "repMap"},
                {name = "Mask", icon = "repMask"},
                {name = "Multiplier", icon = "repMultiplier"},
                {name = "Spritesheet", icon = "repSprite"},
                {name = "SyncTextAudio", icon = "repSync"},
                {name = "Text", icon = "repText"},
                {name = "Vector", icon = "repVector"},
                {name = "Video", icon = "repVideo"},
                {name = "Web", icon = "repWeb"}
            }
        }, {
            name = "Animations",
            icon = "toolAnim",
            tools = {
                {name = "Linear", icon = "animLinear"},
                {name = "Blink", icon = "animBlink"},
                {name = "Bounce", icon = "animBounce"},
                {name = "Filter", icon = "animFilter"},
                {name = "Path", icon = "animPath"},
                {name = "Pulse", icon = "animPulse"},
                {name = "Rotation", icon = "animRotation"},
                {name = "Shake", icon = "animShake"},
                {name = "Switch", icon = "animSwitch"}
            }
        }, {
            name = "Interactions",
            icon = "toolInter",
            tools = {
                {name = "Button", icon = "intButton"},
                {name = "Canvas", icon = "intCanvas"},
                {name = "Drag", icon = "intDrag"},
                {name = "Pinch", icon = "intPinch"},
                {name = "Parallax", icon = "intParallax"},
                {name = "Scroll", icon = "intScroll"},
                {name = "Spin", icon = "intSpin"},
                {name = "Shake", icon = "intShake"},
                {name = "Swipe", icon = "intSwipe"}
            }
        }, {
            name = "Physics",
            icon = "toolPhysics",
            tools = {
                {name = "Properites", icon = "PhyProp"},
                {name = "Body", icon = "PhyBody"},
                {name = "Collision", icon = "PhyColl"},
                {name = "Forcwe", icon = "PhyForce"},
                {name = "Joint", icon = "PhyJoint"}
            }
        }
    }

	local models = {}

    local instanceMap = {}
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

                -- UI.currentTool = event.target.muiOptions.name
                -- UI.scene:dispatchEvent({
                --     name = "sidepanel.selectTool",
                --     UI = UI
                -- })

				--
			end
		end
	end


    local listener = function(event)
        print(event.target)
		--
		for k, v in pairs(toolMap) do
			v:removeSelf()
		end
		toolMap = {}
        -- for k, v in pairs(event.target.muiOptions) do print(k, v) end
        for k, v in pairs(categoryMap) do
            if k ~= event.target.muiOptions.name then
                mui.turnOnButtonByName(k)
			else
				for i=1, #v.tools do
					local tool = v.tools[i]
					local obj = muiIcon:createToolImage{
						icon = tool.icon,
						name = self.name .. "-" .. tool.name,
                        --text = tool.name,
                        hoverText = tool.name,
						x = display.contentCenterX + 560 + i * 30,
						y = 36,
						width = 36,
						height = 36,
						listener =toolListener
					}
					toolMap[self.name .. "-" .. tool.name] =  obj
				end
            end
        end

		--
    end

    -- for k, v in pairs(models) do
    --     local obj = muiIcon:createImage{
    --         icon = v.icon,
    --         name = self.name .. "-" .. v.icon,
    --         x = display.contentCenterX + 560 + k * 30,
    --         y = 0,
    --         width = 36,
    --         height = 36,
    --         listener = listener
    --     }
	-- 	obj.tools = v.tools
    --     categoryMap[self.name .. "-" .. v.icon] = obj
    -- end

    UI.layerInstanceStore:listen(function(foo, fooValue)

        self:destroy()
        self.group = display.newGroup()

        local albumTable = mui.getWidgetByName("scenes.desktop.albumTable")

        local labelText=muiText:createText{
            parent = self.group,
			name=self.name.."-text",
			text = "INSTANCES",
			x =  albumTable.options.x + albumTable.options.width + 150,
			y = albumTable.options.y,
            align = "right"
		}
        labelText.x = labelText.x + labelText.width/2

        if fooValue then
            for i=1, #fooValue do
                print(" ------- layerInstanceStore ------- ")
                local instance = fooValue[i]
                for k, v in pairs(instance) do print(k, v) end
                if instance.type =="animation" then
                    instance.icon = "toolAnim"
                elseif instance.type == "button" then
                    instance.icon = "intButton"
                end
            -- should we read .json here  for details?
                local dx = (i-1) % 3
                local dy = math.floor((i-1)/3)
                local obj = muiIcon:createImage{
            		parent = self.group,
                    icon = instance.icon,
                    text = instance.name,
                    name = self.name .. "-" .. instance.name,
                    x = labelText.x + dx * 160,
                    y = labelText.y + 10 + dy * 60,
                    width = 160,
                    height = 48,
                    fontSize = 24,
                    listener = listener
                }
                --obj.lists = instance.lists
                instanceMap[self.name .. "-" .. instance.name..instance.icon] = obj
            end
        end


	end)

    UI.layerInstancePanel = self

end
--
function M:didShow(UI) end
--
function M:didHide(UI) end
--
function M:destroy()
    if self.group then
        self.group:removeSelf()
    end
    self.group = nil
end
--
return M

