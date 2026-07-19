function onCreatePost()
    -- Lo creamos fuera de la pantalla por la parte SUPERIOR (Y = -300)
    -- El X lo dejamos en 0 porque lo centraremos en la siguiente línea
    makeLuaSprite('cartelCreditos', 'AdrianTREGUA', 0, -300)
    scaleObject('cartelCreditos', 0.45, 0.45)
    
    -- Esta función nativa centra la imagen horizontalmente de forma automática
    screenCenter('cartelCreditos', 'x')
    
    -- Cámara 'other' para estar sobre todo el HUD
    setObjectCamera('cartelCreditos', 'other')
    addLuaSprite('cartelCreditos', true)
end

function onSongStart()
    -- Calculamos la posición Y exacta para que quede en el centro vertical de la pantalla
    local centroY = (screenHeight / 2) - (getProperty('cartelCreditos.height') / 2)
    
    -- 1. Baja desde arriba hasta el centro
    doTweenY('creditosEntraY', 'cartelCreditos', centroY, 1, 'cubeOut')
    doTweenAngle('creditosEntraGiro', 'cartelCreditos', 360, 1, 'cubeOut') 
    
    -- Iniciamos el temporizador: 1 segundo de entrada + 2 segundos de pausa
    runTimer('adiosCreditos', 1 + 1.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'adiosCreditos' then
        -- 2. Sale hacia la parte INFERIOR de la pantalla
        -- El efecto 'backIn' es el que hace la magia de subir un poco antes de caer
        doTweenY('creditosSaleY', 'cartelCreditos', screenHeight + 200, 1, 'backIn')
        doTweenAngle('creditosSaleGiro', 'cartelCreditos', 720, 1, 'backIn') 
    end
end