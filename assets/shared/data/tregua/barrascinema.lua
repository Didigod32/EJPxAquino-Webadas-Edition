local altoMaximoBarra  = 300 
local velocidadStep512 = 0.6 
local velocidadSalida  = 1.2 

local offsetCentroX    = 0  
local offsetCentroY    = -35 
local camaraEnCentro   = false
local ocultarCombos    = false

function onCreatePost()
    makeLuaSprite('barraArriba', nil, 0, -altoMaximoBarra)
    makeGraphic('barraArriba', screenWidth, altoMaximoBarra, '000000')
    setObjectCamera('barraArriba', 'hud')
    addLuaSprite('barraArriba', false)

    makeLuaSprite('barraAbajo', nil, 0, screenHeight)
    makeGraphic('barraAbajo', screenWidth, altoMaximoBarra, '000000')
    setObjectCamera('barraAbajo', 'hud')
    addLuaSprite('barraAbajo', false)

    setObjectOrder('barraArriba', 0)
    setObjectOrder('barraAbajo', 1)
end


function moverBarras(grosorPixeles, duracion, easeType)
    local destinoArriba = -altoMaximoBarra + grosorPixeles
    local destinoAbajo  = screenHeight - grosorPixeles

    doTweenY('tweenBarraArriba', 'barraArriba', destinoArriba, duracion, easeType)
    doTweenY('tweenBarraAbajo', 'barraAbajo', destinoAbajo, duracion, easeType)
end


function cambiarAlphaHUD(alphaObjetivo, duracion)
    local elementosHUD = {'healthBar', 'iconP1', 'iconP2', 'scoreTxt', 'timeBar', 'timeTxt', 'comboGroup'}

    for _, elem in ipairs(elementosHUD) do
        if getProperty(elem) ~= nil then
            doTweenAlpha('tweenHUD_' .. elem, elem, alphaObjetivo, duracion, 'sineInOut')
        end
    end

    if alphaObjetivo == 0 then
        ocultarCombos = true
    else
        ocultarCombos = false
        setProperty('showRating', true)
        setProperty('showComboNum', true)
        setProperty('showCombo', false)
    end
end

function goodNoteHit()
    if ocultarCombos and getProperty('healthBar.alpha') < 0.2 then
        setProperty('showRating', false)
        setProperty('showComboNum', false)
        setProperty('showCombo', false)
    end
end


function fijarCamaraEnCentro(activar)
    camaraEnCentro = activar

    if activar then
        -- Bloquear el cambio automático de cámara por sección del motor
        setProperty('isCameraOnForcedPos', true)

        -- Calcular el punto medio exacto entre Dad y Boyfriend
        local centroX = ((getMidpointX('dad') + getMidpointX('boyfriend')) * 0.5) + offsetCentroX
        local centroY = ((getMidpointY('dad') + getMidpointY('boyfriend')) * 0.5) + offsetCentroY

        setProperty('camFollow.x', centroX)
        setProperty('camFollow.y', centroY)
    else
        setProperty('isCameraOnForcedPos', false)
        -- Devolver la cámara suavemente a quien le toque cantar en esa sección
        runHaxeCode([[
            game.moveCameraSection();
        ]])
    end
end

function onUpdatePost(elapsed)
    if camaraEnCentro then
        local centroX = ((getMidpointX('dad') + getMidpointX('boyfriend')) * 0.5) + offsetCentroX
        local centroY = ((getMidpointY('dad') + getMidpointY('boyfriend')) * 0.5) + offsetCentroY

        setProperty('camFollow.x', centroX)
        setProperty('camFollow.y', centroY)
    end
end

function onStepHit()
    if curStep == 384 then
        moverBarras(175, 3.5, 'sineInOut')
        cambiarAlphaHUD(0, 3.5)

    elseif curStep == 448 then
        moverBarras(125, 3.5, 'sineInOut')

    elseif curStep == 505 then
        moverBarras(200, 0.5, 'quartOut')

    elseif curStep == 512 then
        moverBarras(85, velocidadStep512, 'sineOut')
        fijarCamaraEnCentro(true)

    elseif curStep == 576 then
        fijarCamaraEnCentro(false)

    elseif curStep == 768 then
        moverBarras(0, velocidadSalida, 'sineInOut')
        cambiarAlphaHUD(1, velocidadSalida)
        if camaraEnCentro then
            fijarCamaraEnCentro(false)
        end
    end
end