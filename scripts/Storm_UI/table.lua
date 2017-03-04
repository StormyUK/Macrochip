if not SUI then SUI = { table = {} } else SUI.table = {} end

function SUI.table.getIndex(t,val)
  for k,v in ipairs(t) do 
    if v == val then return k end
  end
  return -1
end

function SUI.table.compare(t1,t2)
  if t1 == t2 then return true end
  if type(t1) ~= type(t2) then return false end
  if type(t1) ~= "table" then return false end
  for k,v in pairs(t1) do
    if not SUI.table.compare(v, t2[k]) then return false end
  end
  for k,v in pairs(t2) do
    if not SUI.table.compare(v, t1[k]) then return false end
  end
  return true
end

function SUI.table.combine(first, second)
  for _,item in ipairs(second) do
    table.insert(first, item)
  end
  return first
end

function SUI.table.copy(orig)
  if type(orig) ~= "table" then
    return orig
  else
    local copy = {}
    for k,v in ipairs(orig) do
      copy[k] = SUI.table.copy(v)
    end
    return copy
  end
end

function SUI.table.deepcopy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for key, value in next, orig, nil do
      copy[SUI.table.deepcopy(key)] = SUI.table.deepcopy(value)
    end
    setmetatable(copy, SUI.table.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function SUI.table.reverse(t)
  local newTable = {}
  for key in ipairs(t) do
    table.insert(newTable,1,t[key])
  end
  return newTable
end

function SUI.table.contains(t, v1)
  for key,v2 in pairs(t) do
    if SUI.table.compare(v1, v2) then
      return key
    end
  end
  return false
end

function SUI.table.val_to_str(v)
  if type(v) == "string"  then
    v = string.gsub(v,"\n","\\n" )
    if string.match(string.gsub(v,"[^'\"]",""),'^"+$') then
      return "'"..v.."'"
    end
    return '"'..string.gsub(v,'"','\\"')..'"'
  else
    return "table" == type(v) and SUI.table.tostring(v) or tostring(v)
  end
end

function SUI.table.key_to_str(k)
  if type(k) == "string" and string.match(k,"^[_%a][_%a%d]*$") then
    return k
  else
    return "["..SUI.table.val_to_str(k).."]"
  end
end

function SUI.table.tostring(t)
  if t == nil then return "*nil*" end
  local result, done = {}, {}
  for k, v in ipairs(t) do
    table.insert(result,SUI.table.val_to_str(v))
    done[k] = true
  end
  for k, v in pairs(t) do
    if not done[k] then
      table.insert(result,SUI.table.key_to_str(k) .."="..SUI.table.val_to_str(v))
    end
  end
  result = result:gsub("%%","٪")
  return "{"..table.concat(result,",").."}"
end

function SUI.table.dump(value, indent, seen)
  if type(value) ~= "table" then
    if type(value) == "string" then
      return string.format('%q', value)
    else
      return tostring(value)
    end
  else
    if type(seen) ~= "table" then
      seen = {}
    elseif seen[value] then
      return "{...}"
    end
    seen[value] = true
    indent = indent or ""
    if next(value) == nil then
      return "{}"
    end
    local str = "{"
    local first = true
    for k,v in pairs(value) do
      if first then
        first = false
      else
        str = str..","
      end
      str = str.."\n"..indent.."  ".."["..SUI.table.dump(k, "", seen)
        .."] = "..SUI.table.dump(v, indent.."  ", seen)
    end
    str = (str.."\n"..indent.."}"):gsub("%%","٪")
    return str
  end
end

function SUI.table.jsondump(value)
  if type(value) ~= "table" then
    if type(value) == "string" then
      return string.format('%q', value)
    else
      return tostring(value)
    end
  else
    if next(value) == nil then
      return "{}"
    end
    local str = "{"
    local first = true
    for k,v in pairs(value) do
      if first then
        first = false
      else
        str = str..","
      end
      if type(k) == "number" then str = str..SUI.table.jsondump(v)
      else str = str..SUI.table.jsondump(k)..":"..SUI.table.jsondump(v)
      end
    end
    str = (str.."}"):gsub("%%","٪")
    return str
  end
end

function SUI.table.destring(t)
  -- somewhat hacky fix for those tables that have stringified numeric keys
  local revised = {}
  for key in pairs(t) do
    table.insert(revised,t[key])  
  end
  return revised
end