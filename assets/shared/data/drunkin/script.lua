function onStepHit()
    if curStep == 144 then
        removeLuaSprite('bg', true)
        setProperty('luz.alpha', 1)
    end
    if curStep == 544 then
        setProperty('luz.alpha', 0)
    end
    if curStep == 669 then
        setProperty('luz.alpha', 1)
    end
end
