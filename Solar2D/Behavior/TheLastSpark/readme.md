
- [narration ...] - Used for descriptive narrative text
- [wait for next] - Added after each action/scene to control pacing
- [show ...] - For displaying objects/characters
- [sfx ...] - For sound effects (door_creak, door_rattle, lock_click, door_slam, shake)
- [vo ...] - For voice-over dialogue (vo_elara_seed_found, vo_elara_need_key, etc.)
- [music ...] - For background music
- [emotion elara ...] - For character emotions (happy, shocked, panicking)
- [scene ...] - For scene transitions
- [focus ...] - For player choice focus
- [choice ...] - For choice actions
- [ui show_choices] - Added before the player choice section

---

## Behavior Tree

### Display Object Creation Stack

1. models/forest/elara.lua

     ```lua
     local M = {}

     function M.create()
         return {
             states = {
                 neutral = "App/TheLastSpark/assets/images/forest/elara_neutral.png",
                 scared = "App/TheLastSpark/assets/images/forest/elara_scared.png",
                 determined = "App/TheLastSpark/assets/images/forest/elara_determined.png",
                 happy = "App/TheLastSpark/assets/images/forest/elara_happy.png",
             },
             x = 300,
             y = 500,
             width = 300,
             height = 500,
             currentState = "neutral",
             visible = false
         }
     end

     return M
     ```

2. models/forst/forest_model.lua

     ```lua
      M.objects = {
          elara = forestElara.create(),
          wolf = forestWolf.create(),
          luminSeed = forestLuminSeed.create(),
      }

      return M
     ```

3. views/forest/forstScene.lua

   ```lua
   local layout = {
       background = "App/TheLastSpark/assets/images/forest/bg_cabin.png",
       objects = {
           elara = {
               x = (model.objects.elara or {}).x or 300,
               y = (model.objects.elara or {}).y or 500,
               width = (model.objects.elara or {}).width or 300,
               height = (model.objects.elara or {}).height or 500,
               neutralState = ((model.objects.elara or {}).states or {}).neutral or "App/TheLastSpark/assets/images/forest/elara_neutral.png",
           },
       },
   }
   ```

  create()

   ```lua
   function scene:create(event)
       local sceneGroup = self.view

       -- Use BaseScene initialization for display
       self:initializeDisplay(sceneGroup, {
           background = layout.background,
       })

       -- Pre-load characters (but don't show them yet)
       self.objs.elara = common.createCharacter("elara", model, layout, self.objs.characterGroup)
       self.objs.luminSeed = common.createCharacter("luminSeed", model, layout, self.objs.characterGroup)
       self.objs.wolf = common.createCharacter("wolf", model, layout, self.objs.characterGroup)
   ```

1. utils/common_helpers.lua

   ```lua
   function M.createCharacter(objectName, model, layout, parentGroup, overrides)
       local DisplayBase = require("views.display_base")
       local template = (model.objects or {})[objectName] or {}
       local layoutData = (layout.objects or {})[objectName] or {}
       local modelData = M.buildDisplayModel(template, layoutData, overrides or { visible = false })
       return DisplayBase:create(parentGroup, modelData)
   end
   ```

