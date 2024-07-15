local M = {}
local json  = require ("json")
--
function M:applyFilterTable(name, effect, UI)
  print(name)
  if effect then
     self.filterTable[name].set(effect)

      -- effect.color1 = { 0.8, 0, 0.2, 1 }
      -- effect.color2 = { 0.2, 0.2, 0.2, 1 }
      -- effect.xStep = 8
      -- effect.yStep = 8

      print(json.encode(effect.color1))
      print(json.encode(effect.color2))
      print(effect.xStep)
      print(effect.yStep)

  else
    local param = {}
    if self.animation then
      param.time   = self.duration
      param.delay  = self.delay
      param.filterTable = self.filterTable[name]
      param.loop = self.loop
      -- param.effectTo = filterTable[name].get()
      -- param.effectFrom = {}
      -- filterTable[name].set(param.effectFrom)
      param.onComplete = function()
        if self.action.onComplete then
          Runtime:dispatchEvent({name=UI.page..self.action.onComplete, event={}, UI=UI})
        end
      end
    end
    return param
  end
end
--
function M:init()
end
--
function M:create(UI)
  local layer       = UI.layer
  local sceneGroup = UI.sceneGroup
  local obj = sceneGroup[self.layer]

  if obj == nil then return end

  if self.filter then
    self.effect = "filter."..self.filter.effect
  elseif self.generator then
    self.effect = "generator."..self.generator.effect
  else
    self.effect = "composite."..self.composite.effect
  end
  --
  if self.animation then
    obj:addEventListener( "playFilterAnim", function()
      if not self.autoPlay then
        --
        if self.filter then
          obj.fill.effect = self.effect
          self:applyFilterTable(self.effect, obj.fill.effect)
        elseif self.generator then
          if self.effect == "generator.marchingAnts" then
            obj.strokeWidth = 2
            obj.stroke.effect = self.effect
          else
            obj.fill.effect = self.effect
          end
          self:applyFilterTable(self.effect, obj.fill.effect)
        else
          local folder = UI.props.imgDir
          if self.composite.folder then
            folder = "App/"..UI.book "/assets/images/"..self.composite.folder
          end
          local compositePaint = {
            type="composite",
            paint1={ type="image", filename=folder..self.paint1, baseDir=UI.props.systemDir },
            paint2={ type="image", filename=folder..self.paint2, baseDir=UI.props.systemDir }
          }
          obj.fill = compositePaint
          obj.fill.effect = self.effect
          --
          if self.composite.name == "composite.normalMapWith1PointLight" or self.composite.name == "composite.normalMapWith1DirLight" then
            self:applyFilterTable(self.effect, obj.fill.effect)
          elseif self.composite then
            self:applyFilterTable(self.effect, obj.fill)
          end
        end
      end
      transition.kwikFilter(obj, self:applyFilterTable(self.effect, nil, UI) )
    end)
  end
end
--
function M:didShow(UI)
  local sceneGroup = UI.sceneGroup
  local obj = sceneGroup[self.layer]

--
  if self.autoPlay then
    if self.filter then
      obj.fill.effect = self.effect
      self:applyFilterTable(self.effect, obj.fill.effect)
      if self.animation then
        transition.kwikFilter(obj, self:applyFilterTable(self.effect, nil, UI) )
      end
    elseif self.generator then
      if self.generator.name == "generator.marchingAnts" then
        obj.strokeWidth = 2
        obj.stroke.effect = self.effect
      else
        obj.fill.effect = self.effect
      end
      self:applyFilterTable(self.effect, obj.fill.effect)
      if self.animation then
        transition.kwikFilter(obj, self:applyFilterTable(self.effect, nil, UI) )
      end
    else
      local folder = UI.props.imgDir
      if self.composite.folder then
        folder = "App/"..UI.book "/assets/images/"..self.composite.folder
      end
      local compositePaint = {
          type="composite",
          paint1={ type="image", filename=folder..self.paint1, baseDir=UI.props.systemDir },
          paint2={ type="image", filename=folder..self.paint2, baseDir=UI.props.systemDir }
      }
      obj.fill = compositePaint
      obj.fill.effect = self.effect

      if self.composite.name == "composite.normalMapWith1PointLight" or self.composite.name == "composite.normalMapWith1DirLight" then
        self:applyFilterTable(self.effect, obj.fill.effect)
        if self.animation then
            transition.kwikFilter(obj, self:applyFilterTable(self.effect, nil, UI) )
        end
      elseif self.composite then
        self:applyFilterTable(self.effect, obj.fill)
        if self.animation then
            local param = self:applyFilterTable(self.effect, nil, UI)
            transition.to(obj, {time = param.time, delay = param.delay, alpha = param.effect.alpha} )
        end
      end
    end
  end
end
--
function M:destroy()
end

M.set = function(props)
  -- for k, v in pairs(props) do print(k, v) end
  local layer_filterTable = require("editor.template.components.pageX.animation.layer_filterTable")

  local filterProps = require("editor.animation.filterProps")
  local basePropsControl = require("editor.parts.basePropsControl")
  local yaml = require("server.yaml")

    for k, v in pairs(props.from) do
    if filterProps.colorSet[k]  then
      print(v)
      local value = yaml.eval('[ '..v..' ]' )
      print(k, value[1], value[2], value[3], value[4])
      props.from[k] ={value[1]/255, value[2]/255, value[3]/255, value[4]}
    end
  end
  local instance = setmetatable( {to=props.to, from=props.from}, {__index=layer_filterTable} )
  props.filterTable = instance.filterTable
  return setmetatable(props, {__index = M})
end

return M