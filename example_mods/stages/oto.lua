function onCreatePost()
    makeLuaSprite('cielo', 'oto/limoSunset', 0, 0)
    setScrollFactor('cielo', 0.6, 0.6)
    scaleObject('cielo', 1.3, 1.3)

    makeAnimatedLuaSprite('tren2', 'oto/bgLimo', 0, 1020)
    setScrollFactor('tren2', 0.9, 0.9)
    scaleObject('tren2', 1, 1)
    addAnimationByPrefix('tren2', 'idle', 'background limo pink', 24, true)

    makeAnimatedLuaSprite('tren1', 'oto/limoDrive', 1800, 1200)
    setScrollFactor('tren1', 1, 1)
    scaleObject('tren1', 1, 1)
    addAnimationByPrefix('tren1', 'idle', 'Limo stage', 24, true)

    addLuaSprite('cielo', false)
    addLuaSprite('tren2', false)
    addLuaSprite('tren1', false)

    setScrollFactor('dad', 0.9, 0.9)
end