local M = {}
--
function M:applyFilterTable(name, effect, UI)
  if effect then
     self.filterTable[name].set(effect)
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
  if self.animation then
    obj:addEventListener( "playFilterAnim", function()
      if not self.autoPlay then
        --
        if self.filter then
          self.effect = "filter."..self.effect
          obj.fill.effect = self.effect
          self:applyFilterTable(self.effect, obj.fill.effect)
        elseif self.generator then
          self.effect = "generator."..self.effect
          if self.effect == "generator.marchingAnts" then
            obj.strokeWidth = 2
            obj.stroke.effect = self.effect
          else
            obj.fill.effect = self.effect
          end
          self:applyFilterTable(self.effect, obj.fill.effect)
        else
          self.effect = "composite."..self.effect
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
function M:Destroy()
end

M.set = function(model)
  -- for k, v in pairs(model) do print(k, v) end
  return setmetatable(model, {__index = M})
end

return M