function onCreate()

    setProperty('boyfriend.color', getColorFromHex('8E88C8'))

    makeLuaSprite('fondo', 'main_weeks/cumpota/fondo', -300,-500)
    scaleObject('fondo', 0.9, 0.9)
    setScrollFactor('fondo', 1, 1)
    addLuaSprite('fondo')

    makeLuaSprite('LuzBg_COMPOTA', 'main_weeks/cumpota/LuzBg_COMPOTA', -310,-500)
    scaleObject('LuzBg_COMPOTA', 0.865, 0.9)
    setScrollFactor('LuzBg_COMPOTA', 1, 1)
    addLuaSprite('LuzBg_COMPOTA', true)

    if not lowQuality then
        makeAnimatedLuaSprite('Nosense','main_weeks/cumpota/Nosense', 20, 400)
        addAnimationByPrefix('Nosense', 'idle', 'Idle_nosense instancia', 24, false)
        scaleObject('Nosense', 0.75, 0.75)
        setScrollFactor('Nosense', 0.99, 0.99)
        addLuaSprite('Nosense')

        makeAnimatedLuaSprite('Nikkusa','main_weeks/cumpota/Nikkusa', -180, 155)
        addAnimationByPrefix('Nikkusa', 'idle', 'Idle_nikkusa instancia', 24, false)
        scaleObject('Nikkusa', 0.65, 0.65)
        setScrollFactor('Nikkusa', 0.99, 0.99)
        addLuaSprite('Nikkusa')

        makeAnimatedLuaSprite('Tricky','main_weeks/cumpota/Tricky', 500, 250)
        addAnimationByPrefix('Tricky', 'idle', 'Idle_Tricky instancia', 24, false)
        scaleObject('Tricky', 0.75, 0.75)
        setScrollFactor('Tricky', 1, 1)
        addLuaSprite('Tricky')

        makeAnimatedLuaSprite('Whitty','main_weeks/cumpota/Whitty', 1050, 250)
        addAnimationByPrefix('Whitty', 'idle', 'Idle_whitty instancia', 24, false)
        scaleObject('Whitty', 0.75, 0.75)
        setScrollFactor('Whitty', 1, 1)
        addLuaSprite('Whitty')

        makeAnimatedLuaSprite('Tabi','main_weeks/cumpota/Tabi', 1225, 345)
        addAnimationByPrefix('Tabi', 'idle', 'Idle_Tabi instancia', 24, false)
        scaleObject('Tabi', 0.8, 0.8)
        setScrollFactor('Tabi', 1, 1)
        addLuaSprite('Tabi')

        makeAnimatedLuaSprite('Matt','main_weeks/cumpota/Matt', 750, 350)
        addAnimationByPrefix('Matt', 'idle', 'Idle_matt instancia', 24, false)
        scaleObject('Matt', 0.65, 0.65)
        setScrollFactor('Matt', 1, 1)
        addLuaSprite('Matt')
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('Nikkusa', 'idle')
        playAnim('Tricky', 'idle')
        playAnim('Whitty', 'idle')
        playAnim('Tabi', 'idle')
        playAnim('Nosense', 'idle')
        playAnim('Matt', 'idle')
    end
end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        playAnim('Nikkusa', 'idle')
        playAnim('Tricky', 'idle')
        playAnim('Whitty', 'idle')
        playAnim('Tabi', 'idle')
        playAnim('Nosense', 'idle')
        playAnim('Matt', 'idle')
    end
end