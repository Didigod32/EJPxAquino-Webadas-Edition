local skipAble = true

function onCreatePost()
    setProperty('healthBar.flipX', true);
    setProperty('iconP1.flipX', true);
    setProperty('iconP2.flipX', true);

    if not middlescroll then
        for i = 0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x')+640)
        end
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x')-640)
        end
    end

    makeLuaSprite('b', nil, -100, -100)
    makeGraphic('b', 2000, 2000, '000000')
    addLuaSprite('b', true)
    setObjectCamera('b', 'other')

    makeLuaSprite('dedsafio', 'hypothermia/dedsafioScreen', 0, 0)
    setGraphicSize('dedsafio', screenWidth-200, screenHeight-100)
    addLuaSprite('dedsafio', true)
    setObjectCamera('dedsafio', 'other')
    screenCenter('dedsafio')
    setProperty('dedsafio.alpha', 0.0001)
    
    makeAnimatedLuaSprite('deadquino', 'hypothermia/aquino_ha_muerto', 0, 0)
    addAnimationByPrefix('deadquino', 'deathScreen', 'letsgo', 24, false);
    setGraphicSize('deadquino', getProperty('deadquino.width') / getProperty('defaultCamZoom'))
    screenCenter('deadquino')
    setObjectCamera('deadquino', 'other')
    setProperty('deadquino.visible', false)
    addLuaSprite('deadquino')

    makeLuaText('tilinTxt', 'Presiona "E" para skipear la intro', 0, 0, 670)
    screenCenter('tilinTxt', 'X')
    setProperty('tilinTxt.alpha', 0.0001)
    setObjectCamera('tilinTxt', 'other')
    addLuaText('tilinTxt')
    setTextSize('tilinTxt', 18)
    setTextFont('tiinTxt', 'vcr.tff')

    doTweenX('quex', 'dedsafio.scale', getProperty('dedsafio.scale.x')+0.5, 100, 'linear')
    doTweenY('quey', 'dedsafio.scale', getProperty('dedsafio.scale.y')+0.5, 100, 'linear')
    doTweenAlpha('ded1', 'dedsafio', 1, 5, 'cubeInOut')
    runTimer('quesesooo', 10, 1)
    runTimer('waza', 1, 1)
end

function onCreate()
    setProperty('skipCountdown', true)
end

function onUpdatePost()
    x1 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) + (150 * getProperty('iconP2.scale.x') - 150) / 2 - 26
    x2 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) - (150 * getProperty('iconP1.scale.x')) / 2 - 26 * 2
    setProperty('iconP1.x', x2)
    setProperty('iconP2.x', x1)

    setProperty('defaultCamZoom', mustHitSection and 0.7 or 0.8)

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.E') and skipAble then
        setPropertyFromClass('Conductor', 'songPosition', 17000)
        setPropertyFromClass('flixel.FlxG', 'sound.music.time', 17000)
        setProperty('vocals.time', 17000)
        setProperty('b.visible', false)
        setProperty('dedsafio.visible', false)
        setProperty('tilinTxt.visible', false)
        skipAble = false
    end
end

function onStepHit()
    if curStep == 784 then
        setProperty('deadquino.visible', true)
        playAnim('deadquino', 'deathScreen')
        setProperty('fog.visible', true)
    elseif curStep == 820 then
        setProperty('fog.visible', false)
        removeLuaSprite('deadquino', true)
    elseif curStep == 1527 then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)
    end
end

function onBeatHit()
    if curBeat == 197 then 
        setProperty('aquino_ha_muerto.visible', true)
        playAnim('aquino_ha_muerto', 'idle', true)
    end    
    if curBeat == 203 then 
        cameraFlash('game', 'FFFFFF', 1, false)
    end    
    if curBeat == 203 then 
        setProperty('aquino_ha_muerto.visible', false)
    end  
end

function onTimerCompleted(t)
    if t == 'quesesooo' then
        doTweenAlpha('ded2', 'dedsafio', 0, 5, 'cubeInOut')
        runTimer('hfd', 5, 1)
    end
    if t == 'hfd' then
        doTweenAlpha('xdxdxd', 'b', 0, 5, 'cubeInOut')
        skipAble = false
    end
    if t == 'waza' then
        doTweenAlpha('texto', 'tilinTxt', 1, 2, 'cubeInOut')
        runTimer('fe', 14, 1)
    end
    if t == 'fe' then
        doTweenAlpha('rhgfdsesf', 'tilinTxt', 0, 2, 'cubeInOut')
    end
end