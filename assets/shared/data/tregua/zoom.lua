-- =========================================================
-- Cortes Secos de Cámara (Estilo Multi-Cámara de TV)
-- =========================================================

-- Aquí defines en qué steps ocurren los cortes
local cortes = {
    -- target: 'dad' (oponente) o 'boyfriend' (jugador)
    -- zoom: Qué tan cerca está la toma (ej. 1.2 o 1.3 para un buen acercamiento)
    
    [10] = {target = 'dad', zoom = 1.25},       -- Corte instantáneo a la cara del oponente
    [30] = {target = 'boyfriend', zoom = 1.25}, -- Corte instantáneo a la cara del jugador
    [40] = {target = 'dad', zoom = 1.4},        -- Corte AÚN más cerca al oponente
    
    [100] = {target = 'reset', zoom = 0.8}       -- Devolver la cámara a la normalidad
}

local velocidadOriginal = 1

function onCreate()
    -- Guardamos la velocidad normal de tu cámara para no romper el juego
    velocidadOriginal = getProperty('cameraSpeed')
end

function onStepHit()
    local corte = cortes[curStep]

    if corte then
        -- 1. Forzamos la velocidad al máximo para que el viaje sea instantáneo (1 frame)
        setProperty('cameraSpeed', 9999)
        
        if corte.target == 'reset' then
            -- Soltamos la cámara
            triggerEvent('Camera Follow Pos', '', '')
            setProperty('defaultCamZoom', corte.zoom)
        else
            -- 2. Apuntamos al personaje directamente
            cameraSetTarget(corte.target)
            setProperty('defaultCamZoom', corte.zoom)
            
            -- Para evitar cualquier rastro de suavizado en el zoom, lo forzamos también
            setProperty('camGame.zoom', corte.zoom)
        end
        
        -- 3. Devolvemos la cámara a su velocidad normal casi inmediatamente 
        -- para que el movimiento natural (el pequeño balanceo que tienen) regrese.
        runTimer('restaurarVelocidad', 0.05)
    end
end

function onTimerCompleted(tag)
    if tag == 'restaurarVelocidad' then
        setProperty('cameraSpeed', velocidadOriginal)
    end
end