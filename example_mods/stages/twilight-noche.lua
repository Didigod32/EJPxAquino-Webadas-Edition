function onCreatePost()
    makeLuaSprite('cielo', 'backgrounds/twilight/noche/sky_week3_phase3', -100, 200)
    setScrollFactor('cielo', 0.8, 0.8)
    scaleObject('cielo', 1.5, 1.5)

    makeLuaSprite('ciudad', 'backgrounds/twilight/noche/city_week3_phase3', 0, 100)
    setScrollFactor('ciudad', 0.9, 0.9)
    scaleObject('ciudad', 1.5, 1.5)

    makeLuaSprite('piso', 'backgrounds/twilight/noche/vereda_week3_phase3', 0, 0)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.5, 1.5)

    addLuaSprite('cielo', false)
    addLuaSprite('ciudad', false)
    addLuaSprite('piso', false)
end