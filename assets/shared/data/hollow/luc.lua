local particleCount = 0
local activeParticles = 0
local maxParticles = 25

local particlesEnabled = false

local startStep = 0
local endStep = 99999

function onStepHit()

    particlesEnabled = curStep >= startStep and curStep < endStep

end

function onUpdate(elapsed)

    if particlesEnabled then

        if activeParticles < maxParticles then

            if getRandomInt(1, 100) <= 5 then
                spawnFirefly()
            end

        end

    end

end

function spawnFirefly()

    particleCount = particleCount + 1
    activeParticles = activeParticles + 1

    local tag = 'firefly'..particleCount

    local xPos = getRandomInt(-200, screenWidth + 200)
    local yPos = getRandomInt(100, screenHeight + 100)

    makeLuaSprite(tag, 'luc', xPos, yPos)

    addLuaSprite(tag, false)

    setBlendMode(tag, 'ADD')

    local scale = getRandomFloat(0.15, 0.45)
    scaleObject(tag, scale, scale)

    setProperty(tag..'.alpha', 0)

    -- Aparición
    doTweenAlpha(
        tag..'FadeIn',
        tag,
        getRandomFloat(0.3, 0.8),
        getRandomFloat(1, 2),
        'sineInOut'
    )

    -- Movimiento horizontal tipo vuelo
    local moveX = xPos + getRandomInt(-200, 200)

    doTweenX(
        tag..'MoveX',
        tag,
        moveX,
        getRandomFloat(5, 10),
        'sineInOut'
    )

    -- Movimiento vertical suave
    local moveY = yPos - getRandomInt(20, 80)

    doTweenY(
        tag..'MoveY',
        tag,
        moveY,
        getRandomFloat(4, 8),
        'sineInOut'
    )

    -- Parpadeo
    flickerFirefly(tag)

    -- Vida útil
    runTimer(tag..'Delete', getRandomFloat(6, 10))

end

function flickerFirefly(tag)

    if luaSpriteExists(tag) then

        local newAlpha = getRandomFloat(0.2, 0.85)

        doTweenAlpha(
            tag..'Flicker',
            tag,
            newAlpha,
            getRandomFloat(0.3, 1),
            'sineInOut'
        )

        runTimer(
            tag..'Reflicker',
            getRandomFloat(0.4, 1.2)
        )

    end

end

function onTimerCompleted(tag)

    -- continuar parpadeo
    if string.find(tag, 'Reflicker') then

        local sprite = string.gsub(tag, 'Reflicker', '')

        flickerFirefly(sprite)

    end

    -- empezar desaparición
    if string.find(tag, 'Delete') then

        local sprite = string.gsub(tag, 'Delete', '')

        doTweenAlpha(
            sprite..'FadeOut',
            sprite,
            0,
            1,
            'linear'
        )

        runTimer(sprite..'Remove', 1)

    end

    -- eliminar
    if string.find(tag, 'Remove') then

        local sprite = string.gsub(tag, 'Remove', '')

        removeLuaSprite(sprite, true)

        activeParticles = activeParticles - 1

    end

end

function luaSpriteExists(tag)

    return getProperty(tag..'.alpha') ~= nil

end