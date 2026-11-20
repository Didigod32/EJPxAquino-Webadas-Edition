local camSpeed = 16 -- 16 = cada compás, 8 = cada 2 beats, 4 = cada beat, 1 = cada step
local camInt = 0.5    -- Multiplicador de intensidad

function onStepHit()

    if curStep == 128 then
        camSpeed = 8 
        camInt = 1.2  
        
    elseif curStep == 384 then
        camSpeed = 16 
        camInt = 1.25  
        
    elseif curStep == 512 then
        camSpeed = 8
        camInt = 1.05 
        
    elseif curStep == 768 then

        camSpeed = 16
        camInt = 1.0
    elseif curStep == 1022 then
        camSpeed = 16
        camInt = 0.1
    elseif curStep == 1120 then
        camSpeed = 16
        camInt = 1.1 
    elseif curStep == 1152 then
        camSpeed = 8
        camInt = 1.25
    elseif curStep == 1280 then
        camSpeed = 16
        camInt = 0.95
    end 

    if curStep % camSpeed == 0 then
        -- Verificamos el zoom actual de la cámara del juego
        if getProperty('camGame.zoom') < 1.35 and cameraZoomOnBeat then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015 * camInt)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03 * camInt)
        end
    end
end