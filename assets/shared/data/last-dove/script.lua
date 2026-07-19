function onCreatePost()
    makeLuaSprite('blackbg', nil, screenWidth * -0.5, screenHeight * -0.5)
	makeGraphic('blackbg', screenWidth * 2, screenHeight * 2, '000000')
	setScrollFactor('blackbg', 0, 0)
    setProperty('blackbg.alpha', 0.9)
    setProperty('blackbg.visible', false)
    setObjectOrder('blackbg', getObjectOrder('boyfriendGroup') - 1)
	addLuaSprite('blackbg', true)
end

local strumCheck = true 
things = {'scoreTxt', 'timeTxt', 'timeBar', 'timeBarBG', 'healthBar', 'healthBarBG', 'iconP1', 'iconP2',}

function onStepHit()
    if curStep == 605 then
        doTweenX('camA', 'camFollow', 898, 0.8, 'sineout')
        doTweenY('camA2', 'camFollow', 468, 0.8, 'sineout')
    elseif curStep == 638 then
        doTweenX('camD', 'camFollow', 554, 0.8, 'sineout')
        doTweenY('camD2', 'camFollow', 453, 0.8, 'sineout')
    elseif curStep >= 656 and curStep <= 783 then
        for i = 1, #things do
            doTweenAlpha('A'..things[i], things[i], 0, 0.5, 1)
        end

        doTweenAlpha('Agf', 'gf', 0, 0.2)
        doTweenAlpha('Adad', 'dad', 0, 0.2)

        for i = 0, 3 do
            noteTweenAlpha('n'..i, i, 0, 0.2)
        end

        -- Oh yeah, middle scroll thing
        if not middlescroll then
            for i = 4, 7 do
                if strumCheck then
                    setPropertyFromGroup('strumLineNotes', i, 'x', (getProperty('defaultPlayerStrumX'..i) == _G['defaultPlayerStrumX'..i] and getPropertyFromGroup('strumLineNotes', i, 'x') - 278 or getPropertyFromGroup('strumLineNotes', i, 'x')))
                end
            end
            strumCheck = false
        end

        setProperty('cameraSpeed', 20)
        setProperty('camFollow.x', 998)
        setProperty('camFollow.y', 468)
        setProperty('blackbg.visible', true)
        setProperty('isCameraOnForcedPos', true)
    elseif curStep >= 783 then
        if not middlescroll then
            for i = 4, 7 do
                if not strumCheck then
                    setPropertyFromGroup('strumLineNotes', i, 'x', (getProperty('defaultPlayerStrumX'..i) == _G['defaultPlayerStrumX'..i] and getPropertyFromGroup('strumLineNotes', i, 'x') + 278 or getPropertyFromGroup('strumLineNotes', i, 'x')))
                end
            end
            strumCheck = true
        end

        for i = 1, #things do
            doTweenAlpha('A'..things[i], things[i], 1, 0.5)
        end

        for i = 0, 3 do
            noteTweenAlpha('n'..i, i, 1, 0.5)
        end

        doTweenAlpha('Agf', 'gf', 1, 0.2)
        doTweenAlpha('Adad', 'dad', 1, 0.2)
        setProperty('cameraSpeed', 1)
        setProperty('blackbg.visible', false)
        setProperty('isCameraOnForcedPos', false)
    end

    if curStep >= 1375 then
        doTweenAlpha('hud', 'camHUD', 0, 0.5, 'smoothstepout')
    end

    if curStep == 656 then
        cameraFlash('hud', 'ffffff', 0.5)
    elseif curStep == 783 then
        cameraFlash('hud', 'ffffff', 0.5)
    end
end

function onTweenCompleted(t)
    if t == 'camA' then
        setProperty('isCameraOnForcedPos', true)
    elseif t == 'camD' then
        setProperty('isCameraOnForcedPos', false)
    end
end

