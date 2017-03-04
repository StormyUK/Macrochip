require "/scripts/vec2.lua"
require "/scripts/rect.lua"
require "/scripts/Storm_UI/hobo.lua"
require "/scripts/Storm_UI/table.lua"
require "/scripts/Storm_UI/mouse.lua"
require "/scripts/Storm_UI/keyboard.lua"
require "/scripts/Storm_UI/util.lua"

SUI = {
  table = SUI and SUI.table or {},
  screen = {},
  focus = ""
}

function SUI.addElement(name,data)
  if not SUI.screen[self.screen] then
    SUI.screen[self.screen] = { element = {},parts = {} }
  elseif not SUI.screen[self.screen].element then
    SUI.screen[self.screen].element = {}
    SUI.screen[self.screen].parts = {}
  end

  local screen = SUI.screen[self.screen]

  -- element information
  screen.element[name] = {
    parent = data.parent,
    visible = data.visible or (type(data.visible) == "nil" and true),
    zLevel = data.zLevel or 1,
    pos = data.pos or {0,0},
    offset = data.offset or {0,0},
    scale = data.scale or 1,
    centered = data.centered or false,
    totalpages = data.totalpages,
      page = data.page,
      notpage = data.notpage,
      currentpage = data.currentpage,
    mouseOver = data.mouseOver,
    inactive = data.inactive,
    selected = data.selected,
      selectPeers = data.selectPeers,
    selectedFrame = data.selectedFrame,
    alternate = data.alternate,
    window = data.window,
    selection = data.selection,
    sounds = data.sounds,
    entry = data.entry,
    maxLength = data.maxLength,  -- for textfields
    draggable = data.draggable
  }

  if data.parent then
    local parent = screen.element[data.parent]
    if not parent.children then parent.children = {} end
    table.insert(parent.children,name)
  end

  -- element images
  if data.images then
    for i in pairs(data.images) do
      table.insert(screen.parts,1,data.images[i])
      screen.parts[1].elementName = name
      if not data.images[i].pos then screen.parts[1].pos = {0,0} end
      if not data.images[i].offset then screen.parts[1].offset = {0,0} end
    end
  end

  -- element texts
  if data.texts then
    for t in pairs(data.texts) do
      table.insert(screen.parts,1,data.texts[t])
      screen.parts[1].elementName = name
      if not data.texts[t].pos then screen.parts[1].pos = {0,0} end
      if not data.texts[t].offset then screen.parts[1].offset = {0,0} end
    end
  end
end

function SUI.setScreen(name)
  local screen = SUI.screen[name]
  table.sort(SUI.screen[name].parts,function(a,b)
    if screen.element[a.elementName].zLevel < screen.element[b.elementName].zLevel then
      return screen.element[a.elementName].zLevel < screen.element[b.elementName].zLevel
    elseif screen.element[a.elementName].zLevel == screen.element[b.elementName].zLevel then
      return a.zLevel < b.zLevel
    end
  end)
end

function SUI.drawScreen(name)
  local screen = SUI.screen[name]

  for en in pairs(screen.element) do
    local element = screen.element[en]

    -- element visible only if its parent is
    if element.parent then
      parent = screen.element[element.parent]
      if not parent.visible then element.visible = false end
    end

    -- if tied to another selectable element
    if element.selection then
      tied = screen.element[element.selection]
      if tied and not tied.selected then element.visible = false end
    end

    -- make element non-visible if it is not on its parents current page
    if element.page then
      local parent = screen.element[element.parent]
      --sb.logInfo("checking parent of "..en.." = '"..element.parent.."'")
      if type(element.page) == "number" then
        if parent.currentpage == element.page then
          element.visible = parent.visible
        else
          element.visible = false
        end
      else -- its a table of pages
        for page in ipairs(element.page) do
          if parent.currentpage == element.page[page] then
            element.visible = parent.visible
            break
          else
            element.visible = false
          end
        end
      end
    elseif element.notpage then
      local parent = screen.element[element.parent]
      if type(element.notpage) == "number" then
        if parent.currentpage ~= element.notpage then
          element.visible = parent.visible
        else
          element.visible = false
        end
      else -- its a table of pages
        for page in ipairs(element.notpage) do
          if parent.currentpage ~= element.notpage[page] then
            element.visible = parent.visible
            break
          else
            element.visible = false
          end
        end
      end
    end
  end

  for i in ipairs(screen.parts) do
    if screen.element[screen.parts[i].elementName].visible then
      if not screen.parts[i].text then
        SUI.drawImage(screen.parts[i])
      else
        SUI.drawText(screen.parts[i])
      end
    end
  end
  SUI.getFocus(name)
