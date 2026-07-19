local shaderName = "lightsrgb"
function onStepHit()
    if shadersEnabled then
        if curStep == 1151 then
            setSpriteShader("temporaryShader", shaderName)
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
            ]])
            if getPropertyFromClass('ClientPrefs', 'framerate') >= 120 then
                setPropertyFromClass('ClientPrefs', 'framerate', 120)
            else 
                setPropertyFromClass('ClientPrefs', 'framerate', 60)
            end
        end
        if curStep == 1280 then
            removeSpriteShader('temporaryShader')
            runHaxeCode([[
                game.camGame.setFilters([]);
            ]])
            setPropertyFromClass('ClientPrefs', 'framerate', framerateOG)
        end
    end
end

function onCreatePost()
    if shadersEnabled then
        shaderCoordFix()
        framerateOG = getPropertyFromClass('ClientPrefs', 'framerate')

    	initLuaShader(shaderName)
    	makeLuaSprite("temporaryShader")
    	makeGraphic("temporaryShader", screenWidth, screenHeight)
    end
end


function onUpdate(elapsed)
    if shadersEnabled then
        setShaderFloat("temporaryShader", "iTime", os.clock())
    end
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        setPropertyFromClass('ClientPrefs', 'framerate', framerateOG)
        if (temp) then
            temp()
        end
    end
end