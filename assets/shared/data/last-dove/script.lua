local things = {'scoreTxt', 'timeTxt', 'timeBar', 'timeBarBG', 'healthBar', 'healthBarBG', 'iconP1', 'iconP2'}
local cinematicActive = false
local swayTimer = 0
local baseCamX, baseCamY = 998, 385
local origZoom, origCameraSpeed = 1, 1
local barHeight = 65
local glowReady = false
local glowActive = false

function onCreatePost()
    origZoom = getProperty('defaultCamZoom')
    origCameraSpeed = getProperty('cameraSpeed')

    makeLuaSprite('blackbg', nil, -1500, -1000)
    makeGraphic('blackbg', 4500, 3000, '000000')
    setScrollFactor('blackbg', 0, 0)
    setProperty('blackbg.alpha', 0)
    addLuaSprite('blackbg', false)
    setObjectOrder('blackbg', getObjectOrder('boyfriendGroup') - 1)

    makeLuaSprite('barraArriba', nil, 0, -barHeight)
    makeGraphic('barraArriba', screenWidth, barHeight, '000000')
    setObjectCamera('barraArriba', 'hud')
    addLuaSprite('barraArriba', false)

    makeLuaSprite('barraAbajo', nil, 0, screenHeight)
    makeGraphic('barraAbajo', screenWidth, barHeight, '000000')
    setObjectCamera('barraAbajo', 'hud')
    addLuaSprite('barraAbajo', false)

    -- uiGroup se dibuja por debajo de noteGroup en P-Slice 2.1.
    runHaxeCode([[
        var topBar = game.getLuaObject('barraArriba');
        var bottomBar = game.getLuaObject('barraAbajo');
        if (topBar != null && bottomBar != null) {
            game.remove(topBar, true);
            game.remove(bottomBar, true);
            game.uiGroup.insert(0, bottomBar);
            game.uiGroup.insert(0, topBar);
        }
    ]])

    -- El shader se carga solo si el motor lo permite.
    glowReady = initLuaShader('cinematicBright') == true
    if glowReady then
        makeLuaSprite('cinematicShader', nil, 0, 0)
        makeGraphic('cinematicShader', 1, 1, 'FFFFFF')
        setSpriteShader('cinematicShader', 'cinematicBright')
        setShaderFloat('cinematicShader', 'strength', 0.14)
        addHaxeLibrary('ShaderFilter', 'openfl.filters')
    end
end

local function enableGlow()
    if not glowReady or glowActive then return end
    runHaxeCode([[
        var sprite = game.getLuaObject('cinematicShader');
        if (sprite != null && sprite.shader != null) {
            var filter = new ShaderFilter(sprite.shader);
            game.variables.set('aquinobyGlowFilter', filter);
            var gameFilters = game.camGame.filters == null ? [] : game.camGame.filters.copy();
            var hudFilters = game.camHUD.filters == null ? [] : game.camHUD.filters.copy();
            gameFilters.push(filter);
            hudFilters.push(filter);
            game.camGame.filters = gameFilters;
            game.camHUD.filters = hudFilters;
        }
    ]])
    glowActive = true
end

local function disableGlow()
    if not glowActive then return end
    runHaxeCode([[
        var filter = game.variables.get('aquinobyGlowFilter');
        if (filter != null) {
            var gameFilters = game.camGame.filters == null ? [] : game.camGame.filters.copy();
            var hudFilters = game.camHUD.filters == null ? [] : game.camHUD.filters.copy();
            gameFilters.remove(filter);
            hudFilters.remove(filter);
            game.camGame.filters = gameFilters.length == 0 ? null : gameFilters;
            game.camHUD.filters = hudFilters.length == 0 ? null : hudFilters;
            game.variables.remove('aquinobyGlowFilter');
        }
    ]])
    glowActive = false
end

