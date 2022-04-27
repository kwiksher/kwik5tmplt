-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
transition.callback = transition.to ;

function _copy(t)
    local new_table = {}
    for k,v in pairs(t) do
        if type(v) == "table" then
            new_table[k] = _copy(v)
        else
            new_table[k] = v
        end
    end
    return new_table
end

function makeDiff(from, to)
    local diff_table = {}
    for k, v in pairs(from) do
      if type(v) == "table" then  -- v = {0.1, 0.2. 0.3}
          diff_table[k] = makeDiff(v ,to[k])
      else
          diff_table[k] = to[k]-v
      end
    end
    return diff_table
end

function setEffect(from, diff_table, val)
  local value = {}
    for k, v in pairs(diff_table) do
         -- print(k)
        if type(v) == "table" then
          -- print("table:"..k)
          value[k] = setEffect(from[k], v, val)
        else
            -- print(k, from[k] + v*val)
            value[k] = from[k] + v*val
        end
    end
    return value
end


function transition.kwikFilter(obj, params)
  local _obj =  obj ;
  local ease = params.ease or easing.linear
  local time = params.time
  local delay = params.delay
  local complete = params.onComplete
  local loop = params.loop

  local from =   params.filterTable.get()
  params.filterTable.set(from)
  local to = params.filterTable.get()
  local diffTable = makeDiff(from, to)
  local t = nil ;
  local p = {} --hold parameters here
  --Set up proxy
  local proxy = {step = 0} ;
  local mt

  if( _obj and _obj.fill and _obj.fill.effect ) then
      mt = {
      __index = function(t,k)
        return t["step"]
      end,
      __newindex = function (t,k,v)
        -- print(k)
        if k=="_paused" then
          _obj.isPlay = false
        elseif k == "_resume" then
          _obj.isPlay = true
        else
          if(_obj.fill and _obj.fill.effect and _obj.isPlay) then
            local value = setEffect(from, diffTable, v)
            params.filterTable.set(_obj.fill.effect, value)
          end
          t["step"] = v ;
        end
      end
    }
  end
  p.iterations       = loop or 1
  p.time       = time or 1000 ; --defaults to 1 second
  p.delay      = delay or 0 ;
  p.transition = ease ;
  p.colorScale = 1 ;
  p.onComplete = complete;
  setmetatable(proxy,mt) ;
  _obj.isPlay = true
  t = transition.to(proxy,p , 1 )  ;
  return t
end