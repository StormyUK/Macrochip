--[[ EXAMPLE SPRITE

  SUI.addSprite("sprite name", {
    pos = {0,0}, zLevel = 1, scale = 1,
    alias = "alias name", stance = "idle",
    images = {
               {
                 png = "/path/image1.png", offset = {0,0}, centered = true, scale = 1, zLevel = 1,
               },
               {
                 png = "/path/image2.png", offset = {0,0}, centered = true, scale = 2, zLevel = 2,
                 anim = "loop", frames = 6, fps = 20, size = {16,16}, timer = 0,
                 animSounds = { -- frame(s) on which to play the designated sfx (.ogg, pitch, volume)
                                [3] = {"/path/sound.ogg", 0, 1}
                              }
               },
               {
                 png = "/path/image3.png", offset = {0,0}, centered = true, scale = 1, zLevel = 3,
                 anim = "spritesheet", timer = 0,
                 spritesheet = {
                                 ["idle"] = { frames = 6, mode = "loop", fps = 10 } }
                               },
                 animSounds =  {
                                 ["idle"] = { -- frame(s) of this stance to play the designated sound effects .ogg, pitch, volume
                                              [2] = {"/path/sound.ogg", 0, 1}
                                              [5] = {"/path/sound2.ogg", 0, 1}
                                            }
                               }
                            
               }
             }
    })
    
]]

-- current available anim types: "loop", "reverseloop", "bounce"

function SUI.addSprite(name,data)
  if not SUI.screen[self.screen] then
    SUI.screen[self.screen] = { spriteData = {}, sprite = {} }
  elseif not SUI.screen[self.screen].spriteData then
    SUI.screen[self.screen].spriteData = {}  
    SUI.screen[self.screen].sprite = {}    
  end

  local screen = SUI.screen[self.screen]
  screen.spriteData[name] = { 
    zLevel = data.zLevel or 1, pos = data.pos or {0,0}, scale = data.scale or 1, hitbox = data.hitbox,
    stance = data.stance, timeOffset = 0
  }

  -- sprite images
  if data.images then
    for i in ipairs(data.images) do
      table.insert(screen.sprite, 1, data.images[i])
      screen.sprite[1].spriteName = name
    end
  end
  
  -- sprite texts
  if data.texts then
    for t in ipairs(data.texts) do
      table.insert(screen.sprite, 1, data.texts[t])
      screen.sprite[1].spriteName = name
    end
  end
end

function SUI.drawSprites(name,dt)
  local screen = SUI.screen[name]
   
  -- order sprite images for each zLevel from lower left screen > upper right screen and draw them
  table.sort(screen.sprite, function(a,b)
    local spriteDataA, spriteDataB = screen.spriteData[a.spriteName], screen.spriteData[b.spriteName]
    if spriteDataA.zLevel < spriteDataB.zLevel then
      return spriteDataA.zLevel < spriteDataB.zLevel
    elseif spriteDataA.zLevel == spriteDataB.zLevel then
      if not a.offset then a.offset = {0,0} end
      local posA = {spriteDataA.pos[1] + a.offset[1], spriteDataA.pos[2] + a.offset[2]}
      if a.centered then posA = {posA[1] - (a.size[1]*(a.scale*spriteDataA.scale)/2), posA[2] - (a.size[2]*(a.scale*spriteDataA.scale)/2)} end
      if not b.offset then b.offset = {0,0} end
      local posB = {spriteDataB.pos[1] + b.offset[1], spriteDataB.pos[2] + b.offset[2]}   
      if a.centered then posA = {posA[1] - (a.size[1]*(a.scale*spriteDataB.scale)/2), posA[2] - (b.size[2]*(b.scale*spriteDataB.scale)/2)} end
      return posA[2] > posB[2] or posA[2] == posB[2] and posA[1] < posB[1]
    end
  end)

  for s in ipairs(screen.sprite) do
    --sb.logInfo(s.." = "..table.dump(screen.sprite[s].text) or false)
    drawSprite(s,dt)
  end
   
end

