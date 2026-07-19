local glowEnabled = false
local particleID = 0

local colors = {
    'FF004D',
    '00E5FF',
    'FFE600',
    'A000FF',
    '00FF85',
    'FF6B00'
}

local currentColor = 'FFFFFF'

local startStep = 832
local endStep = 960

function onCreate()

    makeLuaSprite('glowOverlay', '', -800, -400)
    makeGraphic('glowOverlay', screenWidth * 4, screenHeight * 4, 'FFFFFF')

    setObjectCamera('glowOverlay', 'hud')
    setProperty('glowOverlay.alpha', 0)

    addLuaSprite('glowOverlay', true)

end

function onStepHit()

    glowEnabled = curStep >= startStep and curStep < endStep

    if not glowEnabled then

        setProperty('camHUD.angle', 0)
        setProperty('camGame.angle', 0)

        setProperty('camHUD.x', 0)
        setProperty('camHUD.y', 0)

        setProperty('camGame.x', 0)
        setProperty('camGame.y', 0)

        setProperty('glowOverlay.alpha', 0)

    end

end

function onBeatHit()

    if glowEnabled then

        currentColor = colors[getRandomInt(1, #colors)]

        -- OVERLAY FUERTE
        setProperty('glowOverlay.color',
            getColorFromHex(currentColor))

        setProperty('glowOverlay.alpha', 0.35)

        doTweenAlpha(
            'overlayFade',
            'glowOverlay',
            0,
            0.45,
            'linear'
        )

        -- PARTICULAS
        spawnGlowParticles()

        local side = 1

        if curBeat % 2 == 0 then
            side = -1
        end

        -- MOVIMIENTO DIAGONAL
        setProperty('camHUD.x', 18 * side)
        setProperty('camHUD.y', -10)

        setProperty('camGame.x', 12 * side)
        setProperty('camGame.y', -6)

        -- ROTACION
        setProperty('camHUD.angle', 2 * side)
        setProperty('camGame.angle', 1 * side)

        -- REGRESO
        doTweenX(
            'hudBackX',
            'camHUD',
            0,
            0.3,
            'cubeOut'
        )

        doTweenY(
            'hudBackY',
            'camHUD',
            0,
            0.3,
            'cubeOut'
        )

        doTweenAngle(
            'hudAngleBack',
            'camHUD',
            0,
            0.35,
            'cubeOut'
        )

        doTweenX(
            'gameBackX',
            'camGame',
            0,
            0.35,
            'cubeOut'
        )

        doTweenY(
            'gameBackY',
            'camGame',
            0,
            0.35,
            'cubeOut'
        )

        doTweenAngle(
            'gameAngleBack',
            'camGame',
            0,
            0.4,
            'cubeOut'
        )

    end

end

function spawnGlowParticles()

    for i = 1, 18 do

        particleID = particleID + 1

        local tag = 'particle'..particleID

        local xPos = getRandomInt(0, screenWidth)
        local yPos = getRandomInt(0, screenHeight)

        makeLuaSprite(tag, 'particula', xPos, yPos)

        setObjectCamera(tag, 'hud')

        addLuaSprite(tag, true)

        setBlendMode(tag, 'ADD')

        scaleObject(
            tag,
            getRandomFloat(0.3, 1),
            getRandomFloat(0.3, 1)
        )

        setProperty(tag..'.color',
            getColorFromHex(currentColor))

        setProperty(tag..'.alpha', 1)

        doTweenX(
            tag..'MoveX',
            tag,
            xPos + getRandomInt(-200, 200),
            getRandomFloat(0.4, 0.8),
            'cubeOut'
        )

        doTweenY(
            tag..'MoveY',
            tag,
            yPos - getRandomInt(80, 250),
            getRandomFloat(0.4, 0.8),
            'cubeOut'
        )

        doTweenAlpha(
            tag..'Fade',
            tag,
            0,
            getRandomFloat(0.5, 1),
            'linear'
        )

        runTimer(tag..'Delete', 1)

    end

end

function onTimerCompleted(tag)

    if string.find(tag, 'Delete') then

        local sprite = string.gsub(tag, 'Delete', '')

        removeLuaSprite(sprite, true)

    end

end