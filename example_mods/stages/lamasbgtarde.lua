function onCreatePost()
    makeLuaSprite('sky', 'main_weeks/lamasbg/tarde/cielo2', -250, -100)
    setScrollFactor('sky', 0.7, 0.7)
    scaleObject('sky', 1.1, 1.1)

    makeLuaSprite('sky2', 'main_weeks/lamasbg/tarde/cielo', -200, -100)
    setScrollFactor('sky2', 0.8, 0.8)
    scaleObject('sky2', 1.1, 1.1)

    makeLuaSprite('luz', 'main_weeks/lamasbg/tarde/Luz_BgLLAMAS_anocheciendo', -110, -60)
    setScrollFactor('luz', 1, 1)
    setProperty('luz.alpha', 0.4)
    scaleObject('luz', 1, 1)

    makeLuaSprite('sol', 'main_weeks/lamasbg/tarde/monedadeperu2', -240, -300)
    setScrollFactor('sol', 0.6, 0.6)

    makeLuaSprite('rocabg', 'main_weeks/lamasbg/tarde/rocabg2', 0, 100)
    setScrollFactor('rocabg', 1.1, 1.1)
    scaleObject('rocabg', 1, 1)

    makeLuaSprite('cloud', 'main_weeks/lamasbg/tarde/nubes2', -200, 0)
    setScrollFactor('cloud', 0.7, 0.7)
    scaleObject('cloud', 1.1, 1.1)

    makeLuaSprite('cerro', 'main_weeks/lamasbg/tarde/phouse2', -230, 65)
    setScrollFactor('cerro', 0.6, 0.6)
    scaleObject('cerro', 0.9, 0.9)

    makeLuaSprite('oceano', 'main_weeks/lamasbg/tarde/oceano2', -190, 90)
    setScrollFactor('oceano', 0.9, 0.9)
    scaleObject('oceano', 1, 1)

    makeLuaSprite('leon', 'main_weeks/lamasbg/tarde/leon', 0, 650 )
    setScrollFactor('leon', 0.9, 0.9)
    scaleObject('leon', 1.1, 1.1)

    makeLuaSprite('piso', 'main_weeks/lamasbg/tarde/arena2', -100, 675)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.1, 1)

    makeAnimatedLuaSprite('adrian', 'main_weeks/lamasbg/tarde/adrian', 1430, 600)
    setScrollFactor('adrian', 1, 1)
    scaleObject('adrian', 1.3, 1.3)
    addAnimationByPrefix('adrian', 'idle', 'Adrian idle atardecer', 24, false)

    makeAnimatedLuaSprite('pumply', 'main_weeks/lamasbg/tarde/pumply', 0, 800)
    setScrollFactor('pumply', 1.2, 1.2)
    scaleObject('pumply', 1.1, 1.1)
    addAnimationByPrefix('pumply', 'idle', 'pumply atardecer', 24, false)

    makeAnimatedLuaSprite('bot', 'main_weeks/lamasbg/BOT_assest-sentada-atardecer', 625, 350)
	addAnimationByIndices('bot', 'danceLeft', 'bot Dancing Beat', '1,2,3,4,5,6,7,8,9,10,11,12,13,14', 24)
	addAnimationByIndices('bot', 'danceRight', 'bot Dancing Beat', '15,16,17,18,19,20,21,22,23,24,25,26,27,28,29', 24)

    makeAnimatedLuaSprite('PCK', 'main_weeks/lamasbg/tarde/PCK', 500, 650)
    setScrollFactor('PCK', 1, 1)
    scaleObject('PCK', 1.25, 1.25)
    addAnimationByPrefix('PCK', 'idle', 'PCK idle atardecer', 24, false)

    addLuaSprite('sky2', false)
    addLuaSprite('sky', false)
    addLuaSprite('sol', false)
    addLuaSprite('cloud', false)
    addLuaSprite('cerro', false)
    addLuaSprite('oceano', false)
    addLuaSprite('adrian', false)
    addLuaSprite('piso', false)
    addLuaSprite('bot', false)
    addLuaSprite('PCK', false)
    addLuaSprite('daarick', false)
    addLuaSprite('pumply', true)
    addLuaSprite('luz', true)

    doTweenY('ahfju', 'leon', 400, 15, 'easeInOut')
    doTweenX('ahjfh', 'leon', 2000, 30, 'linear')
    runTimer('queso', 50, 1)

    setProperty('boyfriend.color', getColorFromHex('FFAA7F'))
end

function onTimerCompleted(t)
    if t == 'queso' then
        setProperty('leon.x', -300)
        doTweenY('ahfju', 'leon', 400, 15, 'cubeInOut')
        doTweenX('ahjfh', 'leon', 2000, 30, 'linear')
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
        playAnim('adrian', 'idle', true)
        playAnim('pumply', 'idle', true)
        playAnim('daarick', 'idle', true)
        playAnim('bot', 'danceLeft', true)
        playAnim('PCK', 'idle', true)
    else
        playAnim('bot', 'danceRight', true)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('adrian', 'idle', true)
        playAnim('pumply', 'idle', true)
        playAnim('daarick', 'idle', true)
        playAnim('bot', 'danceLeft', true)
        playAnim('PCK', 'idle', true)
    else
        playAnim('bot', 'danceRight', true)
    end
end