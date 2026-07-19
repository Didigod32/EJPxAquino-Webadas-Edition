local saltosActivos = false
local ladoActual = 1 


local stepInicio = 720
local stepFin = 846

local intensidadZoomGame = 0.06 -- Golpe fuerte para el escenario/personajes
local intensidadZoomHUD = 0.04 -- Golpe más suave para las flechas/interfaz

function onStepHit()

    if curStep == stepInicio then
        saltosActivos = true
    end

    if curStep == stepFin then
        saltosActivos = false
        
        for i = 0, 7 do
            local index = i
            if i > 3 then index = i - 4 end
            
            local isPlayer = (i > 3)
            local baseX = isPlayer and _G['defaultPlayerStrumX'..index] or _G['defaultOpponentStrumX'..index]
            
            -- Devolvemos la nota a su lugar (duración de 0.25 seg)
            noteTweenX('resetSalto'..i, i, baseX, 0.25, 'cubeOut')
        end
    end
end

function onBeatHit()
    if saltosActivos then
        local fuerzaSaltoX = 20 * ladoActual 
        local inclinacionCam = 2.5 * ladoActual 

        -- 2. Hacemos saltar las notas hacia los lados
        for i = 0, 7 do
            local index = i
            if i > 3 then index = i - 4 end
            
            local isPlayer = (i > 3)
            local baseX = isPlayer and _G['defaultPlayerStrumX'..index] or _G['defaultOpponentStrumX'..index]
            
            noteTweenX('saltoNota'..i, i, baseX + fuerzaSaltoX, 0.2, 'cubeOut')
        end


        triggerEvent('Add Camera Zoom', tostring(intensidadZoomGame), tostring(intensidadZoomHUD))
        
        setProperty('camHUD.angle', inclinacionCam)
        setProperty('camGame.angle', inclinacionCam)
        
        doTweenAngle('reboteHUD', 'camHUD', 0, 0.3, 'cubeOut')
        doTweenAngle('reboteGame', 'camGame', 0, 0.3, 'cubeOut')

        ladoActual = ladoActual * -1
    end
end