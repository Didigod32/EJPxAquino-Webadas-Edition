-- Paleta de Iluminación (Hexadecimal):
local colorLuz         = 'FFFFFF'  -- Cantante activo 
local colorSombra      = '444F70'  -- Cantante inactivo 
local colorGF          = '58688C'  -- GF 
local colorFondo       = '121526'  -- Escenario 

local propsDrunkin = {
    'sala', 'mesa', 'Kullisu', 'Roberto', 'Tsugi', 'esteano'
}

local enfoqueActivo = false
local cantanteActual = ''

function onCreate()
    makeLuaSprite('filtroAzulPantalla', '', 0, 0)
    makeGraphic('filtroAzulPantalla', screenWidth, screenHeight, '080B1C')
    setBlendMode('filtroAzulPantalla', 'multiply')
    setScrollFactor('filtroAzulPantalla', 0, 0)
    setObjectCamera('filtroAzulPantalla', 'hud')
    setProperty('filtroAzulPantalla.alpha', 0)
    addLuaSprite('filtroAzulPantalla', false)
end

function onStepHit()
    if curStep == 544 then
        enfoqueActivo = true

        -- Oscurecer escenario y público de fondo
        for _, tag in ipairs(propsDrunkin) do
            doTweenColor('darken_' .. tag, tag, colorFondo, 0.6, 'sineOut')
        end
        doTweenAlpha('focoOff', 'foco', 0.15, 0.6, 'sineOut')

        doTweenAlpha('filtroAtmosphere', 'filtroAzulPantalla', 0.15, 0.6, 'sineOut')

        -- Iluminación intermedia para GF
        doTweenColor('dimGF', 'gf', colorGF, 0.6, 'sineOut')

        enfocarCantante('dad')
    end

    if curStep == 668 and enfoqueActivo then
        enfoqueActivo = false

        -- Restaurar 
        for _, tag in ipairs(propsDrunkin) do
            doTweenColor('reset_' .. tag, tag, 'FFFFFF', 1.5, 'sineOut')
        end
        doTweenAlpha('focoOn', 'foco', 1.0, 1.5, 'sineOut')
        doTweenAlpha('filtroAtmosphereOff', 'filtroAzulPantalla', 0, 1.5, 'sineOut')

        doTweenColor('resetGF', 'gf', 'FFFFFF', 1.5, 'sineOut')

        doTweenColor('resetDad', 'dad', 'FFFFFF', 1.5, 'sineOut')
        doTweenColor('resetBF', 'boyfriend', 'FFFFFF', 1.5, 'sineOut')
    end
end

-- Cuando canta Dad
function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if enfoqueActivo and cantanteActual ~= 'dad' then
        enfocarCantante('dad')
    end
end

-- Cuando canta BF
function goodNoteHit(id, noteData, noteType, isSustainNote)
    if enfoqueActivo and cantanteActual ~= 'boyfriend' then
        enfocarCantante('boyfriend')
    end
end

function enfocarCantante(personaje)
    cantanteActual = personaje

    if personaje == 'dad' then
        -- Dad recibe la luz
        doTweenColor('lightDad', 'dad', colorLuz, 0.16, 'sineOut')
        doTweenColor('dimBF', 'boyfriend', colorSombra, 0.16, 'sineOut')

    elseif personaje == 'boyfriend' then
        -- BF recibe la luz 
        doTweenColor('lightBF', 'boyfriend', colorLuz, 0.16, 'sineOut')
        doTweenColor('dimDad', 'dad', colorSombra, 0.16, 'sineOut')
    end
end