function onStepHit()
    if curStep == 605 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('camA', 'camFollow', 898, 0.8, 'sineOut')
        doTweenY('camA2', 'camFollow', 468, 0.8, 'sineOut')

    elseif curStep == 638 then
        doTweenX('camD', 'camFollow', 554, 0.8, 'sineOut')
        doTweenY('camD2', 'camFollow', 453, 0.8, 'sineOut')

    elseif curStep == 656 then
        cameraFlash('hud', 'FFFFFF', 0.5)
        enableGlow()

        doTweenY('bArriba', 'barraArriba', 0, 0.5, 'sineOut')
        doTweenY('bAbajo', 'barraAbajo', screenHeight - barHeight, 0.5, 'sineOut')

        for i = 1, #things do
            doTweenAlpha('A' .. things[i], things[i], 0, 0.5, 'sineOut')
        end

        doTweenAlpha('fadeBlackBg', 'blackbg', 0.85, 0.4, 'sineOut')
        doTweenAlpha('Agf', 'gf', 0, 0.2, 'sineOut')
        doTweenAlpha('Adad', 'dad', 0, 0.2, 'sineOut')

        for i = 0, 3 do
            noteTweenAlpha('hideOp' .. i, i, 0, 0.3, 'sineOut')
            if not middlescroll then
                noteTweenX('toMid' .. i, i + 4, _G['defaultPlayerStrumX' .. i] - 278, 0.4, 'sineOut')
            end
        end

        baseCamX = getMidpointX('boyfriend') - 60
        baseCamY = getMidpointY('boyfriend') - 135
        setProperty('isCameraOnForcedPos', true)
        setProperty('cameraSpeed', 2.5)
        setProperty('camFollow.x', baseCamX)
        setProperty('camFollow.y', baseCamY)
        setProperty('defaultCamZoom', origZoom + 0.38)
        doTweenZoom('zoomFace', 'camGame', origZoom + 0.38, 0.8, 'sineOut')

        cinematicActive = true
        swayTimer = 0

    elseif curStep == 783 then
        cameraFlash('hud', 'FFFFFF', 0.5)
        cinematicActive = false
        disableGlow()

        doTweenY('bArriba', 'barraArriba', -barHeight, 0.5, 'sineIn')
        doTweenY('bAbajo', 'barraAbajo', screenHeight, 0.5, 'sineIn')

        for i = 1, #things do
            doTweenAlpha('A' .. things[i], things[i], 1, 0.5, 'sineOut')
        end

        doTweenAlpha('fadeBlackBg', 'blackbg', 0, 0.3, 'sineOut')
        doTweenAlpha('Agf', 'gf', 1, 0.2, 'sineOut')
        doTweenAlpha('Adad', 'dad', 1, 0.2, 'sineOut')

        for i = 0, 3 do
            noteTweenAlpha('showOp' .. i, i, 1, 0.4, 'sineOut')
            if not middlescroll then
                noteTweenX('backNorm' .. i, i + 4, _G['defaultPlayerStrumX' .. i], 0.4, 'sineOut')
            end
        end

        setProperty('defaultCamZoom', origZoom)
        doTweenZoom('zoomReset', 'camGame', origZoom, 0.5, 'sineOut')
        setProperty('cameraSpeed', origCameraSpeed)
        setProperty('isCameraOnForcedPos', false)

    elseif curStep == 1375 then
        doTweenAlpha('hud', 'camHUD', 0, 0.5, 'sineInOut')
    end
end

function onUpdate(elapsed)
    if not cinematicActive then return end
    swayTimer = swayTimer + elapsed
    local offsetHorizontal = math.sin(swayTimer * 1.6) * 45
    setProperty('camFollow.x', baseCamX + offsetHorizontal)
    setProperty('camFollow.y', baseCamY)
end

function onDestroy()
    disableGlow()
end


local glowStart = 656
local glowEnd = 783

local glowColor = 'FFF2B0'
local glowDuration = 0.30

function onBeatHit()
    if curStep >= glowStart and curStep < glowEnd then
        setProperty('boyfriend.color', getColorFromHex(glowColor))

        doTweenColor(
            'bfBeatGlow',
            'boyfriend',
            'FFFFFF',
            glowDuration,
            'sineOut'
        )
    end
end
