function onCreatePost()
    if dadName == 'tommy-duende-verde' then
        startTween('tweenDad', 'dad', {y = getProperty('dad.y') + 20}, 0.6, {type = 'PINGPONG', ease = 'quadInOut'})
    elseif gfName == 'tommy-duende-verde' then
        startTween('tweenGf', 'gf', {y = getProperty('gf.y') + 0}, 0.6, {type = 'PINGPONG', ease = 'quadInOut'})
    end
end

function onUpdate()
    if not gfSection then
        cameraSetTarget((not mustHitSection and 'dad' or 'boyfriend'))
    end
end