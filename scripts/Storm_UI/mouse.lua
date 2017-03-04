mouse = {clickEvent = {}}

function mouse.position()
  mouse.x, mouse.y = console.canvasMousePosition()[1], console.canvasMousePosition()[2]
end

function mouse.over(rect)
  -- check if mouse pointer is over rectangle {x,y,x2,y2} corner to corner opposite diagonally
  mouse.position()
  return (mouse.x >= rect[1] and mouse.x <= rect[3])
     and (mouse.y >= rect[2] and mouse.y <= rect[4])
end

function mouse.inPoly(poly)
  local point = console.canvasMousePosition()
  local oddNodes = false
  local j = #poly 
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

function mouse.clickevent(position,button,buttonDown)
  if button == 0 then
    if buttonDown == true then
    
    else
    
    end
  elseif button == 1 then
    if buttonDown == true then
    
    else
    
    end  
  end
end