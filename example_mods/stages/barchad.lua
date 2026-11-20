function onCreate()
    makeLuaSprite('sala', 'main_weeks/adribarbg/week1_sala', -1100, -400)
    setScrollFactor('sala', 1, 1)
    scaleObject('sala', 1.2, 1.2)
    addLuaSprite('sala', false)

    makeLuaSprite('luz', 'main_weeks/adribarbg/LuzBg_ADRIAN', -1150, -430)
    setScrollFactor('luz', 1, 1)
    scaleObject('luz', 1.65, 1.65)
    addLuaSprite('luz', true)

    makeAnimatedLuaSprite('Kullisu','main_weeks/adribarbg/Kullisu', -15, 350)
    addAnimationByPrefix('Kullisu', 'idle', 'Kullisu0', 24, false)
    setScrollFactor('Kullisu', 0.9, 1.0)
    scaleObject('Kullisu', 1.75, 1.75)
    addLuaSprite('Kullisu', false)

    makeAnimatedLuaSprite('Mike','main_weeks/adribarbg/Mike', 1500, 315)
    addAnimationByPrefix('Mike', 'idle', 'Mike0', 24, false)
    setScrollFactor('Mike', 0.95, 1)
    scaleObject('Mike', 1.7, 1.7)
    addLuaSprite('Mike', false)

    makeLuaSprite('mesa', 'main_weeks/adribarbg/week1_mesa', 10, 60)
    setScrollFactor('mesa', 1, 1)
    scaleObject('mesa', 1.2, 1.2)
    addLuaSprite('mesa', false)

    makeAnimatedLuaSprite('Sleepy','main_weeks/adribarbg/Sleepy', -590, 330)
    addAnimationByPrefix('Sleepy', 'idle', 'Sleepy0', 24, false)
    setScrollFactor('Sleepy', 0.95, 1)
    scaleObject('Sleepy', 2.2, 2.2)
    addLuaSprite('Sleepy', false)

    makeAnimatedLuaSprite('Roberto','main_weeks/adribarbg/Roberto_Alfonso_Gutierrez_ramirez', 1400, 455)
    addAnimationByPrefix('Roberto', 'idle', 'Catus idle', 24, false)
    setScrollFactor('Roberto', 0.95, 1)
    scaleObject('Roberto', 1.3, 1.3)
    addLuaSprite('Roberto', false)

    makeAnimatedLuaSprite('Dillex','main_weeks/adribarbg/Dillex', 10, 450)
    addAnimationByPrefix('Dillex', 'idle', 'Dillex0', 24, false)
    setScrollFactor('Dillex', 0.95, 1)
    scaleObject('Dillex', 2.0, 2.0)
    addLuaSprite('Dillex', false)

    makeLuaSprite('foco','main_weeks/adribarbg/week1_foco_apagado_fondo', -900, -200)
    setScrollFactor('foco', 0.95, 1)
    scaleObject('foco', 1.9, 1.9)
    --addLuaSprite('foco', true)
    setBlendMode('foco', 'add')

    makeAnimatedLuaSprite('Tsugi','main_weeks/adribarbg/Tsugi', 2000, 335)
    addAnimationByPrefix('Tsugi', 'idle', 'Tsugi0', 24, false)
    setScrollFactor('Tsugi', 0.95, 1)
    scaleObject('Tsugi', 2.0, 2.0)
    addLuaSprite('Tsugi', false)

    makeAnimatedLuaSprite('esteano','main_weeks/adribarbg/stefano_week1', 500, 850)
    setScrollFactor('esteano', 1, 1)
    scaleObject('esteano', 0.7, 0.7)
    addAnimationByPrefix('esteano', 'idle', 'Stefano idle dance', 24, false)
    addLuaSprite('esteano', false)

    makeAnimatedLuaSprite('Personajes_de_fondo_II','main_weeks/adribarbg/Personajes_de_fondo_II', 1000, 900)
    addAnimationByPrefix('Personajes_de_fondo_II', 'idle', 'Personajes de fondo II0', 24, false)
    setScrollFactor('Personajes_de_fondo_II', 1.0, 0.9)
    scaleObject('Personajes_de_fondo_II', 1.9, 1.9)
    addLuaSprite('Personajes_de_fondo_II', true)

    makeAnimatedLuaSprite('Personajes_de_fondo_I','main_weeks/adribarbg/Personajes_de_fondo_I', -1250, 975)
    addAnimationByPrefix('Personajes_de_fondo_I', 'idle', 'Personajes de fondo I0', 24, false)
    setScrollFactor('Personajes_de_fondo_I', 1.0, 0.9)
    scaleObject('Personajes_de_fondo_I', 1.9, 1.9)
    addLuaSprite('Personajes_de_fondo_I', true)

    makeLuaSprite('bg', 'main_weeks/adribarbg/fondoBarbg', -500, 40)
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
        setProperty('luz.alpha', 0)

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

function onCreatePost()
    setScrollFactor('dadGroup',  1, 1)
    setScrollFactor('gfGroup',  1, 1)
    setScrollFactor('boyfriendGroup',  1, 1)
end