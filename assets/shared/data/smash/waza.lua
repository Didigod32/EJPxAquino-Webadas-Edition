local cinematicEnabled = false
-- Guarda la escala original de tu fondo aquí (cámbiala si en tu escenario no es 1.0)
local escalaOriginal = 1.0 
local escalaZoom = 1.15 -- Qué tanto se va a acercar el fondo

function onCreate()
    -- Barra superior
    makeLuaSprite('topBar', '', -400, -250)
    makeGraphic('topBar', screenWidth * 3, 220, '000000')
    setObjectCamera('topBar', 'hud')
    addLuaSprite('topBar', false)

    -- Barra inferior
    makeLuaSprite('bottomBar', '', -400, screenHeight)
    makeGraphic('bottomBar', screenWidth * 3, 220, '000000')
    setObjectCamera('bottomBar', 'hud')
    addLuaSprite('bottomBar', false)
end

function onStepHit()
    if curStep == 0 then
        cinematicEnabled = true

        -- Bajan/Suben las barras
        doTweenY('topBarIn', 'topBar', -80, 0.4, 'cubeOut')
        doTweenY('bottomBarIn', 'bottomBar', screenHeight - 140, 0.4, 'cubeOut')
        
        -- NUEVO: Zoom al fondo (agrandamos su escala)
        doTweenX('bgZoomX', 'c3jocup.scale', escalaZoom, 0.4, 'cubeOut')
        doTweenY('bgZoomY', 'c3jocup.scale', escalaZoom, 0.4, 'cubeOut')
        
        -- NUEVO: Oscurecer el fondo a un gris oscuro (Hex: 777777) para separar a los personajes
        doTweenColor('bgDarken', 'c3jocup', '777777', 0.4, 'cubeOut')
    end

    if curStep == 512 then
        cinematicEnabled = false

        -- Escondemos las barras
        doTweenY('topBarOut', 'topBar', -250, 0.4, 'cubeOut')
        doTweenY('bottomBarOut', 'bottomBar', screenHeight, 0.4, 'cubeOut')

        -- Reseteamos ángulos
        doTweenAngle('topReset', 'topBar', 0, 0.4, 'cubeOut')
        doTweenAngle('bottomReset', 'bottomBar', 0, 0.4, 'cubeOut')
        doTweenAngle('bgAngleReset', 'c3jocup', 0, 0.4, 'cubeOut')
        
        -- NUEVO: Resetear el zoom a su tamaño original
        doTweenX('bgZoomResetX', 'c3jocup.scale', escalaOriginal, 0.4, 'cubeOut')
        doTweenY('bgZoomResetY', 'c3jocup.scale', escalaOriginal, 0.4, 'cubeOut')
        
        -- NUEVO: Devolverle su color y luz original (Hex: FFFFFF)
        doTweenColor('bgColorReset', 'c3jocup', 'FFFFFF', 0.4, 'cubeOut')
    end
end

function onMoveCamera(focus)
    if cinematicEnabled then
        local targetAngle = 0
        local bgTargetAngle = 0

        if focus == 'boyfriend' then
            targetAngle = 4
            bgTargetAngle = 3
        elseif focus == 'dad' then
            targetAngle = -4
            bgTargetAngle = -3
        elseif focus == 'gf' then
            targetAngle = 0
            bgTargetAngle = 0
        end

        doTweenAngle('topAngleDyn', 'topBar', targetAngle, 0.4, 'cubeOut')
        doTweenAngle('bottomAngleDyn', 'bottomBar', targetAngle, 0.4, 'cubeOut')
        doTweenAngle('bgAngleDyn', 'c3jocup', bgTargetAngle, 0.4, 'cubeOut')
    end
end 