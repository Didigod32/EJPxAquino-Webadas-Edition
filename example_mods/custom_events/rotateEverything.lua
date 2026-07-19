function onEvent(name, value1, value2)
    if name == 'rotateEverything' then
        

        local targetAngle = tonumber(value1)
        if targetAngle == nil then
            targetAngle = 0
        end

        local duration = tonumber(value2)
        if duration == nil or duration <= 0 then
            duration = 0
        end


        local easeType = 'quadOut'

        if duration == 0 then
            setProperty('camGame.angle', targetAngle)
            setProperty('camHUD.angle', targetAngle)
        else

            doTweenAngle('rotEverythingGame', 'camGame', targetAngle, duration, easeType)
            doTweenAngle('rotEverythingHUD', 'camHUD', targetAngle, duration, easeType)
        end
    end
end