end

function SUI.drawImage(image)
  local element = SUI.screen[self.screen].element[image.elementName]
  local png,scale,pngEnd = image.png,element.scale * (image.scale or 1),""
  local pos = vec2.add(element.pos,element.offset)

  if not png then return end

  if element.parent then
    local parent = SUI.screen[self.screen].element[element.parent]
    pos = vec2.add(pos,vec2.add(parent.pos,parent.offset))
  end

  if image.hover and SUI.focus == image.elementName then
    png = image.hover.png
    pos = vec2.add(pos,image.hover.offset)
  end

  if image.inactive and element.inactive == true then
    png = image.inactive.png
  end

  if image.frames and type(image.frames) == "table" then
    if image.frames.hover and SUI.focus == image.elementName then pngEnd = ":hover" end

    if image.frames["selected"] and element.selected then
      if not (SUI.pressed and element.selectPeers and SUI.table.contains(element.selectPeers,SUI.pressed)) then
        pngEnd = ":selected"
        if image.frames.selectedHover and SUI.focus == image.elementName then pngEnd = ":selectedHover" end
      end
    end

    if image.frames.inactive and element.inactive then pngEnd = ":inactive" end

    if SUI.pressed == image.elementName then
      if element.selected then
        if image.frames.hover then pngEnd = ":hover" end
      else
        if image.frames.selected then pngEnd = ":selected" end
        if image.frames.selectedHover then pngEnd = ":selectedHover" end
      end
    end
    if pngEnd == "" then pngEnd = ":default" end
    if element.alternate then pngEnd = pngEnd.."."..element.alternate end
  end

  if element.selectedFrame then pngEnd = ":"..element.selectedFrame end

  pos = vec2.add(pos,vec2.add(image.pos,image.offset))

  if image.pressedOffset and SUI.pressed == image.elementName then pos = vec2.add(pos,image.pressedOffset) end

  if not image.anim then
    if not image.centered and not image.source then
      console.canvasDrawImage(png..pngEnd,pos,scale)
    elseif image.centered and not image.source then
      console.canvasDrawImageCentered(png..pngEnd,pos,scale)
    else
      console.canvasDrawImageRect(png..pngEnd,image.source,rect.translate(image.dest,pos),image.color)
    end
  else
    local frames,size,fps,scale  = image.frames,image.size,image.fps,element.scale
    if image.anim == "bounce" then frames = (frames*2)-2 end
    local frame = math.floor((os.clock()*fps)%frames)
    if frame >= image.frames then frame = (image.frames-1) - (frame - (image.frames-1)) end -- for bounce adjusted frame number
    local source,dest = {size[1]*frame,0,(size[1]*frame)+size[1],size[2]},{pos[1],pos[2],pos[1]+(size[1]*scale),pos[2]+(size[2]*scale)}
    if image.centered then dest = {dest[1]-(size[1]*0.5*scale),dest[2]-(size[2]*0.5*scale),dest[3]-(size[1]*0.5*scale),dest[4]-(size[2]*0.5*scale)} end
     console.canvasDrawImageRect(png,source,dest,{255,255,255,255})
  end
end

