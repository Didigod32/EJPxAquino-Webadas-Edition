function onCreate()
    makeLuaSprite('cielo', 'main_weeks/MC/Cielo', 0, 0)
    setScrollFactor('cielo', 0.9, 0.9)
    scaleObject('cielo', 2.5, 2.5)
    setProperty('cielo.antialiasing', false)
    addLuaSprite('cielo')

    makeLuaSprite('suelo', 'main_weeks/MC/suelo', 0, 0)
    setScrollFactor('suelo', 0.9, 0.9)
    scaleObject('suelo', 2.5, 2.5)
    setProperty('suelo.antialiasing', false)
    addLuaSprite('suelo')

    makeLuaSprite('Casa BG', 'main_weeks/MC/Casa_BG', -15, 5)
    setScrollFactor('Casa BG', 0.9, 0.9)
    scaleObject('Casa BG', 2.5, 2.5)
    setProperty('Casa BG.antialiasing', false)
    addLuaSprite('Casa BG')

    makeLuaSprite('casa', 'main_weeks/MC/casa', 0, 0)
    setScrollFactor('casa', 0.9, 0.9)
    scaleObject('casa', 2.5, 2.5)
    setProperty('casa.antialiasing', false)
    addLuaSprite('casa')

    makeLuaSprite('Casa techo 2', 'main_weeks/MC/Casa_techo_2', -10, 0)
    setScrollFactor('Casa techo 2', 0.9, 0.9)
    scaleObject('Casa techo 2', 2.5, 2.5)
    setProperty('Casa techo 2.antialiasing', false)
    addLuaSprite('Casa techo 2')

    makeLuaSprite('Casa techo', 'main_weeks/MC/Casa_techo', 0, 5)
    setScrollFactor('Casa techo', 0.9, 0.9)
    scaleObject('Casa techo', 2.5, 2.5)
    setProperty('Casa techo.antialiasing', false)
    addLuaSprite('Casa techo')

    if not lowQuality then
        makeAnimatedLuaSprite('arbol', 'main_weeks/MC/arbol',0,0)
        addAnimationByPrefix('arbol', 'idle', 'Arbol bv', 24, true)
        setScrollFactor('arbol', 0.9, 0.9)
        scaleObject('arbol', 2.5, 2.5)
        setProperty('arbol.antialiasing', false)
        addLuaSprite('arbol')

        makeLuaSprite('vallas bg', 'main_weeks/MC/vallas_bg', -15,-10)
        setScrollFactor('vallas bg', 0.9, 0.9)
        scaleObject('vallas bg', 2.5, 2.5)
        setProperty('vallas bg.antialiasing', false)
        addLuaSprite('vallas bg')
        
        makeAnimatedLuaSprite('vaca', 'main_weeks/MC/vaca', 990, 350)
        addAnimationByPrefix('vaca', 'idle', 'vaca', 24, false)
        setScrollFactor('vaca', 0.9, 0.9)
        scaleObject('vaca', 2.5, 2.5)
        setProperty('vaca.antialiasing', false)
        addLuaSprite('vaca')

        makeAnimatedLuaSprite('aldeano', 'main_weeks/MC/aldeano', 1100, 310)
        addAnimationByPrefix('aldeano', 'idle', 'Aldeano', 24, false)
        setScrollFactor('aldeano', 0.9, 0.9)
        scaleObject('aldeano', 2.5, 2.5)
        setProperty('aldeano.antialiasing', false)
        addLuaSprite('aldeano')

        makeLuaSprite('vallas', 'main_weeks/MC/vallas', -15,-10)
        setScrollFactor('vallas', 0.9, 0.9)
        scaleObject('vallas', 2.5, 2.5)
        setProperty('vallas.antialiasing', false)
        addLuaSprite('vallas')
    end

    makeAnimatedLuaSprite('DuxoMC','main_weeks/MC/DuxoMC', 50, 89)
    addAnimationByPrefix('DuxoMC', 'idle', 'Duco estatico', 24, false)
    setScrollFactor('DuxoMC', 0.9, 0.9)
    scaleObject('DuxoMC', 2.5, 2.5)
    setProperty('DuxoMC.antialiasing', false)
    addLuaSprite('DuxoMC')

    makeLuaSprite('adoquin', 'main_weeks/MC/adoquin', 5, 0)
    setScrollFactor('adoquin', 0.9, 0.9)
    scaleObject('adoquin', 2.5, 2.5)
    setProperty('adoquin.antialiasing', false)
    addLuaSprite('adoquin')

    makeLuaSprite('bloques', 'main_weeks/MC/bloques', 0, 0)
    setScrollFactor('bloques', 0.9, 0.9)
    scaleObject('bloques', 2.5, 2.5)
    setProperty('bloques.antialiasing', false)
    addLuaSprite('bloques')

    makeLuaSprite('vya', 'main_weeks/MC/vya', -5, 0)
    setScrollFactor('vya', 0.9, 0.9)
    scaleObject('vya', 2.5, 2.5)
    setProperty('vya.antialiasing', false)
    addLuaSprite('vya')

    makeAnimatedLuaSprite('StefanoMc', 'main_weeks/MC/StefanoMc', 560, 420)
    addAnimationByPrefix('StefanoMc', 'idle', 'Stefano idle', 24, false)
    addAnimationByPrefix('StefanoMc', 'hey', 'stefano waos', 24, false)
    addAnimationByPrefix('StefanoMc', 'left', 'stefano left', 24, false)
    addAnimationByPrefix('StefanoMc', 'right', 'stefano right', 24, false)
    setScrollFactor('StefanoMc', 0.9, 0.9)
    scaleObject('StefanoMc', 2.5, 2.5)
    setProperty('StefanoMc.antialiasing', false)
    addLuaSprite('StefanoMc')
end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        if not lowQuality then
            playAnim('vaca', 'idle')
            playAnim('aldeano', 'idle')
        end
        
        playAnim('StefanoMc', 'idle')
        playAnim('DuxoMC', 'idle')
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if not lowQuality then
            playAnim('vaca', 'idle')
            playAnim('aldeano', 'idle')
        end

        playAnim('StefanoMc', 'idle')
        playAnim('DuxoMC', 'idle')
    end
end