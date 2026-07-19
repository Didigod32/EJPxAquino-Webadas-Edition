function onCreatePost()
    if dadName == 'loco-duende' then
        startTween('tweenDad', 'dad', {y = getProperty('gf.y') + 20}, 0.6, {type = 'PINGPONG', ease = 'quadInOut', startDelay = '0.5'})
    elseif gfName == 'loco-duende' then
        startTween('tweenGf', 'gf', {y = getProperty('gf.y') + 20}, 0.6, {type = 'PINGPONG', ease = 'quadInOut', startDelay = '0.5'})
    end
end

function onEvent(n, v1)
    if n == 'Change Character' then
        if v1 == 'Dad' then
            onCreatePost()
        end
    end
end

function onUpdate()
    if gfSection then
        pos1 = getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]')
        pos2 = getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]')

        setProperty('camFollow.x', getProperty('camFollow.x') + pos1)
        setProperty('camFollow.y', getProperty('camFollow.y') + pos2)
        
        runHaxeCode([[
            game.camFollow.set(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
        ]])
    else
        cameraSetTarget((not mustHitSection and 'dad' or 'boyfriend'))
    end
end