1. views/display_base.lua

   ```lua
   function DisplayBase:create(parentGroup, modelData)
       local obj = displayManager.newImageRect(
           parentGroup,
           modelData.states[modelData.currentState], -- this is the image file path
           modelData.width,
           modelData.height
       )

       obj.x = modelData.x
       obj.y = modelData.y
       obj.isVisible = modelData.visible

       -- Store reference to model data
       obj.modelData = modelData

       return obj
   end
   ````

1. views/displayManger.lua

   ```lua
   function M.newImageRect(...)
       local args = {...}
       local parent, filename, baseDir, width, height

       -- Parse arguments based on different newImageRect signatures
       if type(args[1]) == "userdata" or type(args[1]) == "table" then
           -- display.newImageRect(parent, filename, [baseDir,] width, height)
           parent = args[1]
           filename = args[2]
           if type(args[3]) == "number" then
               width = args[3]
               height = args[4]
           else
               baseDir = args[3]
               width = args[4]
               height = args[5]
           end
       else
           -- display.newImageRect(filename, [baseDir,] width, height)
           filename = args[1]
           if type(args[2]) == "number" then
               width = args[2]
               height = args[3]
           else
               baseDir = args[2]
               width = args[3]
               height = args[4]
           end
       end

       -- Try to create the image
       local img
       if parent then
           if baseDir then
               img = display.newImageRect(parent, filename, baseDir, width, height)
           else
               img = display.newImageRect(parent, filename, width, height)
           end
       else
           if baseDir then
               img = display.newImageRect(filename, baseDir, width, height)
           else
               img = display.newImageRect(filename, width, height)
           end
       end

       -- If image failed to load, create a text placeholder as fallback
       if img == nil then
           print("Image failed to load. Filename:", filename, "Type:", type(filename))

           local placeholderText = "missing"
           if filename and type(filename) == "string" then
               placeholderText = filename:match("([^/]+)$") or filename
               print("Extracted placeholder text:", placeholderText)
           else
               print("Filename is nil or not a string, using 'missing'")
           end

           -- Store missing file info (will be displayed separately)
           M.missingFileCount = M.missingFileCount + 1
           local fileIndex = M.missingFileCount
           table.insert(M.missingFiles, placeholderText)

           -- Create placeholder with index number
           -- Ensure width and height are valid numbers
           width = tonumber(width) or 100
           height = tonumber(height) or 100

           -- Create a group to hold both the rectangle and index text
           local placeholderGroup
           if parent then
               placeholderGroup = display.newGroup()
               parent:insert(placeholderGroup)
           else
               placeholderGroup = display.newGroup()
           end

           -- Create semi-transparent red rectangle
           local rect = display.newRect(placeholderGroup, 0, 0, width, height)
           rect:setFillColor(1, 0, 0, 0.3)
           rect.alpha = 0.5

           -- Add index number in center of placeholder
           local indexText = display.newText({
               parent = placeholderGroup,
               text = tostring(fileIndex),
               x = 0,
               y = 0,
               font = native.systemFontBold,
               fontSize = 24
           })
           indexText:setFillColor(1, 1, 0)  -- Yellow text

           -- Store the index on the group for later reference
           placeholderGroup._missingFileIndex = fileIndex
           placeholderGroup._missingFileName = placeholderText

           img = placeholderGroup

           print("Created placeholder #" .. fileIndex .. " for missing file: " .. placeholderText)
           print("Placeholder dimensions: width=" .. tostring(width) .. ", height=" .. tostring(height))
       end
       return img
   end
   ```

  ### Show/Change sate

  forstScene.lua

   ```lua
    --- Initialize action controller with scene objects
    actionController.initialize(self.objs)
  ```


  action_helper.lua

   ```lua
    function actionModule.showObject(objectName, fadeTime)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        fadeTime = fadeTime or 1000
        local obj = actionModule.sceneObjects[objectName]

        obj.isVisible = true
        obj.alpha = 0
        transition.fadeIn(obj, { time = fadeTime })

        print("Showing " .. objectName)
        return bt.SUCCESS
    end

    function actionModule.changeState(objectName, stateName, viewModule)
        if not actionModule.checkObject(objectName) then
            return bt.FAILED
        end

        if not viewModule or not viewModule.changeState then
            print("Error: Invalid view module for " .. objectName)
            return bt.FAILED
        end

        local obj = actionModule.sceneObjects[objectName]
        print("DEBUG changeState: Before - obj type: " .. type(obj))
        local newObj = viewModule:changeState(obj, stateName)
        print("DEBUG changeState: After changeState - newObj type: " .. type(newObj))
        actionModule.sceneObjects[objectName] = newObj
        print("DEBUG changeState: After assignment - sceneObjects[" .. objectName .. "] type: " .. type(actionModule.sceneObjects[objectName]))

        print("Changed " .. objectName .. " to " .. stateName)
        return bt.SUCCESS
    end
   ```
---

- components/forst/layers/elara_netural.lua

  ```lua
  M.isSharedAsset = nil
  M.imagePath   = "forest/elara_neutral.png"

  function M:init(UI)
    --local sceneGroup = UI.scene.view
  	if not self.isSharedAsset then
      self.imagePath = UI.page ..self.imageName
    end
  end
  --
  function M:create(UI)
  	if not self.isSharedAsset then
      self.imagePath = UI.page ..self.imageName
    end
    local obj = self:createImage(UI)
    UI.layers[#UI.layers] = obj
    self.obj = obj

    if self.infinity and self.infinity.enabled then
      infinity.createInfinityImage(UI, self.obj, self.infinity)
    end
  end
  ```

- kwik/components/layer_image.lua

  ```lua
  function M:createImage(UI)
    local sceneGroup = UI.sceneGroup
    local obj = display.newImageRect(
      UI.props.imgDir..self.imagePath,
      UI.props.systemDir,
      self.imageWidth,
      self.imageHeight)
    if obj == nil then return nil end
    --
    obj.imagePath = self.imagePath
    obj.x         = self.mX
    obj.y         = self.mY
    obj.alpha     = self.oriAlpha
    obj.oldAlpha  = self.oriAlpha
    obj.blendMode = self.blendMode
    --
    obj.layerAsBg = self.layerAsBg
    obj.isSharedAsset = self.isSharedAsset
    ---
    obj.shapedWith = self.layerProps.shapedWith
    obj.randXStart  = self.layerProps.randXStart
    obj.randXEnd    = self.layerProps.randXEnd
    obj.randYStart  = self.layerProps.randYStart
    obj.randYEnd    = self.layerProps.randYEnd
    obj.type        = self.layerProps.type
    obj.kind        = self.layerProps.kind

    -- print("Image positioned: " .. self.name .. " at " .. obj.x .. ", " .. obj.y)
    --
    if type(self.randXStart) == "number" and self.randXStart > 0 then
       obj.x = math.random( self.randXStart, self.randXEnd)
    end
    if type(self.randYStart) == "number" and self.randYStart > 0  then
       obj.y = math.random( self.randYStart, self.randYEnd)
    end
    if type(self.xScale) == "number" then
      obj.xScale = self.xScale
    end
    if type(self.yScale)  == "number" then
      obj.yScale = self.yScale
    end
    if type(self.rotation)  == "number" then
      obj:rotate( self.rotation )
    end
    --
    obj.oriX = obj.x
    obj.oriY = obj.y
    obj.oriXs = obj.xScale
    obj.oriYs = obj.yScale
    obj.name = self.name
    -- obj.type = "image"
    --
    sceneGroup[self.name] = obj
    -- print("@@@@", self.name, obj)

    --
    if self.layerAsBg then
      sceneGroup:insert( 1, obj)
    else
      sceneGroup:insert( obj)
    end
    --
    return obj
  end
  ```

## Kwik Contoller UI

  ### call stack from composer

  - lua_modules/kwiksher/kwik/controller/scene.lua

    ```lua
    function scene:create(event)
      if self.UI.props.appName == nil then
        self.calssType = event.params.sceneProps.classType
        self.UI = event.params.sceneProps.UI
        self.model = event.params.sceneProps.model
        self.getCommands = event.params.sceneProps.getCommands
        self.app = event.params.sceneProps.app
      end
      --
      -- local sceneGroup = self.view -- this comes from composer
      --self.UI.sceneGroup = self.view
      --
      if self.UI.props.editor  then
        -- self.UI.sceneGroup.x = display.contentCenterX
        -- self.UI.sceneGroup.y = display.contentCenterY
        -- self.UI.sceneGroup.anchorX = .5
        -- self.UI.sceneGroup.anchorY = .5
      end

      self.view:insert(self.UI.sceneGroup)

      self.UI:create(event.params)
      if self.model.onInit then self.model.onInit(self.UI) end
      self.app:dispatchEvent({name = "onRobotlegsViewCreated", target = self, UI=self.UI})

    end
    ```

  - controller/ApplicationUI.lua

    ```lua
    function UI:create(params)
        uiHandler:init(self)
        -- self:_create("common", const.page_common, false)
        self:setLanguge()
        self:init()
        self.sceneEventParams = params
        callComponentsLayersHandler(model.components.layers, self.sceneHandler, "_create")
        callComponentsHandler(model.components, self.componentLocalHandler, "_create")
        if self.scene.UI.props.common then
          callCommonComponentHandler(self.scene.UI.props.common.components, self.commmonHandler, "_create")
        end
        uiHandler:create(self)
    end
    ```

    this calls sceneHander:_create()

    ```lua
    local function callComponentsLayersHandler(models, handler, funcName)
          ...
          ...
          if isIndex(value) then
            handler[funcName](handler, nil, parentPath .. name ..".index", false)
          else
            handler[funcName](handler, nil, parentPath .. name, false)
          end
          if value.class then
            for k, class in pairs(value.class) do
                -- print("", class, parentPath .. name)
                if class:len() > 0 then
                  table.insert(classEntries, {
                      class = class,
                      path = parentPath .. name  -- see sceneHandler.lua, it splits to load layer_linear.lua by split('.')
                  })
                  handler[funcName](handler, class, parentPath .. name, false)
                end
            end
          end
    ```

    controller/sceneHandler.lua setMod and _create

    ```lua
    function M:setMod(class, layer, suffix)
      local fileName = layer
      local classOption = {}
      if class then
        -- print(type(class))
        classOption = class:split('.')
        fileName = layer .."_"..classOption[1]
      end
      if suffix then
        fileName = fileName..suffix
      end
      --print("components."..self.UI.page.."."..fileName)
      self.mod = require("App."..self.UI.props.appName..".components."..self.UI.page..".layers."..fileName)
      self.mod.classOption = classOption[2]
    end

    function M:_create(class, layer, suffix)
      self:setMod(class, layer, suffix)
      -- dummy is pageCurl UI creation
      if self.mod.create and (self.dummy == nil or typesForPageCurl[class])  then
        self.mod:create(self.UI)
      end
    end
    ```