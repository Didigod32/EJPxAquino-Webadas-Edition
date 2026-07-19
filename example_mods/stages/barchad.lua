function onCreate()
    makeLuaSprite('sala', 'adribarbg/week1_sala', -2100, -850)
    setScrollFactor('sala', 0.86, 1)
    scaleObject('sala', 2.3, 2.3)
    addLuaSprite('sala', false)

    makeAnimatedLuaSprite('salida','adribarbg/week1_salida', -1200, 100)
    addAnimationByPrefix('salida', 'idle', 'SALIDA0', 24, false)
    setScrollFactor('salida', 0.9, 1.0)
    scaleObject('salida', 1.9, 1.9)
    addLuaSprite('salida', false)

    makeLuaSprite('foco_apagado', 'adribarbg/week1_foco_apagado', 1680, 180)
    setScrollFactor('foco_apagado', 0.85, 1)
    scaleObject('foco_apagado', 1.4, 1.4)
    addLuaSprite('foco_apagado', false)
    setBlendMode('foco_apagado', 'add')

    makeLuaSprite('foco_apagado2', 'adribarbg/week1_foco_apagado_fondo', 1050, -140)
    setScrollFactor('foco_apagado2', 0.86, 1)
    scaleObject('foco_apagado2', 1.5, 1.5)
    addLuaSprite('foco_apagado2', false)
    setBlendMode('foco_apagado2', 'add')

    makeLuaSprite('foco2','adribarbg/week1_foco_apagado_fondo', -200, -50)
    setScrollFactor('foco2', 0.87, 1)
    scaleObject('foco2', 1.3, 1.3)
    addLuaSprite('foco2', false)
    setBlendMode('foco2', 'add')

    makeAnimatedLuaSprite('Kullisu','adribarbg/Kullisu', -400, 300)
    addAnimationByPrefix('Kullisu', 'idle', 'Kullisu0', 24, false)
    setScrollFactor('Kullisu', 0.9, 1.0)
    scaleObject('Kullisu', 2.0, 2.0)
    addLuaSprite('Kullisu', false)

    makeAnimatedLuaSprite('Mike','adribarbg/Mike', 1430, 220)
    addAnimationByPrefix('Mike', 'idle', 'Mike0', 24, false)
    setScrollFactor('Mike', 0.95, 1)
    scaleObject('Mike', 2.0, 2.0)
    addLuaSprite('Mike', false)

    makeLuaSprite('mesa', 'adribarbg/week1_mesa', -350, -50)
    setScrollFactor('mesa', 0.95, 1)
    scaleObject('mesa', 2.3, 2.3)
    addLuaSprite('mesa', false)

    makeAnimatedLuaSprite('Sleepy','adribarbg/Sleepy', -650, 330)
    addAnimationByPrefix('Sleepy', 'idle', 'Sleepy0', 24, false)
    setScrollFactor('Sleepy', 0.95, 1)
    scaleObject('Sleepy', 2.2, 2.2)
    addLuaSprite('Sleepy', false)

    makeAnimatedLuaSprite('Roberto','adribarbg/Roberto_Alfonso_Gutierrez_ramirez', 1250, 360)
    addAnimationByPrefix('Roberto', 'idle', 'Catus idle', 24, false)
    setScrollFactor('Roberto', 0.95, 1)
    scaleObject('Roberto', 2.0, 2.0)
    addLuaSprite('Roberto', false)

    makeAnimatedLuaSprite('Dillex','adribarbg/Dillex', 1000, 300)
    addAnimationByPrefix('Dillex', 'idle', 'Dillex0', 24, false)
    setScrollFactor('Dillex', 0.95, 1)
    scaleObject('Dillex', 2.0, 2.0)
    addLuaSprite('Dillex', false)

    makeLuaSprite('foco','adribarbg/week1_foco_apagado_fondo', -900, -200)
    setScrollFactor('foco', 0.95, 1)
    scaleObject('foco', 1.9, 1.9)
    addLuaSprite('foco', true)
    setBlendMode('foco', 'add')

    makeAnimatedLuaSprite('Tsugi','adribarbg/Tsugi', 2450, 300)
    addAnimationByPrefix('Tsugi', 'idle', 'Tsugi0', 24, false)
    setScrollFactor('Tsugi', 0.95, 1)
    scaleObject('Tsugi', 2.0, 2.0)
    addLuaSprite('Tsugi', false)

    makeAnimatedLuaSprite('esteano','adribarbg/stefano_week1', 500, 700)
    setScrollFactor('esteano', 1, 1)
    scaleObject('esteano', 0.7, 0.7)
    addAnimationByPrefix('esteano', 'idle', 'Stefano idle dance', 24, false)
    addLuaSprite('esteano', false)

    makeAnimatedLuaSprite('Personajes_de_fondo_II','adribarbg/Personajes_de_fondo_II', 950, 660)
    addAnimationByPrefix('Personajes_de_fondo_II', 'idle', 'Personajes de fondo II0', 24, false)
    setScrollFactor('Personajes_de_fondo_II', 1.0, 0.9)
    scaleObject('Personajes_de_fondo_II', 2.2, 2.2)
    addLuaSprite('Personajes_de_fondo_II', true)

    makeAnimatedLuaSprite('Personajes_de_fondo_I','adribarbg/Personajes_de_fondo_I', -1650, 760)
    addAnimationByPrefix('Personajes_de_fondo_I', 'idle', 'Personajes de fondo I0', 24, false)
    setScrollFactor('Personajes_de_fondo_I', 1.0, 0.9)
    scaleObject('Personajes_de_fondo_I', 2.2, 2.2)
    addLuaSprite('Personajes_de_fondo_I', true)

    makeLuaSprite('bg', 'adribarbg/fondoBarbg', -500, 1100)
    setScrollFactor('bg', 1, 1)
    scaleObject('bg', 1.4, 1.2)
    setProperty('bg.visible', false)
    
    if string.lower(songName) == 'drunkin' then
        setProperty('Dillex.visible', false)
        setProperty('Mike.visible', false)
        setProperty('Sleepy.visible', false)
        setProperty('Personajes_de_fondo_I.visible', false)
        setProperty('Personajes_de_fondo_II.visible', false)
        setProperty('bg.visible', true)
        setProperty('defaultCamZoom', 0.7)

        addLuaSprite('bg', false)
    elseif string.lower(songName) == 'brindis' then
        setProperty('Dillex.visible', false)
        setProperty('Personajes_de_fondo_I.visible', false)
        setProperty('Personajes_de_fondo_II.visible', false)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('Kullisu', 'idle', true)
        playAnim('Dillex', 'idle', true)
        playAnim('Roberto', 'idle', true)
        playAnim('Mike', 'idle', true)
        playAnim('Sleepy', 'idle', true)
        playAnim('Tsugi', 'idle', true)
        playAnim('Personajes_de_fondo_I', 'idle', true)
        playAnim('Personajes_de_fondo_II', 'idle', true)
        playAnim('esteano', 'idle', true)
        playAnim('salida', 'idle', true)
    end
end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        playAnim('Kullisu', 'idle', true)
        playAnim('Dillex', 'idle', true)
        playAnim('Roberto', 'idle', true)
        playAnim('Mike', 'idle', true)
        playAnim('Sleepy', 'idle', true)
        playAnim('Tsugi', 'idle', true)
        playAnim('Personajes_de_fondo_I', 'idle', true)
        playAnim('Personajes_de_fondo_II', 'idle', true)
        playAnim('esteano', 'idle', true)
        playAnim('salida', 'idle', true)
    end
end