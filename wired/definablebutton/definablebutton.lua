function init()
  object.setInteractive(true)
  self.colors = {"red","green","blue","orange","purple","yellow","grey","lightgrey"}
  self.decals = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                 "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                 "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                 "U", "V", "W", "X", "Y", "Z", "space", "square", "smallsquare", "dot",
                 "plus", "minus", "mult", "div", "equal", "ques", "exclam", "stop", "circle", "filledcircle",
                 "up", "down", "left", "right", "NW", "NE", "SW", "SE", "symb", "oddsymb"}
  self.decalColors = {"FFFFFF","BB0000","00FF00","6699FF","FFFF00","000000"}
  if storage.state == nil then
    storage.buttonBehaviour = true
    storage.buttonColor, storage.decal = 1,46
    storage.buttonColorOff, storage.decalOff = 1,46
    storage.decalColor, storage.decalColorOff = 1,1
    storage.lit, storage.litOff = false, false
    storage.active, storage.depress = 1, 1
    storage.sound = true
  end
  if storage.sound == nil then
    storage.sound = true
  end

  storage.timer = 0

  -- define button
  message.setHandler("defineButton",
  function(_, _, buttonBehaviour, active, depress,
                 lit, color, decal, decalColor,
                 litOff, colorOff, decalOff, decalColorOff,
                 sound)
    storage.buttonBehaviour = buttonBehaviour
    storage.active, storage.depress = active, depress
    storage.lit, storage.buttonColor, storage.decal, storage.decalColor = lit, color, decal, decalColor
    storage.litOff, storage.buttonColorOff, storage.decalOff, storage.decalColorOff = litOff, colorOff, decalOff, decalColorOff
    storage.sound = sound
    storage.timer = 0
    setAppearance()
  end)

  -- data management
  message.setHandler("uploadData", function(_, _) return uploadData() end)

  setAppearance()
end

function update(dt)
  if not storage.buttonBehaviour then return end
  if storage.timer > 0 then
    storage.timer = storage.timer - dt
    if storage.timer <= storage.depress-storage.active then
      output(false)
    end
    if storage.timer <= 0 then
      animator.setAnimationState("switchState", "off"..(storage.litState and "_lit" or ""))
      storage.timer = 0
    end
  end
end

function onInteraction()
  if object.isOutputNodeConnected(0) then
    if storage.buttonBehaviour then
      if storage.state == false and storage.timer == 0 then
        output(true)
        if storage.sound then animator.playSound("on") end
        storage.timer = storage.depress
      end
    else
      output(not storage.state)
      if storage.sound then animator.playSound("on") end
    end
  else
    return {"ScriptConsole", GUIconfig()}
  end
end

function onNodeConnectionChange()
  if not object.isOutputNodeConnected(0) then
    storage.timer = 0
    output(false)
  end
end

function GUIconfig()
  local interactionConfig = {
    gui = {
      background = {
        zlevel = 0,
        type = "background",
        fileHeader = "/objects/wired/definablebutton/header.png",
        fileBody = "/objects/wired/definablebutton/body.png",
        fileFooter = "/objects/wired/definablebutton/footer.png"
      },
      scriptCanvas = {
        zlevel = 1,
        type = "canvas",
        rect = {1, 24, 185, 185},
        captureMouseEvents = true,
        captureKeyboardEvents = true
      },
      lblTitle = {
        type = "label",
        position = {93, 184}, hAnchor = "mid", vAnchor = "bottom",
        centered = true, fontSize = 14,
        value = "DEFINABLE BUTTON"
      },
      lblBehavior = {
        type = "label",
        position = {8, 169}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Behavior         Button         Switch"
      },
      lblColor = {
        type = "label",
        position = {8, 131}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Button Color"
      },
      lblDecal = {
        type = "label",
        position = {8, 118}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Decal Symbol"
      },
      lblEdit = {
        type = "label",
        position = {23, 105}, hAnchor = "mid", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Edit"
      },
      lblDecalColor = {
        type = "label",
        position = {8, 44}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Decal Color"
      },
      lblLit = {
        type = "label",
        position = {148, 46}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Lit"
      },
      lblSound = {
        type = "label",
        position = {75, 30}, hAnchor = "left", vAnchor = "bottom",
        color = {180, 180, 180},
        value = "Sound"
      }
    },
    scripts = {
      "/objects/wired/definablebutton/definablebuttonconsole.lua"
    },
    scriptDelta = 1,
    scriptCanvas = "scriptCanvas"
  }
  return interactionConfig
end

function uploadData()
  return {
    buttonBehaviour = storage.buttonBehaviour,
    active = storage.active, depress = storage.depress,
    lit = storage.lit, color = storage.buttonColor,
    decal = storage.decal, decalColor = storage.decalColor,
    litOff = storage.litOff, colorOff = storage.buttonColorOff,
    decalOff = storage.decalOff, decalColorOff = storage.decalColorOff,
    sound = storage.sound
  }
end

function setAppearance()
  animator.setGlobalTag("buttonColor",self.colors[storage.buttonColor])
  animator.setGlobalTag("decal",self.decals[storage.decal])
  animator.setGlobalTag("decalColor",self.decalColors[storage.decalColor])
  animator.setGlobalTag("buttonColorOff",self.colors[storage.buttonColorOff])
  animator.setGlobalTag("decalOff",self.decals[storage.decalOff])
  animator.setGlobalTag("decalColorOff",self.decalColors[storage.decalColorOff])
  local lit = (((storage.state or storage.timer > 0) and storage.lit) or (not storage.state and storage.litOff)) and "_lit" or ""
  animator.setAnimationState("switchState", ((storage.state or storage.timer > 0) and "on" or "off")..lit)
  output()
  if storage.state == nil then storage.state = false end
end

function output(state)
  if storage.state ~= state then
    if state ~= nil then storage.state = state else storage.state = false end
    object.setAllOutputNodes(state)
    local lit = (((storage.state or storage.timer > 0) and storage.lit) or (not storage.state and storage.litOff)) and "_lit" or ""
    animator.setAnimationState("switchState", ((storage.state or storage.timer > 0) and "on" or "off")..lit)
  end
end
