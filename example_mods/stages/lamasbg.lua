function onCreatePost()
    makeLuaSprite('sky', 'lamasbg/cielo', -200, -100)
    setScrollFactor('sky', 0.5, 0.5)
    scaleObject('sky', 1.1, 1.1)
    addLuaSprite('sky', false)

    makeLuaSprite('sol', 'lamasbg/monedadeperu', 300, 0)
    setScrollFactor('sol', 0.6, 0.6)
    scaleObject('sol', 1.5, 1.5)
    addLuaSprite('sol', false)

    makeLuaSprite('cloud', 'lamasbg/nubes', -200, 0)
    setScrollFactor('cloud', 0.7, 0.7)
    scaleObject('cloud', 1.1, 1.1)
    addLuaSprite('cloud', false)

    makeLuaSprite('cerro', 'lamasbg/phouse', -50, 90)
    setScrollFactor('cerro', 0.8, 0.8)
    scaleObject('cerro', 1.1, 1.1)
    addLuaSprite('cerro', false)

    makeLuaSprite('oceano', 'lamasbg/oceano', -100, 500)
    setScrollFactor('oceano', 0.9, 0.9)
    scaleObject('oceano', 1.1, 1.1)
    addLuaSprite('oceano', false)

    makeLuaSprite('leon', 'lamasbg/leon', -300, 500)
    setScrollFactor('leon', 0.9, 0.9)
    scaleObject('leon', 1.1, 1.1)
    addLuaSprite('leon', false)

    makeLuaSprite('piso', 'lamasbg/arena', 0, 600)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.1, 1.1)
    addLuaSprite('piso', false)

    makeAnimatedLuaSprite('gigi', 'lamasbg/gigi', -10, 735)
    setScrollFactor('gigi', 1.1, 1.1)
    scaleObject('gigi', 0.8, 0.8)
    addAnimationByPrefix('gigi', 'idle', 'IDLE DANCE', 24, false)
    addLuaSprite('gigi', true)

    makeAnimatedLuaSprite('mictia', 'lamasbg/mictia', 1700, 830)
    setScrollFactor('mictia', 1.1, 1.1)
    scaleObject('mictia',0.8, 0.8)
    addAnimationByPrefix('mictia', 'idle', 'IDLE DANCE', 24, false)
    addLuaSprite('mictia', true)

    makeLuaSprite('rocabg', 'lamasbg/rocabg', -110, 975)
    setScrollFactor('rocabg', 0.9, 0.9)
    scaleObject('rocabg', 1.1, 1.1)
    addLuaSprite('rocabg', true)

    doTweenY('ahfju', 'leon', 400, 15, 'easeInOut')
    doTweenX('ahjfh', 'leon', 2000, 30, 'linear')
    runTimer('queso', 50, 1)
end

function onTimerCompleted(t)
    if t == 'queso' then
        setProperty('leon.x', -300)
        doTweenX('ahjfh', 'leon', 2000, 30, 'linear')
        doTweenY('ahfju', 'leon', 400, 15, 'cubeInOut')
        runTimer('queso', 50, 1)
    end
end

function onTweenCompleted(t)
    if t == 'ahfju' then
        doTweenY('ahfju2', 'leon', 500, 15, 'easeInOut')
    end
end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        playAnim('gigi', 'idle', true)
        playAnim('mictia', 'idle', true)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('gigi', 'idle', true)
        playAnim('mictia', 'idle', true)
    end
end