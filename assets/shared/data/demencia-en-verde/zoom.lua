function onStepHit()
   -- if curStep == 1070  then
   --     doTweenAlpha('HUDgone', 'camHUD', 0, 0.1, linear);
   -- end    
    if curStep == 128  then
        setProperty('defaultCamZoom', 1);
    end    
    if curStep == 192  then    
        setProperty('defaultCamZoom', 0.75);    
    end    
    if curStep == 208  then
        setProperty('defaultCamZoom', 0.9);
    end         
    if curStep == 224  then    
       setProperty('defaultCamZoom', 0.75);  
    end     
    if curStep == 239  then
        setProperty('defaultCamZoom', 0.9);           
    end
    if curStep == 255  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 718  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 735  then
        setProperty('defaultCamZoom', 0.75);
    end
    if curStep == 752  then
        setProperty('defaultCamZoom', 0.8);
    end
    if curStep == 760  then
        setProperty('defaultCamZoom', 0.85);
    end
    if curStep == 767  then
        setProperty('defaultCamZoom', 0.75);
    end
end

local pixelEnabled = false

function onCreate()


    initLuaShader('pixel')

    makeLuaSprite('pixelShader')

    makeGraphic(
        'pixelShader',
        screenWidth,
        screenHeight
    )

    setSpriteShader(
        'pixelShader',
        'pixel'
    )
end


local pixelActive = false

function onCreate()


    addHaxeLibrary("ShaderFilter", "openfl.filters")

    initLuaShader("pixel")

    makeLuaSprite("pixelShader")
    makeGraphic(
        "pixelShader",
        screenWidth,
        screenHeight
    )

    setSpriteShader(
        "pixelShader",
        "pixel"
    )
end

function onCreate()
    initLuaShader('pixel')
    
    makeLuaSprite('shaderHolder', '', 0, 0)
    setSpriteShader('shaderHolder', 'pixel')
    
    setShaderFloat('shaderHolder', 'pxSize', 0.0) 

    makeLuaSprite('dummyPixel', '', 0, 0)


    makeLuaSprite('blackScreen', '', 0, 0)

    makeGraphic(
        'blackScreen',
        screenWidth * 4,
        screenHeight * 4,
        '000000'
    )

    setObjectCamera('blackScreen', 'other')

    setProperty('blackScreen.alpha', 0)

    addLuaSprite('blackScreen', true)

end

function onStepHit()
    if curStep == 1790 then

        runHaxeCode([[
            var shader = game.getLuaObject('shaderHolder').shader;
            game.camGame.setFilters([new ShaderFilter(shader)]);
            game.camHUD.setFilters([new ShaderFilter(shader)]);
        ]])


        

        doTweenX('animarPixel', 'dummyPixel', 30.0, 1.5, 'cubeIn')
        
        cameraShake('camGame', 0.04, 1.5)
        cameraShake('camHUD', 0.03, 1.5)
        
        setProperty('defaultCamZoom', 2.0) 
        setProperty('camGame.zoom', 2.0)
    end
    if curStep == 1795 then

    setProperty('blackScreen.alpha', 1)

    end
end

function onUpdate(elapsed)
    local valorPixel = getProperty('dummyPixel.x')
    
    if valorPixel > 0 then
        setShaderFloat('shaderHolder', 'pxSize', valorPixel)
    end
end