function SUI.drawText(text)
  local element = SUI.screen[self.screen].element[text.elementName]
  local pos,Text,color = vec2.add(element.pos,element.offset),text.text,text.color

  -- Text offset?
  pos = vec2.add(pos,vec2.add(text.pos,text.offset))

  if text.pressedOffset and SUI.pressed == text.elementName then pos = vec2.add(pos,text.pressedOffset) end

  if element.parent then
    local parent = SUI.screen[self.screen].element[element.parent]
    pos = vec2.add(pos,vec2.add(parent.pos,parent.offset))
  end
  -- Text hover color?
  if text.hovercolor and SUI.focus == text.elementName then color = text.hovercolor end

  -- Any text additional args?
  args = { shadow = text.shadow,shadowOffset = text.shadowOffset,outline = text.outline,glow = text.glow }

  if element.entry and text.hint then
    if element.entry == "" then
      color,Text = text.hintcolor,text.hint
      if SUI.focus == text.elementName then color = text.hinthovercolor end
    else
      Text = element.entry
    end
  end

  if element.text then Text = element.text end

  hobo.drawText(Text,pos[1],pos[2],text.hAnchor,text.vAnchor,text.size,color,args)

  -- textfield cursor
  if SUI.editTextfield and SUI.editTextfield.field == text.elementName then
    if element.entry == "" then Text = "" else Text = element.entry:sub(0,SUI.editTextfield.cursorPos) end
    cursorflash = math.abs(math.sin(os.clock()*2))
    gray = string.format("%X",math.ceil(255*cursorflash))
    if string.len(gray) == 1 then gray = "0"..gray end
    cursorcolor = string.rep(gray,4)
    hobo.drawText("^#00000000;"..Text.."^#"..cursorcolor..";¦",pos[1],pos[2],text.hAnchor,text.vAnchor,text.size,"white",args)
  end

end

function SUI.getFocus(screen)
  local newFocus,zFocus = "",0

  for en in pairs(SUI.screen[screen].element) do
    local element = SUI.screen[screen].element[en]
    if element.visible and element.mouseOver and not element.inactive then
      local bounds = SUI.table.copy(element.mouseOver)
      local scale,offset,centered = element.scale,vec2.add(element.pos,element.offset),element.centered
      if element.parent then
        local parent = SUI.screen[screen].element[element.parent]
        offset = vec2.add(offset,vec2.add(parent.pos,parent.offset))
        scale = scale * parent.scale
        centered = parent.centered or centered
      end
      bounds[3],bounds[4] = bounds[3]*scale,bounds[4]*scale
      if centered then bounds = rect.translate(bounds,{-bounds[3]/2,-bounds[4]/2}) end
      bounds = rect.translate(bounds,offset)
      --[[
      console.canvasDrawRect({bounds[1],bounds[2],bounds[3],bounds[4]},{255,0,0,80})
      --]]
      if mouse.over(bounds) and element.zLevel > zFocus then
        newFocus,zFocus = en,element.zLevel
      end
    end
  end

  if newFocus ~= SUI.focus and zFocus ~= 0 then
    local element = SUI.screen[self.screen].element[newFocus]
    if element.sounds and element.sounds.hover then console.playSound(element.sounds.hover,0,1) end
  end

  SUI.focus = newFocus

  if SUI.pressed and SUI.pressed ~= SUI.focus then SUI.pressed = nil end
end

function SUI.elementExists(name)
  if SUI.screen[self.screen].element[name] then return true end
end

function SUI.isSelected(name)
  element = SUI.screen[self.screen].element[name]
  return element.selected
end

function SUI.selectElement(name)
  -- use for radio select
  --sb.logInfo("Selecting "..name)
  element = SUI.screen[self.screen].element[name]
  element.selected = true
  if element.window then SUI.showElement(element.window) end

  if element.selectPeers then -- selectPeers means only one of these elements can be selected at any time,so deselect the others
    for en in pairs(element.selectPeers) do
      local peerElement = SUI.screen[self.screen].element[element.selectPeers[en]]
      if peerElement then
        if peerElement.window then SUI.hideElement(peerElement.window) end
        peerElement.selected = false
      end
    end
  end

  if element.sounds and element.sounds.select then console.playSound(element.sounds.select,0,1) end
