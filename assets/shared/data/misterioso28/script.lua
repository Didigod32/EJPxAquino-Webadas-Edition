function onCreatePost()
    makeAnimatedLuaSprite('trensito', 'characters/aquino/tren', -740, -200)
    addAnimationByPrefix('trensito', 'chuchu', 'el tren chu chu', 30, false)
    scaleObject('trensito', 1.04, 1)
    setProperty('trensito.visible', false)
    addLuaSprite('trensito')

    stageChange(0)
end

function onStepHit()
    if curStep == 640 or curStep == 1152 then
        stageChange(1)
        cameraFlash('hud', 'ffffff', 0.8)
    elseif curStep == 1024 or curStep == 1343 then
        stageChange(0)
        cameraFlash('hud', 'ffffff', 0.8)
    elseif curStep == 1856 then
        doTweenAlpha('hudsito', 'camHUD', 0, 1, 'smoothStepOut')
    elseif curStep == 1996 then
        setProperty('trensito.visible', true)
        playAnim('trensito', 'chuchu')
    end
end

local gameOverChange = false

function onUpdatePost()
    x1 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) + (150 * getProperty('iconP2.scale.x') - 150) / 2 - 26
    x2 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) - (150 * getProperty('iconP1.scale.x')) / 2 - 26 * 2

    if getProperty('boyfriend.animation.curAnim.name') == 'dialogo' then
        if getProperty('boyfriend.animation.curAnim.curFrame') == 18 then
            setProperty('boyfriend.x', 620)
            setProperty('boyfriend.y', 30)
        end
    end

    if curStep >= 1996 then
        if getProperty('trensito.animation.curAnim.curFrame') == 19 then
            setProperty('boyfriend.visible', false)
        end
    end

    if curStep <= 640 or curStep >= 1024 and curStep <= 1152 or curStep >= 1343 then
        setProperty('iconP1.x', x2)
        setProperty('iconP2.x', x1)

        setProperty('healthBar.flipX', true)
        setProperty('iconP1.flipX', true)
        setProperty('iconP2.flipX', true)

        if not middlescroll then
            for i = 0, 3 do
                setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
                setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
            end
        end
    else
        setProperty('healthBar.flipX', false)
        setProperty('iconP1.flipX', false)
        setProperty('iconP2.flipX', false)

        if not middlescroll then
            for i = 0, 3 do
                setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i])
                setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i])
            end
        end
    end

    if boyfriendName == 'aquino-espaldas' then
        gameOverChange = true
    elseif boyfriendName == 'aquino_nocturno-dead' then
        gameOverChange = false
    end
end

function onGameOverStart()
    if gameOverChange then
        setProperty('camFollow.x', getProperty('boyfriend.x') + 500)
        setProperty('camFollow.y', getProperty('boyfriend.y') + 300)
    else
        setProperty('camFollow.x', getProperty('boyfriend.x') - 480)
        setProperty('camFollow.y', getProperty('boyfriend.y') + 180)
    end
end


function stageChange(c)
    if c == 0 then -- Stage del tren
		setProperty('Fondo.visible', false)
		setProperty('Rocas_de_fondo.visible', false)
		setProperty('Neblina_2.visible', false)
		setProperty('Mi_tio_terio.visible', false)
		setProperty('Central.visible', false)
		setProperty('filtro.visible', false)

		setProperty('Cielomysterio.visible', true)
		setProperty('De_fondo.visible', true)
		setProperty('Cercano.visible', true)
		setProperty('Las_vias.visible', true)
		setProperty('Neblina.visible', true)

        setProperty('dad.x', -230)
        setProperty('dad.y', 40)

        setProperty('boyfriend.x', 500)
        setProperty('boyfriend.y', 80)

        if curStep >= 1024 then
            if not mustHitSection then
                setProperty('camFollowPos.x', 228)
                setProperty('camFollowPos.y', 224)
                setProperty('camFollow.x', 228)
                setProperty('camFollow.y', 224)
            else
                setProperty('camFollowPos.x', 708)
                setProperty('camFollowPos.y', 254)
                setProperty('camFollow.x', 708)
                setProperty('camFollow.y', 254)
            end
        end
    end

    if c == 1 then -- Stage de las rocas
		setProperty('Fondo.visible', true)
		setProperty('Rocas_de_fondo.visible', true)
		setProperty('Neblina_2.visible', true)
		setProperty('Mi_tio_terio.visible', true)
		setProperty('Central.visible', true)
		setProperty('filtro.visible', true)

		setProperty('Cielomysterio.visible', false)
		setProperty('De_fondo.visible', false)
		setProperty('Cercano.visible', false)
		setProperty('Las_vias.visible', false)
		setProperty('Neblina.visible', false)

        setProperty('dad.x', 100)
        setProperty('dad.y', -150)
        setProperty('boyfriend.x', 260)
        setProperty('boyfriend.y', 480)

        if not mustHitSection then
            setProperty('camFollowPos.x', 458)
            setProperty('camFollowPos.y', 616)
            setProperty('camFollow.x', 458)
            setProperty('camFollow.y', 616)
        else
            setProperty('camFollowPos.x', 509)
            setProperty('camFollowPos.y', 173)
            setProperty('camFollow.x', 509)
            setProperty('camFollow.y', 173)
        end
    end
end