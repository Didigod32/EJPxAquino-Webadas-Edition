function onStepHit()
    if curStep == 367  then
     doTweenAlpha('hudout','camHUD',0,1)
    end
    if curStep == 383 then
        doTweenAlpha('hudin','camHUD',1,1)
        cameraFlash('game', 'FFFFFF', 1, false)
    end
    --if curStep == 255  then
    --    doTweenAlpha('HUDgone', 'camHUD', 0, 0.1, linear);
   -- end    
    if curStep == 128  then
        setProperty('defaultCamZoom', 0.9);
    end    
    if curStep == 192  then    
        setProperty('defaultCamZoom', 0.75);    
    end    
    if curStep == 208  then
        setProperty('defaultCamZoom', 0.9);
    end         
    if curStep == 224  then    
       setProperty('defaultCamZoom', 0.75);  
    end     
    if curStep == 239  then
        setProperty('defaultCamZoom', 0.9);           
    end
    if curStep == 255  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 718  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 735  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 752  then
        setProperty('defaultCamZoom', 0.8);
    end
    if curStep == 760  then
        setProperty('defaultCamZoom', 0.85);
    end
    if curStep == 767  then
        setProperty('defaultCamZoom', 0.75);
    end
end