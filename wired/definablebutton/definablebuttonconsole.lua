-- GUI scripts
require "/scripts/Storm_UI/stormGUI.lua"
require "/scripts/Storm_UI/hobo.lua"
require "/scripts/Storm_UI/table.lua"
require "/scripts/Storm_UI/mouse.lua"
require "/scripts/Storm_UI/keyboard.lua"

function init()
  initMain()
  self.colors = {"red","green","blue","orange","purple","yellow","grey","lightgrey"}
  self.decals = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                 "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                 "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                 "U", "V", "W", "X", "Y", "Z", "space", "square", "smallsquare", "dot",
                 "plus", "minus", "mult", "div", "equal", "ques", "exclam", "stop", "circle", "filledcircle",
                 "up", "down", "left", "right", "NW", "NE", "SW", "SE", "symb", "oddsymb"}
  self.decalColors = {"FFFFFF","BB0000","00FF00","6699FF","FFFF00","000000"}
  self.defineOn = true
end

function initMain()
  self.screen = "main"
  SUI.addElement("button",{
    zLevel = 1, pos = {54,145},
    images = {
               { png = "/objects/wired/chips/console/options/radiobutton.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 zLevel = 1 }
             },
    selectPeers = {"switch"},
    mouseOver = {0, 0, 9, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("switch",{
    zLevel = 1, pos = {105,145},
    images = {
               { png = "/objects/wired/chips/console/options/radiobutton.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 zLevel = 1 }
             },
    selectPeers = {"button"},
    mouseOver = {0, 0, 9, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("activeLeft",{
    zLevel = 1, pos = {85,133},
    images = {
               { png = "/objects/wired/definablebutton/pickleft.png",
                 frames = { hover = true, selected = true, inactive = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 8, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })
  SUI.addElement("activeRight",{
    zLevel = 1, pos = {146,133},
    images = {
               { png = "/objects/wired/definablebutton/pickright.png",
                 frames = { hover = true, selected = true, inactive = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 8, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })
  SUI.addElement("depressLeft",{
    zLevel = 1, pos = {85,121},
    images = {
               { png = "/objects/wired/definablebutton/pickleft.png",
                 frames = { hover = true, selected = true, inactive = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 8, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })
  SUI.addElement("depressRight",{
    zLevel = 1, pos = {146,121},
    images = {
               { png = "/objects/wired/definablebutton/pickright.png",
                 frames = { hover = true, selected = true, inactive = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 8, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })
  SUI.addElement("colors",{
    zLevel = 1, pos = {60,105}, mouseOver = {1, 0, 97, 12}
  })
  SUI.addElement("decals",{
    zLevel = 1, pos = {60,33}, mouseOver = {1, 0, 121, 72}
  })
  SUI.addElement("decalColors",{
    zLevel = 1, pos = {60,20}, mouseOver = {1, 0, 73, 12}
  })
  SUI.addElement("defineOnOff",{
    zLevel = 1, pos = {10,33}, mouseOver = {0, 0, 24, 50}
  })
  SUI.addElement("linked",{
    zLevel = 1, pos = {40,44},
    images = {
               { png = "/objects/wired/definablebutton/linked.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 zLevel = 1 }
             },
    mouseOver = {0, 0, 8, 25},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("lit",{
    zLevel = 1, pos = {163,22},
    images = {
               { png = "/objects/wired/chips/console/options/checkbox.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 9, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("litOff",{
    zLevel = 1, pos = {163,22},
    images = {
               { png = "/objects/wired/chips/console/options/checkbox.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 pressedOffset = {1,-1}, zLevel = 1 }
             },
    visible = false,
    mouseOver = {0, 0, 9, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("sound",{
    zLevel = 1, pos = {102,6},
    images = {
               { png = "/objects/wired/chips/console/options/checkbox.png",
                 frames = { hover = true, selected = true, selectedHover = true },
                 pressedOffset = {1,-1}, zLevel = 1 }
             },
    mouseOver = {0, 0, 9, 9},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg" }
  })
  SUI.addElement("accept",{
    zLevel = 1, pos = {16,3},
    images = {
               { png = "/objects/wired/chips/console/options/button.png",
                 frames = { hover = true, selected = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    texts = {
               { text = "ACCEPT", pos = {24,3}, hAnchor = "mid", vAnchor = "bottom",
                 size = 8, color = "white", shadow = "black", shadowOffset = {0,-1}, pressedOffset = {1,-1}, zLevel = 2 },
            },
    mouseOver = {0, 0, 47, 14},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })
  SUI.addElement("cancel",{
    zLevel = 1, pos = {123,3},
    images = {
               { png = "/objects/wired/chips/console/options/button.png",
                 frames = { hover = true, selected = true },
                 offset = {0,0}, pressedOffset = {1,-1}, zLevel = 1 }
             },
    texts = {
               { text = "CANCEL", pos = {24,3}, hAnchor = "mid", vAnchor = "bottom",
                 size = 8, color = "white", shadow = "black", shadowOffset = {0,-1}, pressedOffset = {1,-1}, zLevel = 2 },
            },
    mouseOver = {0, 0, 47, 14},
    sounds = { hover = "/sfx/interface/hoverover_bumb.ogg", select = "/sfx/interface/clickon_success.ogg" }
  })

  SUI.setScreen("main")
end

function update(dt)
  if not initialUpload() then return end
  SUI.drawScreen("main")

  -- active / depress duration
  if self.buttonBehaviour then
    hobo.drawText("Active Duration",7,133,"left","bottom",8,{180, 180, 180})
    hobo.drawText("Depress Duration",7,121,"left","bottom",8,{180, 180, 180})
    hobo.drawText(string.format("%.3f sec",self.active),139,133,"right","bottom",8,"white")
    hobo.drawText(string.format("%.3f sec",self.depress),139,121,"right","bottom",8,"white")
  else
    hobo.drawText("Active Duration",7,133,"left","bottom",8,{80, 80, 80})
    hobo.drawText("Depress Duration",7,121,"left","bottom",8,{80, 80, 80})
    hobo.drawText("N/A",127,133,"right","bottom",8,"darkgray")
    hobo.drawText("N/A",127,121,"right","bottom",8,"darkgray")
  end

  if self.defineOn then
    console.canvasDrawImage("/objects/wired/definablebutton/menu_colorsOn.png",{60,106},1)
  else
    console.canvasDrawImage("/objects/wired/definablebutton/menu_colorsOff.png",{60,106},1)
  end
  console.canvasDrawImage("/objects/wired/definablebutton/menu_decals.png",{60,33},1)

  -- color
  if SUI.focus == "colors" then
    local x = math.floor((console.canvasMousePosition()[1]-48)/12)
    x = math.max(1,math.min(x,8))
    console.canvasDrawImage("/objects/wired/definablebutton/selecthover.png",{48+(x*12),106},1)
  end
  console.canvasDrawImage("/objects/wired/definablebutton/selected.png",{48+(self.color*12),106},1)

  -- decal
  if SUI.focus == "decals" then
    local x,y = math.floor((console.canvasMousePosition()[1]-48)/12), -math.floor((console.canvasMousePosition()[2]-93)/12)
    x,y = math.max(1,math.min(x,10)), math.max(0,math.min(y,5))
    console.canvasDrawImage("/objects/wired/definablebutton/selecthover.png",{48+(x*12),93-(y*12)},1)
  end
  local x,y = (self.decal-1)%10,math.floor((self.decal-1)/10)
  console.canvasDrawImage("/objects/wired/definablebutton/selected.png",{60+(x*12),93-(y*12)},1)

  -- selected button style image
  if not self.defineLinked then
    hobo.drawText("On",36,70,"left","bottom",8,self.defineOn and "white" or "darkgray")
    hobo.drawText("Off",36,35,"left","bottom",8,self.defineOn and "darkgray" or "white")
    --hobo.drawText(SUI.focus.." = "..console.canvasMousePosition()[2],120,3,"left","bottom",8,{180, 180, 180})
    if SUI.focus == "defineOnOff" then
      local y = console.canvasMousePosition()[2] > 55
      console.canvasDrawImage("/objects/wired/definablebutton/large_selecthover.png",{10,y and 56 or 33},1)
    end
    console.canvasDrawImage("/objects/wired/definablebutton/large_selected.png",{10,self.defineOn and 56 or 33},1)
  else
    hobo.drawText("On",36,70,"left","bottom",8,{180, 180, 180})
    hobo.drawText("Off",36,35,"left","bottom",8,{180, 180, 180})
  end
  -- on
  console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.colors[self.color].."?flipxy",{14,60},2)
  console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.decals[self.decal].."?multiply="..self.decalColors[self.decalColor],{14,60},2)
  -- off
  console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.colors[self.colorOff].."?brightness=-30",{14,37},2)
  console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.decals[self.decalOff].."?multiply="..self.decalColors[self.decalColorOff].."?brightness=-30",{14,37},2)

  -- decal Color
  if SUI.focus == "decalColors" then
    local x = math.floor((console.canvasMousePosition()[1]-48)/12)
    x = math.max(1,math.min(x,6))
    console.canvasDrawImage("/objects/wired/definablebutton/selecthover.png",{48+(x*12),20},1)
  end
  if self.defineOn or self.defineLinked then
    for x = 1, 6 do
      local decalOn = "?multiply="..self.decalColors[x]
      console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.colors[self.color].."?flipxy",{50+(x*12),22},1)
      console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.decals[self.decal]..decalOn,{50+(x*12),22},1)
    end
    console.canvasDrawImage("/objects/wired/definablebutton/selected.png",{48+(self.decalColor*12),20},1)
  else
    for x = 1, 6 do
      local decalOff = "?brightness=-30?multiply="..self.decalColors[x]
      console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.colors[self.colorOff].."?brightness=-30",{50+(x*12),22},1)
      console.canvasDrawImage("/objects/wired/definablebutton/definablebutton.png:"..self.decals[self.decalOff]..decalOff,{50+(x*12),22},1)
    end
    console.canvasDrawImage("/objects/wired/definablebutton/selected.png",{48+(self.decalColorOff*12),20},1)
  end
end

function initialUpload()
  if self.uploadingInitialData == nil then
    getInitialData = world.sendEntityMessage(console.sourceEntity(), "uploadData")
    self.uploadingInitialData = getInitialData:succeeded()
    return false
  elseif not self.uploadingInitialData then
    self.uploadingInitialData = getInitialData:succeeded()
    return false
  elseif self.uploadingInitialData and self.dataLoaded == nil then
    loadData(getInitialData:result())
    self.dataLoaded = true
    return true
  else
    return true
  end
end

function loadData(data)
  for key in pairs(data) do
    self[key] = data[key]
  end
  SUI.selectElement(self.buttonBehaviour and "button" or "switch")
  SUI.screen["main"].element["lit"].selected = self.lit
  SUI.screen["main"].element["sound"].selected = self.sound
  if self.color == self.colorOff and self.decal == self.decalOff and self.decalColor == self.decalColorOff then
    self.defineOn, self.defineLinked = true, true
  else
    self.defineOn, self.defineLinked = true, false
  end
  SUI.screen["main"].element["linked"].selected = self.defineLinked
  SUI.screen["main"].element["depressLeft"].inactive = (self.depress == 0.125) or not self.buttonBehaviour
  SUI.screen["main"].element["depressRight"].inactive = (self.depress == 5) or not self.buttonBehaviour
  SUI.screen["main"].element["activeLeft"].inactive = (self.active == 0.125) or not self.buttonBehaviour
  SUI.screen["main"].element["activeRight"].inactive = (self.active == self.depress) or not self.buttonBehaviour
end

function canvasKeyEvent(key,isKeyDown)
  keyboard.keyEvent(key,isKeyDown)
end

function canvasClickEvent(pos,button,buttonDown)
  -- left mouse button pressed
  if button == 0 and buttonDown == true then
    if SUI.focus ~= "" then
      console.playSound("/sfx/interface/clickon_success.ogg", 0, 1)
      SUI.pressed = SUI.focus
      if SUI.focus == "colors" then
        local x = math.floor((console.canvasMousePosition()[1]-48)/12)
        x = math.max(1,math.min(x,8))
        if self.defineLinked then
          self.color, self.colorOff = x,x
        elseif self.defineOn then
          self.color = x
        else
          self.colorOff = x
        end

      elseif SUI.pressed == "decals" then
        local x,y = math.floor((console.canvasMousePosition()[1]-48)/12), -math.floor((console.canvasMousePosition()[2]-93)/12)
        x,y = math.max(1,math.min(x,10)), math.max(0,math.min(y,5))
        if self.defineLinked then
          self.decal = (y*10) + x
          self.decalOff = self.decal
        elseif self.defineOn then
          self.decal = (y*10) + x
        else
          self.decalOff = (y*10) + x
        end

      elseif SUI.focus == "decalColors" then
        local x = math.floor((console.canvasMousePosition()[1]-48)/12)
        x = math.max(1,math.min(x,6))
        if self.defineLinked then
          self.decalColor,self.decalColorOff = x,x
        elseif self.defineOn then
          self.decalColor = x
        else
          self.decalColorOff = x
        end
      end

    end

  -- left mouse button released
  elseif button == 0 and buttonDown == false and SUI.focus == SUI.pressed then

    if SUI.focus == "button" then
      self.buttonBehaviour = true
      SUI.selectElement("button")

    elseif SUI.focus == "switch" then
      self.buttonBehaviour = false
      SUI.selectElement("switch")

    elseif SUI.focus == "activeLeft" then
      self.active = math.max(0.125,self.active - 0.125)

    elseif SUI.focus == "activeRight" then
      self.active = math.min(self.depress,self.active + 0.125)

    elseif SUI.focus == "depressLeft" then
      self.depress = math.max(0.125,self.depress - 0.125)
      if self.depress < self.active then self.active = self.depress end

    elseif SUI.focus == "depressRight" then
      self.depress = math.min(5,self.depress + 0.125)

    elseif SUI.focus == "defineOnOff" and not self.defineLinked then
      local y = console.canvasMousePosition()[2] > 55
      self.defineOn = y
      SUI.screen["main"].element["lit"].visible = self.defineOn or self.defineLinked
      SUI.screen["main"].element["litOff"].visible = not self.defineOn and not self.defineLinked

    elseif SUI.focus == "linked" then
      self.defineLinked = SUI.toggleElement("linked")

    elseif SUI.focus == "accept" then
      world.sendEntityMessage(
        console.sourceEntity(), "defineButton",
        self.buttonBehaviour,
        self.active, self.depress,
        self.lit, self.color, self.decal, self.decalColor,
        self.litOff, self.colorOff, self.decalOff, self.decalColorOff,
        self.sound
      )
      console.dismiss()

    elseif SUI.focus == "cancel" then
      console.dismiss()

    elseif SUI.focus == "lit" or SUI.focus == "litOff" then
      if self.defineLinked then
        self.lit = SUI.toggleElement("lit")
        SUI.screen["main"].element["litOff"].selected = self.lit
        self.litOff = self.lit
      elseif self.defineOn then
        self.lit = SUI.toggleElement("lit")
      else
        self.litOff = SUI.toggleElement("litOff")
      end

    elseif SUI.focus == "sound" then
      self.sound = SUI.toggleElement("sound")
    end

    SUI.screen["main"].element["depressLeft"].inactive = (self.depress == 0.125) or not self.buttonBehaviour
    SUI.screen["main"].element["depressRight"].inactive = (self.depress == 5) or not self.buttonBehaviour
    SUI.screen["main"].element["activeLeft"].inactive = (self.active == 0.125) or not self.buttonBehaviour
    SUI.screen["main"].element["activeRight"].inactive = (self.active == self.depress) or not self.buttonBehaviour

    SUI.pressed = nil
  end
end

function keyboardEvent.main(key, shift, caps)
end

function dismiss()
end
