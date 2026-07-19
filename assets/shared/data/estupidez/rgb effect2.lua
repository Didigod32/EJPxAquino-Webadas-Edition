local shaderName = "rgb effect2"
function onCreatePost()
    if shadersEnabled then
        addHaxeLibrary("ShaderFilter", "openfl.filters")
    	initLuaShader(shaderName)
    	makeLuaSprite("temporaryShader")
    	makeGraphic("temporaryShader", screenWidth, screenHeight)
        setSpriteShader("temporaryShader", shaderName)
    end
end

function onStepHit()
    if shadersEnabled then
        runHaxeCode([[
            var staticEnabled:Bool = false;
            if (game.curStep >= 255 && game.curStep <= 367 || game.curStep >= 704 && game.curStep <= 767) {
                if (!staticEnabled) {
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
                    game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
                    staticEnabled = true;
                }
            }

            if (game.curStep >= 367 && game.curStep <= 704 || game.curStep >= 767) {
                if (staticEnabled) {
                    game.camGame.setFilters();
                    game.camHUD.setFilters(); 
                    staticEnabled = false;
                }
            }
        ]])
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
        setShaderFloat("temporaryShader", "iTime", os.clock())
    end
end