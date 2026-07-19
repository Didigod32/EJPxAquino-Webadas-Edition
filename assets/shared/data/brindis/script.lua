function onStepHit()
    if curStep == 2 then
        doTweenAlpha('b', 'b', 0, 3, 'cubeInOut')
    end
end
function onCreatePost()
    makeLuaSprite('b', nil, -100, -100)
    makeGraphic('b', 2000, 2000, '000000')
    addLuaSprite('b', true)
    setObjectCamera('b', 'other')
    doTweenZoom('zoomTween', 'camGame', 1, 1, 'cubeOut');
end