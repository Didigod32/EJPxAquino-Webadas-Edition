local shotgunNotes = false

local defaultX = {}
local defaultY = {}

function onCreatePost()

    for i = 0,7 do

        defaultX[i] = getPropertyFromGroup('strumLineNotes', i, 'x')
        defaultY[i] = getPropertyFromGroup('strumLineNotes', i, 'y')

    end
end


function onStepHit()

    if curStep == 768 then
        shotgunNotes = true
    end

    if curStep == 9999 then

        shotgunNotes = false

        for i = 0,7 do

            noteTweenX(
                'resetX'..i,
                i,
                defaultX[i],
                0.2,
                'cubeOut'
            )

            noteTweenY(
                'resetY'..i,
                i,
                defaultY[i],
                0.2,
                'cubeOut'
            )

            noteTweenAngle(
                'resetAngle'..i,
                i,
                0,
                0.2,
                'cubeOut'
            )

        end
    end
end

function onBeatHit()

    if shotgunNotes then

        for i = 0,7 do



            local offsetX = getRandomInt(-18,18)
            local offsetY = getRandomInt(-10,10)
            local angle = getRandomInt(-8,8)


            noteTweenX(
                'shotX'..i,
                i,
                defaultX[i] + offsetX,
                crochet / 1400,
                'quadOut'
            )

            noteTweenY(
                'shotY'..i,
                i,
                defaultY[i] + offsetY,
                crochet / 1400,
                'quadOut'
            )

            noteTweenAngle(
                'shotA'..i,
                i,
                angle,
                crochet / 1400,
                'quadOut'
            )

            runTimer('reset'..i, crochet / 2200, 1)

        end
    end
end

function onTimerCompleted(tag)

    if string.sub(tag,1,5) == 'reset' then

        local i = tonumber(string.sub(tag,6))

        noteTweenX(
            'backX'..i,
            i,
            defaultX[i],
            crochet / 1700,
            'cubeOut'
        )

        noteTweenY(
            'backY'..i,
            i,
            defaultY[i],
            crochet / 1700,
            'cubeOut'
        )

        noteTweenAngle(
            'backA'..i,
            i,
            0,
            crochet / 1700,
            'cubeOut'
        )
    end
end