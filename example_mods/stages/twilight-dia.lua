function onCreatePost()
    makeLuaSprite('cielo', 'twilight/dia/twi_sky', 0, 200)
    setScrollFactor('cielo', 0.8, 0.8)
    scaleObject('cielo', 1.5, 1.5)

    makeLuaSprite('ciudad', 'twilight/dia/twi_ciu', 0, 300)
    setScrollFactor('ciudad', 0.9, 0.9)
    scaleObject('ciudad', 1.5, 1.5)

    makeLuaSprite('piso', 'twilight/dia/twi_piso', 0, 0)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.5, 1.5)

    addLuaSprite('cielo', false)
    addLuaSprite('ciudad', false)
    addLuaSprite('piso', false)
end