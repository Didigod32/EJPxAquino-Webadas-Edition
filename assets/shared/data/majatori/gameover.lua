function onCreate()
    prechacheMusic('gameOver')
    prechacheSound('gameOverEnd')
    addCharacterToList(getPropertyFromClass('substates.GameOverSubstate', 'characterName'), 'boyfriend')
end

local dead = false
local duration = 32

local secsPerMin = 60
local msPerMin = 1000
local durSecond = 60
local defaultTimeSignature = 4

function onGameOver()
    if not dead then
        runHaxeCode([[  
            if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
            if (game.vocals != null && game.vocals.time > 0) game.vocals.stop();
            
            game.camFollow.setPosition(game.boyfriend.getMidpoint().x, game.boyfriend.getMidpoint().y);
            game.camFollow.x -= game.boyfriend.cameraPosition[0] + game.boyfriendCameraOffset[0] + 300;
            game.camFollow.y -= game.boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1] + 100;
        ]])

        doTweenAlpha('bg', 'bg', 0, 1, 'expoOut')
        doTweenAlpha('dad', 'dad', 0, 1, 'expoOut')
        doTweenAlpha('gf', 'gf', 0, 1, 'expoOut')

        local beatLengthMs = ((secsPerMin / curBpm) * msPerMin)
        local stepLengthMs = beatLengthMs / defaultTimeSignature
        local durSeconds = stepLengthMs * duration / 1000
        
        doTweenZoom('camZoom', 'camGame', 0.55, durSeconds, 'expoOut')
        openCustomSubstate('death')

        freezedPos = getPropertyFromClass('backend.Conductor', 'songPosition')
        dead = true
    end
    return Function_Stop
end

function onPause()
    if dead then
        return Function_Stop
    end
end

function onCustomSubstateCreate(tag)
    if tag == 'death' then
        stopSounds()
        setProperty('camHUD.visible',false)

        deadChar = getPropertyFromClass('substates.GameOverSubstate', 'characterName')
        createInstance('playerDead', 'objects.Character', {getCharacterX('boyfriend') - 600, getCharacterY('boyfriend') + 320, deadChar, true})
        setObjectOrder('playerDead', getObjectOrder('boyfriendGroup') + 1)
        addInstance('playerDead')
        playAnim('playerDead', 'firstDeath', true)
    end
end

local canSelect = false
function onCustomSubstateUpdate(tag,elapsed)
    if tag == 'death' then
        --debugPrint(getProperty('playerDead.animation.curAnim.name'))
        setProperty('cameraSpeed', 1.5)

        if getProperty('playerDead.animation.curAnim.name') == 'firstDeath' then
            if getProperty('playerDead.animation.curAnim.finished') then
                canSelect = true
                --debugPrint('canSelect')
                playAnim('playerDead', 'deathLoop', true)
                playMusic('gameOver', 1, true)
            end
        end

        if canSelect then
            if keyJustPressed('accept') then
                playSound('gameOverEnd', 1)
                playAnim('playerDead', 'deathConfirm', true)
                cameraFade('game', '000000', 3)
                runTimer('accept', 3)

                stopSounds()
                canSelect = false
            end

            if keyJustPressed('back') then
                playSound('gameOverEnd', 1, false)
                playAnim('playerDead', 'deathConfirm', true)
                cameraFade('game', '000000', 3)
                runTimer('back', 3)

                stopSounds()
                canSelect = false
            end
        end

        setProperty('canResync', true)
        setProperty('defaultCamZoom', getProperty('camGame.zoom')) -- Unfucks the camera tween lmao
        setPropertyFromClass('backend.Conductor', 'songPosition', freezedPos)
    end
end

function stopSounds()
    runHaxeCode([[
        if (game.vocals != null) { game.vocals.stop(); }
        if (game.opponentVocals != null) { game.opponentVocals.stop(); }
    ]])
end

function onTimerCompleted(t)
    if t == 'accept' then
        closeCustomSubstate()
        setPropertyFromClass('states.PlayState', 'deathCounter', getPropertyFromClass('states.PlayState', 'deathCounter') + 1)
        restartSong()
    end

    if t == 'back' then
        exitSong()
    end
end