end

function SUI.toggleElement(name)
  element = SUI.screen[self.screen].element[name]
  element.selected = not element.selected
  if element.sounds and element.sounds.select and element.visible then console.playSound(element.sounds.select,0,1) end

  if element.window then
    if element.selected then SUI.showElement(element.window) else SUI.hideElement(element.window) end
  end

  if element.selected and element.selectPeers then -- only one of these elements can be selected at any time,so deselect the others
    -- note with toggleElement,all amongst these peers could be 'off'
    for en in pairs(element.selectPeers) do
      local peerElement = SUI.screen[self.screen].element[element.selectPeers[en]]
      if peerElement then
        if peerElement.window then SUI.hideElement(peerElement.window) end
        peerElement.selected = false
      end
    end
  end

  return element.selected
end

function SUI.showElement(name)
  --sb.logInfo("Showing "..name)
  if SUI.screen[self.screen].element[name].visible  then return end -- already visible

  for en in pairs(SUI.screen[self.screen].element) do
    local element = SUI.screen[self.screen].element[en]
    if en == name then
      element.visible = true
      if element.sounds and element.sounds.show then console.playSound(element.sounds.show,0,1) end
    end
    if element.parent then
      if element.parent == name then element.visible = true end
    end
  end
end

function SUI.hideElement(name)
  --sb.logInfo("Hiding "..name)
  if not SUI.screen[self.screen].element[name].visible then return end -- already hidden

  for en in pairs(SUI.screen[self.screen].element) do
    local element = SUI.screen[self.screen].element[en]
    if en == name then
      element.visible = false
        if element.sounds and element.sounds.hide then console.playSound(element.sounds.hide,0,1) end
      end
    if element.parent then
      if element.parent == name then element.visible = false end
    end
  end
end

function SUI.removeElement(name,screen)
  SUI.screen[self.screen].element[name] = nil
  for en in pairs(SUI.screen[self.screen].element) do
    local element = SUI.screen[self.screen].element[en]
    if element.parent == name then SUI.screen[self.screen].element[en] = nil end
  end
end

function SUI.typeTextfield(screen,key,shift,caps,accepts)
  local accepts = accepts or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.,-+:;!?()"
  local field = SUI.editTextfield.field
  local entry = SUI.screen[screen].element[field].entry
  local maxLength = SUI.screen[screen].element[field].maxLength or 18

  if key == "backspace" and SUI.editTextfield.cursorPos > 0 then
    cursorPos = SUI.editTextfield.cursorPos
    entry = entry:sub(0,cursorPos-1)..entry:sub(cursorPos+1)
    SUI.editTextfield.cursorPos = cursorPos-1
  end

  if key == "delete" then
    cursorPos = SUI.editTextfield.cursorPos
    entry = entry:sub(0,cursorPos)..entry:sub(cursorPos+2)
  end

  if string.find(accepts,key,1,true) and string.len(key) == 1 and string.len(entry) < maxLength then
    if not shift and caps then
      key = string.upper(key)
    elseif shift and caps then
      key = string.lower(key)
    end
    local cursorPos = SUI.editTextfield.cursorPos
    entry = entry:sub(0,cursorPos)..key..entry:sub(cursorPos+1)
    SUI.editTextfield.cursorPos = cursorPos+1
  end

  SUI.screen[screen].element[field].entry = entry
  if string.gsub(entry," ","") == "" and (key == "return" or key == "enter") then
    SUI.screen[screen].element[field].entry = ""
    SUI.editTextfield = nil
    return ""
  elseif entry ~= ""  and (key == "return" or key == "enter") then
    local entered = entry:match("^%s*(.-)%s*$")
    SUI.screen[screen].element[field].entry = ""
    SUI.editTextfield = nil
    return entered
  end
end

