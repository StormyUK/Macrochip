require "/scripts/poly.lua"

function createClass(...)
  local class, bases = {}, {...}

  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      class[k] = v
    end
  end

  class.__index, class.is_a = class, {[class] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      class.is_a[c] = true
    end
    class.is_a[base] = true
  end

  setmetatable(class,{
      __call = function (c, ...)
        local instance = setmetatable({}, c)
        instance = Binding.proxy(instance)

        local init = instance._init
        if init then init(instance, ...) end
        return instance
      end
  })

  return class
end

-- additional rectangle functions

function rect.overlap(rectangle,second_rectangle)
  -- check for overlap of two rectangular areas, each given as {x,y,width,height}
  return rectangle[1] <= second_rectangle[1]+second_rectangle[3]
     and rectangle[1]+rectangle[3] >= second_rectangle[1]
     and rectangle[2] <= second_rectangle[2]+second_rectangle[4]
     and rectangle[2]+rectangle[4] >= second_rectangle[2]
end

-- triangle functions

tri = {}

function tri.contains(tri,point)
  -- check if triangle {{x,y},{x,y},{x,y}} contains point {x,y}
  local A, sign = (-tri[1][2] * tri[1][1] + tri[1][2] * (-tri[1][1] + tri[1][1]) + tri[1][1] * (tri[1][2] - tri[1][2]) + tri[1][1] * tri[1][2]) * 0.5, 1
  if A < 0 then sign = -1 end
  local s = (tri[1][2] * tri[1][1] - tri[1][1] * tri[1][2] + (tri[1][2] - tri[1][2]) * point[1] + (tri[1][1] - tri[1][1]) * point[2]) * sign
  local t = (tri[1][1] * tri[1][2] - tri[1][2] * tri[1][1] + (tri[1][2] - tri[1][2]) * point[1] + (tri[1][1] - tri[1][1]) * point[2]) * sign
  return s > 0 and t > 0 and (s + t) < 2 * A * sign
end

-- poly functions

function poly.contains(poly,point)
  local j = #poly
  local oddNodes = false
 
  for i=1, #poly do
    if ((poly[i][2] < point[2] and poly[j][2] >= point[2]
      or poly[j][2] < point[2] and poly[i][2] >= point[2])
      and (poly[i][1] <= point[1] or poly[j][1] <= point[1])) then
        if (poly[i][1]+(point[2]-poly[i][2])/(poly[j][2]-poly[i][2])*(poly[j][1]-poly[i][1])<point[1]) then
          oddNodes = not oddNodes
        end
    end
    j = i
  end
  return oddNodes
end

-- math functions

function math.loop(value,minimum,maximum)
  local p = maximum-minimum+1
  local mod = (value-minimum) % p
  if mod < 0 then mod = mod + p end
  return minimum+mod
end

function math.wrap(value,minimum,maximum)
  if value < minimum then return maximum end
  if value > maximum then return minimum end
  return value
end

function math.clamp(value,minimum,maximum)
  return math.max(minimum, math.min(value, maximum))
end
