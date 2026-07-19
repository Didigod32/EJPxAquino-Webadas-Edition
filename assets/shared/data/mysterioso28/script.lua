function onCreate()
    if getPropertyFromClass('states.PlayState', 'curStage') ~= 'mysteriobg' then
        close()
    end
    setProperty('cameraSpeed', 99)
end

function onCreatePost()
    makeAnimatedLuaSprite('trensito', 'characters/aquino/tren', -740, -200)
    addAnimationByPrefix('trensito', 'chuchu', 'el tren chu chu', 30, false)
    scaleObject('trensito', 1.04, 1)
    setProperty('trensito.visible', false)
    addLuaSprite('trensito')
end

function onSongStart()
	setProperty('cameraSpeed', 1)
end

local pixelThing = false

function onUpdatePost()
    x1 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) + (150 * getProperty('iconP2.scale.x') - 150) / 2 - 26
    x2 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) - (150 * getProperty('iconP1.scale.x')) / 2 - 26 * 2


    if curStep >= 1996 then
        if getProperty('trensito.animation.curAnim.curFrame') == 19 then
            setProperty('boyfriend.visible', false)
        end
    end

    if getProperty('boyfriend.animation.curAnim.name') == 'dialogo' then
        if getProperty('boyfriend.animation.curAnim.curFrame') == 18 then
            setProperty('boyfriend.x', 620)
            setProperty('boyfriend.y', 30)
        end
    end

    if curStep >= 1596 then
        setProperty('iconP1.x', x2)
        setProperty('iconP2.x', x1)
        for i = 1, 2 do
            setProperty('iconP'..i..'.flipX', true)
        end
        setProperty('healthBar.flipX', true)

        if not middlescroll then
            for i = 0, 3 do
                setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
                setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
            end
        end
    end
end

function onDestroy()
    setPropertyFromClass('states.PlayState', 'isPixelStage', false)
end

function onEvent(n ,v1, v2)
    if n == 'Misterio Events' then
        if v1 == 'camAl0' then
            cancelTween('camT1')
            cancelTween('camT2')
            doTweenAlpha('camT1', 'camGame', 0, v2, 'quadInout')
            doTweenAlpha('camT2', 'camHUD', 0, v2, 'quadInout')
        end

        if v1 == 'camAl1' then
            cancelTween('camT1')
            cancelTween('camT2')
            cancelTween('camT3')
            cancelTween('camT4')
            doTweenAlpha('camT3', 'camGame', 1, v2, 'quadInout')
            doTweenAlpha('camT4', 'camHUD', 1, v2, 'quadInout')
        end

        if v1 == 'tren' then
            setProperty('trensito.visible', true)
            playAnim('trensito', 'chuchu')
        end

        if v1 == 'hud0' then
            cancelTween('hudsito')
            doTweenAlpha('hudsito', 'camHUD', 0, 1, 'smoothStepOut')
        end
    end
end