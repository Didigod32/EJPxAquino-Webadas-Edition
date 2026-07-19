local cantUse = false
local totemAlive = true
local totemUses = 10
local barValue = 1
local guide = true
local firstTime = true
local vida = 21

function onCreatePost()
    makeLuaSprite('thermoBarBG', 'hypothermia/barra', 0, 0)
    scaleObject('thermoBarBG', 1, 1)
    setObjectCamera('thermoBarBG', 'hud')

    makeLuaSprite('thermoBar', nil, 0, 0)
    makeGraphic('thermoBar', 16, 10, '4b7a29')
    setObjectCamera('thermoBar', 'hud')

    makeAnimatedLuaSprite('corazones', 'hypothermia/corazones', 0, 0)
    setObjectCamera('corazones', 'hud')
    
    makeAnimatedLuaSprite('nutria_godd', 'hypothermia/nutria_godd', 0, 0)
    scaleObject('nutria_godd', 0.4, 0.4)

    for i = 0, 10 do 
        addAnimationByPrefix('nutria_godd', 'uso'..i, 'N-'..i, 12, false)
    end

    for i = 21, 0, -1 do
        local prefixIndex = 21 - i
        local prefix = string.format("Corazon%04d", prefixIndex)
        local animationName = "cora"..i
        addAnimationByPrefix('corazones', animationName, prefix, 24, false)
    end

    makeAnimatedLuaSprite('spacebar', 'hypothermia/Extras', 0, 0)
    addAnimationByPrefix('spacebar', 'animacion', 'Spacebar', 24, true)
    screenCenter('spacebar')
    setObjectCamera('spacebar', 'hud')
    setProperty('spacebar.y', getProperty('spacebar.y') + 50)
    setProperty('spacebar.alpha', 0)

    makeAnimatedLuaSprite('totem', 'hypothermia/papanutria', 0, 0)
    addAnimationByPrefix('totem', 'lousa', '*lo usa*', 24, false)
    addAnimationByPrefix('totem', 'idle', 'idle', 24, false)
    setScrollFactor('totem', 1, 1)
    scaleObject('totem', 0.8, 0.8)

    makeLuaSprite('fog', 'hypothermia/fog', 0, 0)
    setObjectCamera('fog', 'other')
    scaleObject('fog', 1, 1)

    addLuaSprite('totem')
    addLuaSprite('thermoBarBG')
    addLuaSprite('thermoBar')
    addLuaSprite('corazones')
    addLuaSprite('nutria_godd')
    addLuaSprite('spacebar')
    addLuaSprite('fog')

    setObjectOrder('totem', getObjectOrder('boyfriendGroup') + 1)
    setObjectOrder('nutria_godd', getObjectOrder('totem'))
end

function onBeatHit()
    if curBeat % 2 == 0 and totemAlive then
        if getProperty('totem.animation.curAnim.name') == 'idle' then
            playAnim('totem', 'idle', false)
        end
    end
    if not botPlay then
        barValue = barValue + 1
    end
end

function onStepHit()
    if curStep == cooldownStep and cantUse then
        cantUse = false
    end
end

function onUpdatePost()
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and not botPlay then
        if not cantUse and totemAlive then
            cantUse = true
            cooldownStep = curStep+4
            totemUses = totemUses-1
            playAnim('totem', 'lousa', true)
            runTimer('use', 0.02, 35)
            playSound('mcTotem use', 0.7)
            addHealth(0.1)
            if guide and firstTime then
                guide = false
                firstTime = false
                doTweenAlpha('hf', 'spacebar', 0, 1.5, 'cubeInOut')
            end
            if totemUses == 0 then
                totemFuckingDies()
            end
        end
    end

    if barValue < 0 then
        barValue = 1
        cancelTimer('use')
    end
    if barValue > 98 then
        setProperty('health', -1)
    end
    if barValue == 40 and guide and firstTime then
        cancelTween('h1')
        doTweenAlpha('h1', 'spacebar', 1, 2, 'smoothStepIn')
    end

    if getProperty('totem.animation.curAnim.name') == 'lousa' then
        if getProperty('totem.animation.curAnim.finished') then
            playAnim('totem', 'idle', true)
        end
    end

    setProperty('fog.alpha', barValue / 100)
    playAnim('nutria_godd', 'uso'..totemUses)

    --offsets lol
    if getProperty('totem.animation.name') == 'lousa' and totemAlive then
        setProperty('totem.x', getProperty('boyfriend.x')+ 175)
        setProperty('totem.y', getProperty('boyfriend.y')- 215)
        setProperty('nutria_godd.visible', false)
    end
    if getProperty('totem.animation.name') == 'idle' and totemAlive then
        setProperty('totem.x', getProperty('boyfriend.x')+ 750)
        setProperty('totem.y', getProperty('boyfriend.y')+ 400)
        setProperty('nutria_godd.visible', true)
        setProperty('nutria_godd.x', getProperty('totem.x') + 350)
        setProperty('nutria_godd.y', getProperty('totem.y'))
    end

    setProperty('thermoBarBG.x', 10)
    screenCenter('thermoBarBG', 'y')

    setGraphicSize('thermoBar', 15, getProperty('thermoBarBG.height')*barValue/100)
    setProperty('thermoBar.x', getProperty('thermoBarBG.x')+5)
    setProperty('thermoBar.y', getProperty('thermoBarBG.y')+getProperty('thermoBarBG.height')-getProperty('thermoBar.height')-6)

    setProperty('corazones.x', getProperty('thermoBarBG.x')+30)
    setProperty('corazones.y', getProperty('thermoBarBG.y')-18)
end

function totemFuckingDies()
    if getProperty('totem.animation.name') == 'lousa' then
        totemUses = 0
        totemAlive = false
        doTweenY('totemMurio', 'totem', getProperty('totem.y') + 1000, 2.5, 'quadInOut')
        doTweenAlpha('totemAlpha', 'totem', 0, 1, 'quadInOut')
    end
end

function onTimerCompleted(t,l,ll)
    if t == 'use' then
        barValue = barValue-1
        setGraphicSize('thermoBar', 16, getProperty('thermoBarBG.height')*barValue/100)
        setProperty('thermoBar.y', getProperty('thermoBarBG.y')+getProperty('thermoBarBG.height')-getProperty('thermoBar.height')-9)
    end
end

function noteMiss(id, nd, nt, isn)
    barValue = barValue + 0.5
end