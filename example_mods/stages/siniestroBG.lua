function onCreatePost()
    makeLuaSprite('cielo', 'freeplay_weeks/locoverde/FONDO DEL VERDE', -1500, -500)
    setScrollFactor('cielo', 1, 1)
    scaleObject('cielo', 1.5, 1.5)

    makeLuaSprite('jet', 'freeplay_weeks/locoverde/jet', -850, 360)
    setScrollFactor('jet', 1, 1)
    scaleObject('jet', 0.8, 0.8)

    makeLuaSprite('estrella', 'freeplay_weeks/locoverde/stars', -800, -400)
    setScrollFactor('estrella', 1, 1)

    makeLuaSprite('lugod', 'freeplay_weeks/locoverde/luna', -1000, -500)
    setScrollFactor('lugod', 1, 1)
    scaleObject('lugod', 0.8, 0.8)

    makeAnimatedLuaSprite('nube', 'freeplay_weeks/locoverde/nubesitas', -3500, -400)
    addAnimationByPrefix('nube', 'a', 'EDIFICIO1', 30, true)
    setScrollFactor('nube', 1, 1)

    makeAnimatedLuaSprite('ciudad2', 'freeplay_weeks/locoverde/edificio 1 bajar opacidad ', -3500, 260)
    addAnimationByPrefix('ciudad2', 's', 'EDIFICIO1', 180, true)
    setScrollFactor('ciudad2', 1, 1)

    makeAnimatedLuaSprite('ciudad', 'freeplay_weeks/locoverde/edificos_principales', -3500, 260)
    addAnimationByPrefix('ciudad', 'c', 'EDIFICIO1', 250, true)
    setScrollFactor('ciudad', 1, 1)

    makeLuaSprite('nub', 'freeplay_weeks/locoverde/neblina', -1000, 500)
    setScrollFactor('nub', 1, 1)

    addLuaSprite('cielo', false)
    addLuaSprite('estrella', false)
    addLuaSprite('lugod', false)
    addLuaSprite('nube', false)
    addLuaSprite('ciudad2', false)
    addLuaSprite('ciudad', false)
    addLuaSprite('nub', false)
    addLuaSprite('jet', false)

    setProperty('nub.alpha', 0.4)
    setProperty('nube.alpha', 0.6)

    if string.lower(songName) == 'demencia en verde' then
        setProperty('gf.visible', false)
    end
end

function onUpdatePost()
    if mustHitSection then
        setProperty('defaultCamZoom', 0.7)
    else
        setProperty('defaultCamZoom', 0.85)
    end
end