function onCreate()
    makeLuaSprite('sky', 'cumpota/sky', -325, -1150)
    setScrollFactor('sky', 0.9, 0.9)
    scaleObject('sky', 1.1, 1.1)
    addLuaSprite('sky')

    makeLuaSprite('back', 'cumpota/back', -1500, -600)
    setScrollFactor('back', 0.9, 0.9)
    addLuaSprite('back')

    makeLuaSprite('front', 'cumpota/front', -430,-350)
    setScrollFactor('front', 0.9, 0.9)
    addLuaSprite('front')

    if not lowQuality then
        makeLuaSprite('salida', 'cumpota/salida', 525, 125)
        setScrollFactor('salida', 0.9, 0.9)
        scaleObject('salida', 1.1, 1.1)
        addLuaSprite('salida')

        makeLuaSprite('puesto', 'cumpota/puesto', 0, 250)
        setScrollFactor('puesto', 0.9, 0.9)
        scaleObject('puesto', 1.1, 1.1)
        addLuaSprite('puesto')

        makeAnimatedLuaSprite('Nikkusa','cumpota/Nikkusa', -400, -200)
        addAnimationByPrefix('Nikkusa', 'idle', 'Idle_nikkusa instancia', 24, false)
        setScrollFactor('Nikkusa', 0.9, 0.9)
        addLuaSprite('Nikkusa')

        makeAnimatedLuaSprite('Tricky','cumpota/Tricky', 350, 150)
        addAnimationByPrefix('Tricky', 'idle', 'Idle_Tricky instancia', 24, false)
        setScrollFactor('Tricky', 0.9, 0.9)
        addLuaSprite('Tricky')

        makeAnimatedLuaSprite('Whitty','cumpota/Whitty', 900, 100)
        addAnimationByPrefix('Whitty', 'idle', 'Idle_whitty instancia', 24, false)
        setScrollFactor('Whitty', 0.9, 0.9)
        addLuaSprite('Whitty')

        makeAnimatedLuaSprite('Tabi','cumpota/Tabi', 1100, 100)
        addAnimationByPrefix('Tabi', 'idle', 'Idle_Tabi instancia', 24, false)
        setScrollFactor('Tabi', 0.9, 0.9)
        addLuaSprite('Tabi')

        makeAnimatedLuaSprite('Nosense','cumpota/Nosense', 100, 200)
        addAnimationByPrefix('Nosense', 'idle', 'Idle_nosense instancia', 24, false)
        setScrollFactor('Nosense', 0.9, 0.9)
        addLuaSprite('Nosense')
        
        makeAnimatedLuaSprite('Matt','cumpota/Matt', 650, 250)
        addAnimationByPrefix('Matt', 'idle', 'Idle_matt instancia', 24, false)
        setScrollFactor('Matt', 0.9, 0.9)
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