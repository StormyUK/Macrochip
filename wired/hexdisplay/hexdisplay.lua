function init(args)
  if virtual == false then return end
  if not storage.color then
    storage.color = 1
    animator.setGlobalTag("col","blue")
  end
  object.setInteractive(not object.isInputNodeConnected(0) and not object.isInputNodeConnected(1) and
      not object.isInputNodeConnected(2) and not object.isInputNodeConnected(3) and not object.isInputNodeConnected(4))
  self.currentDisplay = i(3)..i(2)..i(1)..i(0)
  self.change = 0
  setDisplay()
end

function onInteraction()
  storage.color = storage.color + 1
  if storage.color == 6 then storage.color = 1 end
  onInputNodeChange()
end

---[[
function update(dt)
  if self.change == 0 then
    setDisplay()
  else
    self.change = self.change -1
  end
end
--]]

function onNodeConnectionChange(args)
  object.setInteractive(not object.isInputNodeConnected(0) and not object.isInputNodeConnected(1) and
      not object.isInputNodeConnected(2) and not object.isInputNodeConnected(3) and not object.isInputNodeConnected(4))
  self.currentDisplay = i(3)..i(2)..i(1)..i(0)
  self.change = 5
  setDisplay()
end

function onInputNodeChange(args)
  self.currentDisplay = i(3)..i(2)..i(1)..i(0)
  self.change = 5
  setDisplay()
end

function setDisplay()
  if self.change > 0 then return end
  local colors = {"blue","red","green","yellow","purple"}
  if (not object.isInputNodeConnected(0) and not object.isInputNodeConnected(1) and
      not object.isInputNodeConnected(2) and not object.isInputNodeConnected(3))
      or (self.currentDisplay == "0000" and object.getInputNodeLevel(4) == true) then  
    animator.setGlobalTag("col",colors[storage.color])
    animator.setAnimationState("displayState","off")
  else  
    animator.setGlobalTag("col",colors[storage.color])
    animator.setAnimationState("displayState",self.currentDisplay)
  end
  self.change = 5
end

function i(node)
  if object.getInputNodeLevel(node) == true then return 1 else return 0 end
end