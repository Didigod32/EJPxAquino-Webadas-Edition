function onCreate()
    addHaxeLibrary("ShaderFilter", "openfl.filters")
    initLuaShader("static")
    makeLuaSprite("temporaryShader")
    makeGraphic("temporaryShader", screenWidth, screenHeight)        
    setSpriteShader("temporaryShader", "static")
end

function onStepHit()

    if not shadersEnabled then
        return
    end

    local shouldEnable =
        (curStep >= 512 and curStep <= 768)
        or
        (curStep >= 1664 and curStep <= 1794)


    if shouldEnable and not staticEnabled then

        staticEnabled = true

        runHaxeCode([[
            game.camGame.setFilters([
                new ShaderFilter(game.getLuaObject("temporaryShader").shader)
            ]);
        ]])
    end

    if not shouldEnable and staticEnabled then

        staticEnabled = false

        runHaxeCode([[
            game.camGame.setFilters([]);
        ]])
    end
end

function onGameOverStart()
    if shadersEnabled then
        runHaxeCode("game.camGame.setFilters();")
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
        setShaderFloat("temporaryShader", "iTime", os.clock())
    end
end