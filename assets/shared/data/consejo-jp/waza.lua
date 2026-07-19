local xx = 200;
local yy = 90;
local xx2 = 800;
local yy2 = 140;
local ofs = 25;
local followchars = true;
local del = 0;
local del2 = 0;

function onCreatePost()
   makeLuaSprite('UpperBar', 'empty', -110, -350)
   makeGraphic('UpperBar', 1500, 350, '000000')
   setObjectCamera('UpperBar', 'camHUD')
   addLuaSprite('UpperBar', false)

   makeLuaSprite('LowerBar', 'empty', -110, 720)
   makeGraphic('LowerBar', 1500, 350, '000000')
   setObjectCamera('LowerBar', 'camHUD')
   addLuaSprite('LowerBar', false)

   makeLuaSprite('negrooscuro', nil, -800, -1250)
   makeGraphic('negrooscuro', 5600, 5550, '000000')
   setProperty('negrooscuro.alpha', 1)
   addLuaSprite('negrooscuro', true)

   setProperty('camHUD.alpha', 0)
   setProperty('defaultCamZoom', 1.0)
   setProperty('camGame.zoom', 1.0) 
end

function onUpdate(elapsed)
   if del > 0 then
       del = del - 1
   end
   if del2 > 0 then
       del2 = del2 - 1
   end
   if followchars == true then
       if mustHitSection == false then

           if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
               triggerEvent('Camera Follow Pos',xx-ofs,yy)
           end
           if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
               triggerEvent('Camera Follow Pos',xx+ofs,yy)
           end
           if getProperty('dad.animation.curAnim.name') == 'singUP' then
               triggerEvent('Camera Follow Pos',xx,yy-ofs)
           end
           if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
               triggerEvent('Camera Follow Pos',xx,yy+ofs)
           end
           if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
               triggerEvent('Camera Follow Pos',xx-ofs,yy)
           end
           if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
               triggerEvent('Camera Follow Pos',xx+ofs,yy)
           end
           if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
               triggerEvent('Camera Follow Pos',xx,yy-ofs)
           end
           if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
               triggerEvent('Camera Follow Pos',xx,yy+ofs)
           end
           if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
               triggerEvent('Camera Follow Pos',xx,yy)
           end
           if getProperty('dad.animation.curAnim.name') == 'idle' then
               triggerEvent('Camera Follow Pos',xx,yy)
           end
       else

           if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
               triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
               triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
               triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
               triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singLEFTmiss' then
               triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHTmiss' then
               triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singUPmiss' then
               triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'singDOWNmiss' then
               triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'idle-alt' then
               triggerEvent('Camera Follow Pos',xx2,yy2)
           end
           if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
               triggerEvent('Camera Follow Pos',xx2,yy2)
           end
       end
   else
       triggerEvent('Camera Follow Pos','','')
  end
end

function onStepHit()
    if curStep == 2 then
    doTweenZoom('screenZoom', 'camGame', 0.75, 6.3, 'linear');
    doTweenAlpha('black', 'negrooscuro', 0, 6.0, 'linear')
    end
    if curStep == 32 then
    doTweenAlpha('a', 'camHUD', 1, 2.0, 'linear')
    end
    if curStep == 48 then
    doTweenY('UpperBar', 'UpperBar', -280, 1, 'QuadOut')
    doTweenY('LowerBar', 'LowerBar', 650, 1, 'QuadOut')
    end
    if curStep == 64 then
    setProperty('defaultCamZoom', 0.75)
    end
    if curStep == 128 then
    setProperty('defaultCamZoom', 0.7)
    setProperty('camGame.zoom', 0.7) 
    end
    if curStep == 176 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 184 then
    setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 187 then
    setProperty('defaultCamZoom', 0.95)
    end
    if curStep == 192 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 240 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 247 then
    setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 252 then
    setProperty('defaultCamZoom', 0.95)
    end
    if curStep == 256 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 288 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 304 then
    setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 311 then
    setProperty('defaultCamZoom', 0.95)
    end
    if curStep == 320 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 352 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 368 then
    setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 384 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 512 then
    setProperty('defaultCamZoom', 0.63)
    xx = 550
    yy = 90
    xx2 = 550
    yy2 = 90
   end
    if curStep == 640 then
    setProperty('defaultCamZoom', 0.75)
    xx = 200
    yy = 90
    xx2 = 800
    yy2 = 140
    end
    if curStep == 704 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 768 then
    setProperty('defaultCamZoom', 0.63)
    xx = 550
    yy = 90
    xx2 = 550
    yy2 = 90
    end
    if curStep == 896 then
    setProperty('negrooscuro.alpha', 1)
    setProperty('camHUD.alpha', 0)
    setProperty('defaultCamZoom', 0.75)
    xx = 200
    yy = 90
    xx2 = 800
    yy2 = 140
    end
    if curStep == 1024 then
    setProperty('negrooscuro.alpha', 0)
    setProperty('camHUD.alpha', 1)
    end
    if curStep == 1072 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 1088 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 1136 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 1152 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 1200 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 1216 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 1296 then
    setProperty('defaultCamZoom', 0.78)
    end
    if curStep == 1312 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 1328 then
    setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 1344 then
    setProperty('defaultCamZoom', 0.7)
    end
    if curStep == 1360 then
    setProperty('defaultCamZoom', 0.79)
    end
    if curStep == 1376 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 1378 then
    setProperty('defaultCamZoom', 0.81)
    end
    if curStep == 1380 then
    setProperty('defaultCamZoom', 0.82)
    end
    if curStep == 1382 then
    setProperty('defaultCamZoom', 0.83)
    end
    if curStep == 1384 then
    setProperty('defaultCamZoom', 0.84)
    end
    if curStep == 1386 then
    setProperty('defaultCamZoom', 0.85)
    end
    if curStep == 1388 then
    setProperty('defaultCamZoom', 0.86)
    end
    if curStep == 1390 then
    setProperty('defaultCamZoom', 0.87)
    end
    if curStep == 1392 then
    setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 1408 then
    setProperty('defaultCamZoom', 0.63)
    xx = 550
    yy = 90
    xx2 = 550
    yy2 = 90
    end
    if curStep == 1536 then
    setProperty('defaultCamZoom', 0.68)
    xx = 200
    yy = 90
    xx2 = 800
    yy2 = 140
    end
    if curStep == 1552 then
    doTweenAlpha('black', 'negrooscuro', 1, 9.5, 'linear')
    doTweenAlpha('hud', 'camHUD', 0, 9.5, 'linear')
    end
end