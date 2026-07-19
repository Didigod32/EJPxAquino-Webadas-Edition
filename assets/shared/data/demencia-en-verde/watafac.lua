
local effectActive = false

function onCreatePost()

    makeLuaSprite('dramaticBlackBG', '', -1000, -400)
    makeGraphic('dramaticBlackBG', screenWidth * 4, screenHeight * 4, '000000')

    setProperty('dramaticBlackBG.alpha', 0)
    addLuaSprite('dramaticBlackBG', false)

    -------------------------------------------------
    -- SHADER VERDE PARA EL OPONENTE
    -------------------------------------------------
    initLuaShader("adjustColor")

    makeLuaSprite("dadShader")
    makeGraphic("dadShader", 10, 10)

    setSpriteShader("dadShader", "adjustColor")

    -- tono verde oscuro
    setShaderFloat("dadShader", "hue", -25)
    setShaderFloat("dadShader", "saturation", 0.35)
    setShaderFloat("dadShader", "brightness", -0.15)

    setSpriteShader("dad", "adjustColor")
end

function onStepHit()
    if curStep == 512 then
        effectActive = true

        doTweenZoom(
            "focusZoom",
            "camGame",
            0.82,
            4,
            "sineInOut"
        )
        doTweenAlpha(
                'dramaticBGIn',
                'dramaticBlackBG',
                0.35,
                0.4,
                'linear'
        )

    end

    if curStep == 768 then
        effectActive = false

        doTweenZoom(
            "returnZoom",
            "camGame",
            1,
            3,
            "sineOut"
        )
        doTweenAlpha(
                'dramaticBGOut',
                'dramaticBlackBG',
                0,
                0.4,
                'linear'
        )

        setProperty("dad.offset.x", 0)
        setProperty("dad.offset.y", 0)

        -- regresar sustain notes
        for i = 0, getProperty('unspawnNotes.length') - 1 do

            if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
                setPropertyFromGroup('unspawnNotes', i, 'offsetX', 0)
                setPropertyFromGroup('unspawnNotes', i, 'offsetY', 0)
                setPropertyFromGroup('unspawnNotes', i, 'angle', 0)
            end
        end
    end
end

function onUpdate(elapsed)

    if effectActive then

        setProperty(
            "dad.offset.x",
            math.sin(os.clock() * 18) * 5
        )

        setProperty(
            "dad.offset.y",
            math.cos(os.clock() * 15) * 4
        )

        for i = 0, getProperty('unspawnNotes.length') - 1 do

            if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then

                local wave = math.sin((os.clock() * 16) + i)

                setPropertyFromGroup(
                    'unspawnNotes',
                    i,
                    'offsetX',
                    wave * 14
                )

                setPropertyFromGroup(
                    'unspawnNotes',
                    i,
                    'offsetY',
                    math.cos((os.clock() * 12) + i) * 5
                )

                setPropertyFromGroup(
                    'unspawnNotes',
                    i,
                    'angle',
                    wave * 10
                )
            end
        end
    end
end