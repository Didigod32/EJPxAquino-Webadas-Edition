function onCreate()
    addHaxeLibrary('MusicBeatState')
    addHaxeLibrary('CreditsState')

    for i = 1, 7 do
        precacheSound('hit'..i)
        precacheSound('sweep'..i)
    end
end

function noteMiss(membersIndex, noteDirect, noteType, isSustainNote)
    cancelTween('girar')
    setProperty('camGame.angle', getRandomInt(-2, 2));
    playSound('hit'..getRandomInt(1, 3), 1, 'hiti');
    doTweenAngle('girar', 'camGame', 0, 0.2, 'linear');
end

function onEvent(n, v1, v2)
    if n == 'Play Animation' then
        if v1 == 'ataque' and v2 == 'dad' then
            if getProperty('dad.animation.curAnim.name'):find('ataque') then
                cancelTween('girar')
                setProperty('camGame.angle', getRandomInt(-2, 2))
                addHealth(-0.01);
                playSound('hit'..getRandomInt(1, 3), 1)
                playSound('sweep'..getRandomInt(1, 7), 1)
            end
            doTweenAngle('girar', 'camGame', 0, 0.4, 'linear');
        end
    end
end

function noteMissPress(noteDirect)
    noteMiss()
end

function onPause()
    pauseSound('hiti')
end

function onResume()
    resumeSound('hiti')
end

local playHey = {
    [328] = 328, [585] = 585, [589] = 589, [640] = 640, [686] = 686, [702] = 702, [1352] = 1352,
    [1357] = 1357, [1359] = 1359, [1605] = 1605, [1609] = 1609, [1612] = 1612,
}

function onStepHit()
    if curStep >= 592 and curStep <= 638 then
        if curStep % 3 == 0 then
            playAnim('StefanoMc', 'right', true)
        end
        if curStep % 6 == 0 then
            playAnim('StefanoMc', 'left', true)
        end
    elseif curStep >= 656 and curStep <= 712 then
        if curStep % 3 == 0 then
            playAnim('StefanoMc', 'right', true)
        end
        if curStep % 6 == 0 then
            playAnim('StefanoMc', 'left', true)
        end
    end

    if curStep == playHey[curStep] then
        playAnim('StefanoMc', 'hey', true)
    end

    if curStep == 844 then
        playAnim('StefanoMc', 'right', true)
    end
end

function onEndSong()
    if isStoryMode then
        runHaxeCode([[
            persistentUpdate = false;
            transitioning = true;
            MusicBeatState.switchState(new CreditsState());
        ]])
        return Function_Stop;
    end
    return Function_Continue;
end