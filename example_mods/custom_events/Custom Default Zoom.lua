local tweenable = true
function onEvent(n,a,b)
    if n == 'Custom Default Zoom' then
        zoomValue = tonumber(a)
        tween = tonumber(b)

        if tween == 0 then
            tweenable = false;
        elseif tween == null then
            tweenable = false;
        end

        if zoomValue == 0 then
            zoomValue = 0.9;
        elseif zoomValue == null then
            zoomValue = 0.9;
        end

        if tweenable then
            doTweenZoom('zoomTween', 'camGame', zoomValue, tween, 'cubeOut');
        else
            setProperty('defaultCamZoom', zoomValue);
        end
    end
end
function onTweenCompleted(t)
    if t == 'zoomTween' then
        setProperty('defaultCamZoom', zoomValue);
    end
end