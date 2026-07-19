function onEvent(name, value1, value2)
	if name == 'Note Rotate' then
        degrees =  tonumber(value1)
        tween =  tonumber(value2)
        noteTweenAngle('dad1', 0, degrees, tween, 'cubeOut')
        noteTweenAngle('dad2', 1, degrees, tween, 'cubeOut')
        noteTweenAngle('dad3', 2, degrees, tween, 'cubeOut')
        noteTweenAngle('dad4', 3, degrees, tween, 'cubeOut')
        noteTweenAngle('bf1', 4, degrees, tween, 'cubeOut')
        noteTweenAngle('bf2', 5, degrees, tween, 'cubeOut')
        noteTweenAngle('bf3', 6, degrees, tween, 'cubeOut')
        noteTweenAngle('bf4', 7, degrees, tween, 'cubeOut')
        if tween == 0 then
            noteTweenAngle('dad1', 0, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad2', 1, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad3', 2, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad4', 3, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf1', 4, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf2', 5, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf3', 6, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf4', 7, degrees, 0.1, 'cubeOut')
        elseif tween == null then
            noteTweenAngle('dad1', 0, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad2', 1, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad3', 2, degrees, 0.1, 'cubeOut')
            noteTweenAngle('dad4', 3, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf1', 4, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf2', 5, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf3', 6, degrees, 0.1, 'cubeOut')
            noteTweenAngle('bf4', 7, degrees, 0.1, 'cubeOut')
        end
        if degrees == 0 then
            noteTweenAngle('dad1', 0, 360, tween, 'cubeOut')
            noteTweenAngle('dad2', 1, 360, tween, 'cubeOut')
            noteTweenAngle('dad3', 2, 360, tween, 'cubeOut')
            noteTweenAngle('dad4', 3, 360, tween, 'cubeOut')
            noteTweenAngle('bf1', 4, 360, tween, 'cubeOut')
            noteTweenAngle('bf2', 5, 360, tween, 'cubeOut')
            noteTweenAngle('bf3', 6, 360, tween, 'cubeOut')
            noteTweenAngle('bf4', 7, 360, tween, 'cubeOut')
        elseif degrees == null then
            noteTweenAngle('dad1', 0, 360, tween, 'cubeOut')
            noteTweenAngle('dad2', 1, 360, tween, 'cubeOut')
            noteTweenAngle('dad3', 2, 360, tween, 'cubeOut')
            noteTweenAngle('dad4', 3, 360, tween, 'cubeOut')
            noteTweenAngle('bf1', 4, 360, tween, 'cubeOut')
            noteTweenAngle('bf2', 5, 360, tween, 'cubeOut')
            noteTweenAngle('bf3', 6, 360, tween, 'cubeOut')
            noteTweenAngle('bf4', 7, 360, tween, 'cubeOut')
        end
    end
end
function onTweenCompleted(tag)
    if tag == 'dad1' then
        noteTweenAngle('dad1lol', 0, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('dad2lol', 1, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('dad3lol', 2, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('dad4lol', 3, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('bf1lol', 4, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('bf2lol', 5, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('bf3lol', 6, - degrees, 0.0001, 'cubeOut')
        noteTweenAngle('bf4lol', 7, - degrees, 0.0001, 'cubeOut')
    end
end