function drawSprite(s,dt)
  local sprite = SUI.screen[self.screen].sprite[s]
  local spriteData = SUI.screen[self.screen].spriteData[sprite.spriteName]
  
  if sprite.text then drawSpriteText(s,dt) return end
  
  if sprite.png then
    local scale = sprite.scale * spriteData.scale
    local pos = {spriteData.pos[1]+sprite.offset[1], spriteData.pos[2]+sprite.offset[2]}
    
    if not sprite.anim then
      if sprite.centered then
        console.canvasDrawImageCentered(sprite.png, pos, scale)
      else
        console.canvasDrawImage(sprite.png, pos, scale)
      end
    else
    
      if (sprite.anim == "loop" or sprite.anim == "reverseloop" or sprite.anim == "bounce") then
        local frames, fps = sprite.frames, sprite.fps
        if sprite.anim == "bounce" then frames = (frames*2)-2 end
        local frame = math.floor(((os.clock()+spriteData.timeOffset)*fps)%frames)
        if sprite.anim == "reverseloop" then frame = frames-(frame+1) end
        if frame >= frames then frame = (frames-1) - (frame - (frames-1)) end -- for bounce adjusted frame number
        if sprite.centered then
          console.canvasDrawImageCentered(sprite.png..":default."..frame+1, pos, scale)
        else
          console.canvasDrawImage(sprite.png..":default."..frame+1, pos, scale)
        end

        -- sfx
        if sprite.animSounds then
          if sprite.animSounds[frame] then
            local sound, duration, lastplayed = sprite.animSounds[frame].sound, sprite.animSounds[frame].duration, sprite.animSounds[frame].lastplayed
            if lastplayed < duration then
              sprite.animSounds[frame].lastplayed = sprite.animSounds[frame].lastplayed + dt
            else
              sprite.animSounds[frame].lastplayed = 0
              console.playSound(sound[1],sound[2],sound[3])
            end
          end
        end
        
      elseif sprite.anim == "spritesheet" then
        -- spritesheet anims
        local stance = spirte.spritesheet[spriteData.stance]
        if (stance.mode == "loop" or stance.mode == "reverseloop" or stance.mode == "bounce") then
          local frames, fps = stance.frames, stance.fps
          if stance.mode == "bounce" then frames = (frames*2)-2 end
          local frame = math.floor(((os.clock()+spriteData.timeOffset)*fps)%frames)
          if stance.mode == "reverseloop" then frame = frames-(frame+1) end
          if frame >= frames then frame = (sprite.frames-1) - (frame - (sprite.frames-1)) end -- for bounce adjusted frame number
          if sprite.centered then
            console.canvasDrawImageCentered(sprite.png..":default."..frame+1, pos, scale)
          else
            console.canvasDrawImage(sprite.png..":default."..frame+1, pos, scale)
          end
        end
        
        -- sfx
        if sprite.animSounds then
          if sprite.animSounds[stance] then
            if sprite.animSounds[stance][frame] then
              local sound, duration, lastplayed = sprite.animSounds[stance][frame].sound, sprite.animSounds[stance][frame].duration, sprite.animSounds[stance][frame].lastplayed
              if lastplayed < duration then
                sprite.animSounds[stance][frame].lastplayed = sprite.animSounds[stance][frame].lastplayed + dt
              else
                sprite.animSounds[stance][frame].lastplayed = 0
                console.playSound(sound[1],sound[2],sound[3])
              end
            end
          end
        end
        
      elseif not SUI.table.contains({"loop","reverseloop","bounce","spritesheet"},sprite.anim) then
       --sb.logInfo("*Storm_UI sprites.lua: Unknown sprite anim type: SUI.screen["..screen.."] spriteName "..screen.sprite[s].spriteName)
      end
      
    end
  end

end

function setSpriteStance(sprite,stance)
  local sprite = SUI.screen[self.screen].sprite[s]
  local spriteData = SUI.screen[self.screen].spriteData[sprite.spriteName]
  
end

function drawSpriteText(s,dt)
  local spriteText = SUI.screen[self.screen].sprite[s]
  local spriteData = SUI.screen[self.screen].spriteData[spriteText.spriteName]
  if not spriteData.offset then spriteData.offset = {0,0} end
  local pos, color = vec2.add(spriteData.pos,spriteData.offset), spriteText.color
  
  -- Text offset?
  if not spriteText.offset then spriteText.offset = {0,0} end
  pos = vec2.add(pos,spriteText.offset)
  
  -- Any text additional args?
  args = { shadow = spriteText.shadow, shadowOffset = spriteText.shadowOffset,
           outline = spriteText.outline, glow = spriteText.glow }

  hobo.drawText(spriteText.text,pos[1],pos[2],spriteText.hAnchor,spriteText.vAnchor,spriteText.size,color,args)
end