local dead = false

function onCreate()
    defaultZoom = getProperty('defaultCamZoom')

    prechacheMusic('gameOver')
    prechacheSound('gameOverEnd')
    prechacheImage('characters/soarinmi_death_assets')
end

function onGameOver()
    if not dead then
        cameraSetTarget('boyfriend')
        setProperty('defaultCamZoom', defaultZoom)
        openCustomSubstate('death')
        
        stopSounds()
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
        setProperty('camHUD.visible',false)
        setProperty('boyfriend.visible',false)

        deadChar = getPropertyFromClass('substates.GameOverSubstate', 'characterName')
        createInstance('playerDead', 'objects.Character', {getCharacterX('boyfriend'), getCharacterY('boyfriend') + 350, deadChar, true})
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
            if keyboardJustPressed('F1') then
                playAnim('dad', 'decepcion', true)
                playSound('fnf_loss_sfx_micless', 1)
                playAnim('playerDead', 'deathConfirmF1', true)
                runTimer('f1', 2.5)

                if getProperty('texthelp.alpha') >= 0.5 then
                    doTweenAlpha('text1', 'texthelp', 0, 0.5, 'smoothstepout')
                end
                
                stopSounds()
                canSelect = false
            end

            if keyboardJustPressed('F2') then
                playSound('gameOverEnd', 1)
                playAnim('playerDead', 'deathConfirmF2', true)
                runTimer('f2', 2.5)

                if getProperty('texthelp.alpha') >= 0.5 then
                    doTweenAlpha('text1', 'texthelp', 0, 0.5, 'smoothstepout')
                end

                stopSounds()
                canSelect = false
            end
        end

        setProperty('persistentUpdate', true)
        setPropertyFromClass('backend.Conductor', 'songPosition', freezedPos)
    end
end

function stopSounds()
    runHaxeCode([[
        if (game.vocals != null) { game.vocals.stop(); }
        if (game.opponentVocals != null) { game.opponentVocals.stop(); }

        FlxG.sound.music.stop();
    ]])
end

function onTimerCompleted(t)
    if t == 'f2' then
        closeCustomSubstate()
        setPropertyFromClass('states.PlayState', 'deathCounter', getPropertyFromClass('states.PlayState', 'deathCounter') + 1)
        restartSong()
    end

    if t == 'f1' or t == 'counter' then
        exitSong()
    end

    if t == 'texty' then
        doTweenAlpha('text', 'texthelp', 1, 1, 'smoothstepin')
    end
end