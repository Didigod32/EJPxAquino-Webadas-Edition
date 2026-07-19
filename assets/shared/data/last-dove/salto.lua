-------------------------------------------------
-- REBOTE NATURAL DE LUCHADOR
-- saltan AL TOCAR EL SUELO
-------------------------------------------------

local bounceMode = false

local bfX = 0
local bfY = 0

local dadX = 0
local dadY = 0

local side = false

function onCreatePost()

    bfX = getProperty('boyfriend.x')
    bfY = getProperty('boyfriend.y')

    dadX = getProperty('dad.x')
    dadY = getProperty('dad.y')

end

function onStepHit()

    -------------------------------------------------
    -- ACTIVAR
    -------------------------------------------------

    if curStep == 848 then

        bounceMode = true

        boxerBounce()

    end

    -------------------------------------------------
    -- DESACTIVAR
    -------------------------------------------------

    if curStep == 1234 then

        bounceMode = false

        doTweenX('bfResetX', 'boyfriend', bfX, 0.3, 'sineOut')
        doTweenY('bfResetY', 'boyfriend', bfY, 0.3, 'sineOut')

        doTweenX('dadResetX', 'dad', dadX, 0.3, 'sineOut')
        doTweenY('dadResetY', 'dad', dadY, 0.3, 'sineOut')

    end
end

-------------------------------------------------
-- REBOTE
-------------------------------------------------

function boxerBounce()

    if not bounceMode then
        return
    end

    side = not side

    local bfTargetX = bfX
    local dadTargetX = dadX

    -------------------------------------------------
    -- CAMBIO DE LADO
    -------------------------------------------------

    if side then

        bfTargetX = bfX - 18
        dadTargetX = dadX + 18

    else

        bfTargetX = bfX + 18
        dadTargetX = dadX - 18

    end

    -------------------------------------------------
    -- SALTO
    -------------------------------------------------

    doTweenY(
        'bfJump',
        'boyfriend',
        bfY - 14,
        0.12,
        'sineOut'
    )

    doTweenX(
        'bfMove',
        'boyfriend',
        bfTargetX,
        0.22,
        'sineInOut'
    )

    doTweenY(
        'dadJump',
        'dad',
        dadY - 14,
        0.12,
        'sineOut'
    )

    doTweenX(
        'dadMove',
        'dad',
        dadTargetX,
        0.22,
        'sineInOut'
    )

    -------------------------------------------------
    -- CAER
    -------------------------------------------------

    runTimer('land', 0.20)

end

function onTimerCompleted(tag)

    if tag == 'land' and bounceMode then

        -------------------------------------------------
        -- TOCAR SUELO
        -------------------------------------------------

        doTweenY(
            'bfLand',
            'boyfriend',
            bfY,
            0.10,
            'cubeIn'
        )

        doTweenY(
            'dadLand',
            'dad',
            dadY,
            0.10,
            'cubeIn'
        )

        -------------------------------------------------
        -- ESPERAR Y REBOTAR OTRA VEZ
        -------------------------------------------------

        runTimer('nextBounce', 0.20)

    elseif tag == 'nextBounce' and bounceMode then

        boxerBounce()

    end
end