local partyVibeActive = false
local directionalBounceActive = false

local bumpX = 0
local bumpY = 0

function onStepHit()
    -- STEP 1152: Iniciar rebote musical suave al compás de los beats
    if curStep == 1152 then
        cameraFlash('camGame', '0xFFFFFFFF', 0.4, true)
        partyVibeActive = true
    end

    -- STEP 1280: Terminar rebote musical y activar el rebote direccional por notas
    if curStep == 1280 then
        partyVibeActive = false
        directionalBounceActive = true
        cameraFlash('camGame', '0xFF87CEEB', 0.8, true)
    end

    -- STEP 1408: Finalizar el efecto direccional al terminar la canción
    if curStep == 1408 then
        directionalBounceActive = false
    end
end

function onBeatHit()
    if partyVibeActive then
        if getProperty('camGame.zoom') < 1.35 and cameraZoomOnBeat then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03)
        end
    end
end


function goodNoteHit(id, noteData, noteType, isSustainNote)
    if directionalBounceActive and not isSustainNote then
        -- noteData: 0 = Izquierda, 1 = Abajo, 2 = Arriba, 3 = Derecha
        if noteData == 0 then
            bumpX = -22 -- Izquierda
        elseif noteData == 1 then
            bumpY = 22  -- Abajo
        elseif noteData == 2 then
            bumpY = -22 -- Arriba
        elseif noteData == 3 then
            bumpX = 22  -- Derecha
        end
    end
end

function onUpdatePost(elapsed)
    if bumpX ~= 0 or bumpY ~= 0 then
        runHaxeCode([[
            game.camGame.scroll.x += ]] .. bumpX .. [[;
            game.camGame.scroll.y += ]] .. bumpY .. [[;
        ]])
        bumpX = bumpX * 0.72
        bumpY = bumpY * 0.72
        
        if math.abs(bumpX) < 0.4 then bumpX = 0 end
        if math.abs(bumpY) < 0.4 then bumpY = 0 end
    end
end