function onCreatePost()
    makeLuaSprite('city', 'main_weeks/acbg/1', -300, -220)
    setScrollFactor('city', 0.75, 0.75)
    scaleObject('city', 1.4, 1.4)
    setProperty('city.antialiasing', false)
    addLuaSprite('city')

    makeLuaSprite('floor', 'main_weeks/acbg/2', 0, -220)
    setScrollFactor('floor', 1, 1)
    scaleObject('floor', 1.4, 1.4)
    addLuaSprite('floor')

    makeLuaSprite('wall', 'main_weeks/acbg/3', 0, -220)
    setScrollFactor('wall', 1, 1)
    scaleObject('wall', 1.4, 1.4)
    addLuaSprite('wall')

    makeLuaSprite('pc', 'main_weeks/acbg/4', 0, -220)
    setScrollFactor('pc', 1, 1)
    scaleObject('pc', 1.4, 1.4)
    addLuaSprite('pc')

    makeAnimatedLuaSprite('persona1', 'main_weeks/acbg/assets_staffAC', 100, 295)
    scaleObject('persona1', 1.2, 1.2)
    addAnimationByPrefix('persona1', 'idle', 'staffAC_x2', 24, false)
    addLuaSprite('persona1', false)

    if dadName == 'daniel-ezz' and gfName ~= 'daniel-ezz' then
        makeAnimatedLuaSprite('lioncat', 'characters/lioncat/Lioncat_assets1', getProperty('dad.x') - 320, getProperty('dad.y') + 30)
        addAnimationByPrefix('lioncat', 'idle', 'Lioncat idle', 24, false)
        setObjectOrder('lioncat', getObjectOrder('dadGroup') + 1)
        addLuaSprite('lioncat')
    end

    if dadName == 'lioncat' and gfName ~= 'lioncat' then
        makeAnimatedLuaSprite('daniel', 'characters/daniel/Daniel_Ez_assets', getProperty('dad.x') - 280, getProperty('dad.y') + 20)
        addAnimationByPrefix('daniel', 'idle', 'IDLE DANCE', 24, false)
        scaleObject('daniel', 1.5, 1.5)
        setObjectOrder('daniel', getObjectOrder('dadGroup') + 1)
        addLuaSprite('daniel')
    end

    if string.lower(songName) == 'decadencia' then
        makeAnimatedLuaSprite('bot', 'bgac/BOT_ass_ets', 1080, 480)
        addAnimationByIndices('bot', 'danceLeft', 'BOT bailando pe', '1,2,3,4,5,6,7,8,9,10,11,12,13,14', 24)
        addAnimationByIndices('bot', 'danceRight', 'BOT bailando pe', '15,16,17,18,19,20,21,22,23,24,25,26,27,28,29', 24)
        addLuaSprite('bot')
        
        if gfName == 'lioncat' then
            if luaSpriteExists('lioncat') then
                setProperty('lioncat.visible', false)
            end
            setProperty('gf.x', getProperty('lioncat.x'))
            setProperty('gf.y', getProperty('lioncat.y'))
        end

        if luaSpriteExists('daniel') then
            setProperty('daniel.visible', false)
        end
    end

    makeAnimatedLuaSprite('persona2', 'main_weeks/acbg/assets_staffAC2', 360, 300)
    scaleObject('persona2', 1.4, 1.4)
    addAnimationByPrefix('persona2', 'idle', 'staffAC_x2', 24, false)
    addLuaSprite('persona2', true)

    makeAnimatedLuaSprite('persona3', 'main_weeks/acbg/assets_staffAC1', 2000, 580)
    scaleObject('persona3', 1.4, 1.4)
    addAnimationByPrefix('persona3', 'idle', 'staffAC_1', 24, false)
    addLuaSprite('persona3', true)

        if string.lower(songName) == 'banned' then
            setProperty('lioncat.visible', false)
        end
end

function onCountdownTick(counter)
    if counter % 2 == 0 then
        playAnim('persona1', 'idle', true)
        playAnim('persona2', 'idle', true)
        playAnim('persona3', 'idle', true)

        if luaSpriteExists('bot') then
            playAnim('bot', 'danceLeft', true)
        end

        if luaSpriteExists('lioncat') then
            playAnim('lioncat', 'idle', true)
        end

        if luaSpriteExists('daniel') then
            playAnim('daniel', 'idle', true)
        end
    else
        if luaSpriteExists('bot') then
            playAnim('bot', 'danceRight', true)
        end
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('persona1', 'idle', true)
        playAnim('persona2', 'idle', true)
        playAnim('persona3', 'idle', true)

        if luaSpriteExists('bot') then
            playAnim('bot', 'danceLeft', true)
        end

        if luaSpriteExists('lioncat') then
            playAnim('lioncat', 'idle', true)
        end

        if luaSpriteExists('daniel') then
            playAnim('daniel', 'idle', true)
        end
    else
        if luaSpriteExists('bot') then
            playAnim('bot', 'danceRight', true)
        end
    end
end