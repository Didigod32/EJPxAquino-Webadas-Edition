function onCreatePost()
    makeLuaSprite('sky', 'main_weeks/lamasbg/cielo', -200, -100)
    setScrollFactor('sky', 0.5, 0.5)
    scaleObject('sky', 1.1, 1.1)
    addLuaSprite('sky', false)

    makeLuaSprite('sol', 'main_weeks/lamasbg/monedadeperu', -190, -100)
    setScrollFactor('sol', 0.6, 0.6)
    scaleObject('sol', 2.5, 2.5)
    addLuaSprite('sol', false)

    makeLuaSprite('cloud', 'main_weeks/lamasbg/nubes', -250, -100)
    setScrollFactor('cloud', 0.4, 0.4)
    scaleObject('cloud', 1.1, 1.1)
    addLuaSprite('cloud', false)

    makeLuaSprite('cerro', 'main_weeks/lamasbg/phouse', -220, 150)
    setScrollFactor('cerro', 0.6, 0.6)
    scaleObject('cerro', 0.9, 0.9)
    addLuaSprite('cerro', false)

    makeLuaSprite('oceano', 'main_weeks/lamasbg/oceano', -100, -15)
    setScrollFactor('oceano', 0.9, 0.9)
    scaleObject('oceano', 1.1, 1.1)
    addLuaSprite('oceano', false)

    makeLuaSprite('leon', 'main_weeks/lamasbg/leon', -300, 650)
    setScrollFactor('leon', 0.8, 0.8)
    scaleObject('leon', 0.85, 0.85)
    addLuaSprite('leon', false)

    makeLuaSprite('piso', 'main_weeks/lamasbg/arena', -60, 675)
    setScrollFactor('piso', 1, 1)
    scaleObject('piso', 1.1, 1.1)
    addLuaSprite('piso', false)

    makeAnimatedLuaSprite('gigi', 'main_weeks/lamasbg/gigi', -10, 735)
    setScrollFactor('gigi', 1.1, 1.1)
    scaleObject('gigi', 0.8, 0.8)
    addAnimationByPrefix('gigi', 'idle', 'IDLE DANCE', 24, false)
    addLuaSprite('gigi', true)

    makeAnimatedLuaSprite('mictia', 'main_weeks/lamasbg/mictia', 1700, 830)
    setScrollFactor('mictia', 1.1, 1.1)
    scaleObject('mictia',0.8, 0.8)
    addAnimationByPrefix('mictia', 'idle', 'IDLE DANCE', 24, false)
    addLuaSprite('mictia', true)

    makeLuaSprite('rocabg', 'main_weeks/lamasbg/rocabg', -170, 930)
    setScrollFactor('rocabg', 0.9, 0.9)
    scaleObject('rocabg', 1.15, 1.15)
    addLuaSprite('rocabg', true)

    makeLuaSprite('luz', 'main_weeks/lamasbg/Luz_BgLLAMAS_dia', 10, 00)
    setScrollFactor('luz', 1.25, 1.25)
    scaleObject('luz', 1, 1)
    setProperty('luz.alpha', 0.4)
    addLuaSprite('luz', true)

    makeAnimatedLuaSprite('daarick', 'main_weeks/lamasbg/Daarick_assets', 300, 350)
    setScrollFactor('daarick', 1, 1)
    scaleObject('daarick', 0.9, 0.9)
    addAnimationByPrefix('daarick', 'idle', 'Daarick idle dance', 24, false)

    doTweenY('ahfju', 'leon', 475, 15, 'easeInOut')
    doTweenX('ahjfh', 'leon', 2500, 30, 'linear')

    if string.lower(songName) == 'chillin' then
        addLuaSprite('daarick', false)
    end

end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        playAnim('gigi', 'idle', true)
        playAnim('mictia', 'idle', true)
        playAnim('daarick', 'idle', true)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('gigi', 'idle', true)
        playAnim('mictia', 'idle', true)
        playAnim('daarick', 'idle', true)
    end
end