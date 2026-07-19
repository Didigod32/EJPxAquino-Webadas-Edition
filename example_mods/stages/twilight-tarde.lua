function onCreatePost()
    makeLuaSprite('cielo', 'week_assets/main_weeks/images/twilight/tarde/sky_phase2', -100, 200)
    setScrollFactor('cielo', 0.8, 0.8)
    scaleObject('cielo', 1.5, 1.5)

    makeLuaSprite('ciudad', 'week_assets/main_weeks/images/twilight/tarde/city_week3_phase', 0, 100)
    setScrollFactor('ciudad', 0.9, 0.9)
    scaleObject('ciudad', 1.5, 1.5)

    makeLuaSprite('piso', 'week_assets/main_weeks/images/twilight/tarde/street_phase2', 0, 0)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.5, 1.5)

    addLuaSprite('cielo', false)
    addLuaSprite('ciudad', false)
    addLuaSprite('piso', false)
end