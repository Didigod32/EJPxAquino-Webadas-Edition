-- =========================================================
-- Vuelo de Notas (Toda la pantalla) y Oponente Invisible
-- =========================================================

-- Configura aquí en qué momento empieza y termina la locura
local stepInicio = 1154
local stepFin = 1664

local efectoVueloActivo = false

-- Parámetros de Vuelo (Ajustables)
local amplitudX = 350  -- Cuánto viajan a los lados (350 cubre casi toda la pantalla)
local amplitudY = 40   -- Cuánto suben y bajan al volar
local velocidadX = 1.2 -- Rapidez del movimiento horizontal
local velocidadY = 2.0 -- Rapidez del movimiento vertical (distinto para que parezca que flota)

function onStepHit()
    -- 1. ACTIVAR EL EFECTO
    if curStep == stepInicio then
        efectoVueloActivo = true
        
        -- Escondemos los receptores (strums) del Oponente (0 al 3)
        for i = 0, 3 do
            noteTweenAlpha('esconderStrumDad'..i, i, 0, 1, 'cubeOut')
        end
        
        -- Escondemos de golpe las notas del oponente que ya estén cayendo
        for i = 0, getProperty('notes.length') - 1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'alpha', 0)
            end
        end
    end

    -- 2. DESACTIVAR EL EFECTO
    if curStep == stepFin then
        efectoVueloActivo = false
        
        -- Mostramos al oponente de nuevo
        for i = 0, 3 do
            noteTweenAlpha('mostrarStrumDad'..i, i, 1, 1, 'cubeOut')
        end
        
        -- Regresamos las notas de Boyfriend a su lugar y rotación original
        for i = 4, 7 do
            local index = i - 4
            noteTweenX('regresoBFX'..i, i, _G['defaultPlayerStrumX'..index], 1, 'cubeOut')
            noteTweenY('regresoBFY'..i, i, _G['defaultPlayerStrumY'..index], 1, 'cubeOut')
            noteTweenAngle('regresoGiro'..i, i, 0, 1, 'cubeOut')
        end
    end
end

function onUpdate(elapsed)
    if efectoVueloActivo then
        local time = getSongPosition() / 1000
        
        -- Generamos el movimiento fluido de "vuelo"
        local offsetX = math.sin(time * velocidadX) * amplitudX
        local offsetY = math.cos(time * velocidadY) * amplitudY
        local inclinacion = math.sin(time * velocidadX) * 10 -- Se inclinan un poco al girar
        
        -- Aplicamos el movimiento al grupo de flechas del Jugador (4 al 7)
        for i = 4, 7 do
            local index = i - 4
            
            -- Calculamos el centro exacto de la pantalla para las 4 flechas
            -- (screenWidth / 2) es la mitad, le restamos 224 para centrar el bloque completo
            local baseCentroX = (screenWidth / 2) - 224 + (index * 112)
            
            -- Tomamos la 'Y' original por si el jugador usa Downscroll
            local baseCentroY = _G['defaultPlayerStrumY'..index]
            
            setPropertyFromGroup('strumLineNotes', i, 'x', baseCentroX + offsetX)
            setPropertyFromGroup('strumLineNotes', i, 'y', baseCentroY + offsetY)
            setPropertyFromGroup('strumLineNotes', i, 'angle', inclinacion)
        end
        
        -- Mantenemos invisibles las notas del oponente que sigan generándose
        for i = 0, getProperty('notes.length') - 1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'alpha', 0)
            end
        end
    end
end