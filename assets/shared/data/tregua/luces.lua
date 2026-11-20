local stepEntrada     = 384  
local stepDuetoInicio = 512  
local stepDuetoFin    = 576  
local stepApagar      = 768  
local stepTvOscura    = 1022 
local stepFiestaInic  = 1152 
local stepFiestaFin   = 1280 

-- Ajustes de posición
local alturaTechoOffset = -275 
local offsetDadX        = -65  
local offsetBFX         = -15  
local ajustePisoY       = 35   

local escalaLinternaX   = 1.25 
local escalaLinternaY   = 0.95 
local escalaHazX        = 0.85 
local opacidadLuz       = 0.38 

local tiempoEntrada     = 0.85 
local tiempoGiro        = 0.42 
local offsetAnguloFoco  = 28

local pivote1X, pivote2X, pivoteY = 0, 0, 0
local centroDadX, centroBFX, pisoY = 0, 0, 0
local lucesActivas = false
local modoDueto    = false
local modoTvOscura = false 
local shaderNombre = "uh"

function onCreatePost()
    centroDadX = getMidpointX('dad') + offsetDadX
    centroBFX  = getMidpointX('boyfriend') + offsetBFX

    local piesDad = getProperty('dad.y') + getProperty('dad.height')
    local piesBF  = getProperty('boyfriend.y') + getProperty('boyfriend.height')
    pisoY = math.max(piesDad, piesBF) + ajustePisoY

    local refY = (getProperty('gf') ~= nil) and getMidpointY('gf') or getMidpointY('dad')
    pivote1X = centroDadX
    pivote2X = centroBFX
    pivoteY  = refY + alturaTechoOffset

    -- Haces de luz
    for i = 1, 2 do
        local tagHaz = 'hazLuz' .. i
        local pX = (i == 1) and pivote1X or pivote2X

        makeLuaSprite(tagHaz, 'spotlight', 0, 0)
        setProperty(tagHaz .. '.scale.x', escalaHazX)
        setProperty(tagHaz .. '.scale.y', 0.75)
        setProperty(tagHaz .. '.offset.x', 0)
        setProperty(tagHaz .. '.offset.y', 0)

        local origX = getProperty(tagHaz .. '.frameWidth') * 0.48
        local origY = 55
        setProperty(tagHaz .. '.origin.x', origX)
        setProperty(tagHaz .. '.origin.y', origY)

        setProperty(tagHaz .. '.x', pX - origX)
        setProperty(tagHaz .. '.y', pivoteY - origY)

        setBlendMode(tagHaz, 'add')
        setProperty(tagHaz .. '.alpha', 0)
        addLuaSprite(tagHaz, true)
    end

    -- Focos
    for i = 1, 2 do
        local tagLinterna = 'linterna' .. i
        local pX = (i == 1) and pivote1X or pivote2X

        makeLuaSprite(tagLinterna, 'stage_light', 0, 0)
        setProperty(tagLinterna .. '.scale.x', escalaLinternaX)
        setProperty(tagLinterna .. '.scale.y', escalaLinternaY)
        setProperty(tagLinterna .. '.offset.x', 0)
        setProperty(tagLinterna .. '.offset.y', 0)

        local origX = getProperty(tagLinterna .. '.frameWidth') * 0.53
        local origY = getProperty(tagLinterna .. '.frameHeight') * 0.66
        setProperty(tagLinterna .. '.origin.x', origX)
        setProperty(tagLinterna .. '.origin.y', origY)

        setProperty(tagLinterna .. '.x', pX - origX)
        setProperty(tagLinterna .. '.y', (pivoteY - origY) - 550)

        addLuaSprite(tagLinterna, true)
    end

    -- Overlays de cierre general (camOther y camHUD)
    runHaxeCode([[
        var globalFade = new flixel.FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFF000000);
        globalFade.screenCenter();
        globalFade.cameras = [game.camOther];
        globalFade.alpha = 0;
        game.add(globalFade);
        game.variables.set('globalFadeOverlay', globalFade);

        var hudOverlay = new flixel.FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFF000000);
        hudOverlay.screenCenter();
        hudOverlay.cameras = [game.camHUD];
        hudOverlay.alpha = 0;
        game.add(hudOverlay);
        game.variables.set('hudFadeOverlay', hudOverlay);
    ]])

    -- Inicializar Shaders
    runHaxeCode([[
        try {
            game.initLuaShader(']] .. shaderNombre .. [[');
            var cinemaShader = game.createRuntimeShader(']] .. shaderNombre .. [[');
            game.variables.set('cinemaShaderInstance', cinemaShader);
        } catch(e:Dynamic) {}

        var glslBlur:String = "
            #pragma header
            uniform float blurAmount;
            void main() {
                vec2 uv = openfl_TextureCoordv;
                vec4 col = flixel_texture2D(bitmap, uv);
                if (blurAmount <= 0.001) {
                    gl_FragColor = col;
                    return;
                }
                vec2 r = vec2(0.0035 * blurAmount, 0.0035 * blurAmount);
                vec4 sum = col * 0.28;
                sum += flixel_texture2D(bitmap, uv + vec2(r.x, 0.0)) * 0.12;
                sum += flixel_texture2D(bitmap, uv - vec2(r.x, 0.0)) * 0.12;
                sum += flixel_texture2D(bitmap, uv + vec2(0.0, r.y)) * 0.12;
                sum += flixel_texture2D(bitmap, uv - vec2(0.0, r.y)) * 0.12;
                sum += flixel_texture2D(bitmap, uv + vec2(r.x, r.y)) * 0.06;
                sum += flixel_texture2D(bitmap, uv - vec2(r.x, r.y)) * 0.06;
                sum += flixel_texture2D(bitmap, uv + vec2(r.x, -r.y)) * 0.06;
                sum += flixel_texture2D(bitmap, uv - vec2(r.x, -r.y)) * 0.06;
                gl_FragColor = sum;
            }
        ";
        try {
            var bShader = new flixel.addons.display.FlxRuntimeShader(glslBlur);
            bShader.setFloat('blurAmount', 1.0);
            game.variables.set('spotlightBlurShader', bShader);
        } catch(e:Dynamic) {}
    ]])
end

function toggleShaderCinematico(activar)
    runHaxeCode([[
        var activar:Bool = ]] .. tostring(activar) .. [[;
        if (activar) {
            var shaderInst = game.variables.get('cinemaShaderInstance');
            if (shaderInst != null) {
                game.camGame.setFilters([new openfl.filters.ShaderFilter(shaderInst)]);
            }
        } else {
            game.camGame.setFilters([]);
        }
    ]])
end

function activarAmbienteTvOscura(activar)
    modoTvOscura = activar
    if activar then
        runHaxeCode([[
            var matrizBN:Array<Float> = [
                0.33, 0.59, 0.11, 0, 0,
                0.33, 0.59, 0.11, 0, 0,
                0.33, 0.59, 0.11, 0, 0,
                0,    0,    0,    1, 0
            ];
            var bwFilter = new openfl.filters.ColorMatrixFilter(matrizBN);
            game.camGame.setFilters([bwFilter]);
        ]])
        snapCamaraInstantanea()
    else
        runHaxeCode([[
            game.camGame.setFilters([]);
        ]])
    end
end

function snapCamaraInstantanea()
    runHaxeCode([[
        game.moveCameraSection();
        game.camGame.scroll.set(
            game.camFollow.x - (game.camGame.width * 0.5),
            game.camFollow.y - (game.camGame.height * 0.5)
        );
    ]])
end

function actualizarIluminacionPersonajes(quienCanta)
    runHaxeCode([[
        var modo = "]] .. quienCanta .. [[";
        var bShader = game.variables.get('spotlightBlurShader');
        var colorFondo:Int = 0xFF2A2A38;
        var colorLuz:Int   = 0xFFFFFFFF;

        var lin1 = game.getLuaObject('linterna1');
        var lin2 = game.getLuaObject('linterna2');
        var haz1 = game.getLuaObject('hazLuz1');
        var haz2 = game.getLuaObject('hazLuz2');

        for (member in game.members)
        {
            if (member == null || member == game.dadGroup || member == game.boyfriendGroup) continue;
            if (member == lin1 || member == lin2 || member == haz1 || member == haz2) continue;

            var enCamGame:Bool = (member.cameras == null || member.cameras.length == 0 || member.cameras.contains(game.camGame));
            if (!enCamGame) continue;

            if (Std.isOfType(member, flixel.group.FlxSpriteGroup))
            {
                var grp:flixel.group.FlxSpriteGroup = cast member;
                for (sub in grp.members)
                {
                    if (sub != null && Std.isOfType(sub, flixel.FlxSprite))
                    {
                        var spr:flixel.FlxSprite = cast sub;
                        spr.color = (modo == 'restaurar') ? colorLuz : colorFondo;
                        spr.shader = (modo == 'restaurar') ? null : bShader;
                    }
                }
            }
            else if (Std.isOfType(member, flixel.FlxSprite))
            {
                var spr:flixel.FlxSprite = cast member;
                spr.color = (modo == 'restaurar') ? colorLuz : colorFondo;
                spr.shader = (modo == 'restaurar') ? null : bShader;
            }
        }

        if (game.dad != null) { game.dad.color = colorLuz; game.dad.shader = null; }
        if (game.boyfriend != null) { game.boyfriend.color = colorLuz; game.boyfriend.shader = null; }
    ]])
end

function calcularGeometriaHaz(indiceLuz, personaje)
    local pX = (indiceLuz == 1) and pivote1X or pivote2X
    local pY = pivoteY
    local targetX = (personaje == 'dad') and centroDadX or centroBFX
    local dx = targetX - pX
    local dy = pisoY - pY
    local angulo = -math.deg(math.atan2(dx, dy))
    local distancia = math.sqrt((dx * dx) + (dy * dy))
    local escalaY = (distancia / 1060.0) * ((math.abs(dx) > 50) and 1.10 or 1.02)
    local anguloFoco = (angulo * 0.35) + offsetAnguloFoco
    return angulo, escalaY, anguloFoco
end

function apuntarLuz(indiceLuz, personaje, instantaneo)
    local tagLinterna = 'linterna' .. indiceLuz
    local tagHaz      = 'hazLuz' .. indiceLuz
    local anguloHaz, largoHaz, anguloFoco = calcularGeometriaHaz(indiceLuz, personaje)

    if instantaneo then
        setProperty(tagHaz .. '.angle', anguloHaz)
        setProperty(tagHaz .. '.scale.y', largoHaz)
        setProperty(tagLinterna .. '.angle', anguloFoco)
    else
        doTweenAngle('giroHaz' .. indiceLuz, tagHaz, anguloHaz, tiempoGiro, 'sineInOut')
        doTweenY('largoHaz' .. indiceLuz, tagHaz .. '.scale', largoHaz, tiempoGiro, 'sineInOut')
        doTweenAngle('giroLin' .. indiceLuz, tagLinterna, anguloFoco, tiempoGiro, 'sineInOut')
    end
end

function onStepHit()
    if curStep == stepEntrada then
        local cantanteInicial = mustHitSection and 'boyfriend' or 'dad'
        for i = 1, 2 do
            local tagLinterna = 'linterna' .. i
            local origY = getProperty(tagLinterna .. '.origin.y')
            local destinoY = pivoteY - origY
            local _, _, anguloFocoFinal = calcularGeometriaHaz(i, cantanteInicial)
            setProperty(tagLinterna .. '.angle', anguloFocoFinal - 720)
            doTweenY('bajarLinterna' .. i, tagLinterna, destinoY, tiempoEntrada, 'quartOut')
            doTweenAngle('girarEntrada' .. i, tagLinterna, anguloFocoFinal, tiempoEntrada, 'quartOut')
        end
    end

    if curStep == stepDuetoInicio and lucesActivas then
        modoDueto = true
        apuntarLuz(1, 'dad', false)
        apuntarLuz(2, 'boyfriend', false)
        actualizarIluminacionPersonajes('ambos')
    end

    if curStep == stepDuetoFin and lucesActivas then
        modoDueto = false
        local cantanteActual = mustHitSection and 'boyfriend' or 'dad'
        apuntarLuz(1, cantanteActual, false)
        apuntarLuz(2, cantanteActual, false)
        actualizarIluminacionPersonajes(cantanteActual)
    end

    if curStep == stepApagar and lucesActivas then
        lucesActivas = false
        actualizarIluminacionPersonajes('restaurar')
        toggleShaderCinematico(false)
        for i = 1, 2 do
            local tagLinterna = 'linterna' .. i
            local origY = getProperty(tagLinterna .. '.origin.y')
            doTweenAlpha('apagarHaz' .. i, 'hazLuz' .. i, 0, 0.35, 'sineOut')
            doTweenY('subirLinterna' .. i, tagLinterna, (pivoteY - origY) - 550, 0.8, 'backIn')
        end
    end

    if curStep == stepTvOscura then
        activarAmbienteTvOscura(true)
    end

    if curStep == 1151 then
        activarAmbienteTvOscura(false)
    end

    if curStep == stepFiestaInic then
        toggleShaderCinematico(true)
    end

    -- STEP 1280: Fin de fiesta, fundido general y zoom out hasta el 1408
    if curStep == stepFiestaFin then
        toggleShaderCinematico(false)
        cameraFlash('camGame', '0xFF87CEEB', 0.8, true)

        runHaxeCode([[
            var totalSteps:Int = 1408 - 1280;
            var duracionSegundos:Float = totalSteps * (Conductor.stepCrochet / 1000.0);

            var globalFade = game.variables.get('globalFadeOverlay');
            if (globalFade != null) {
                FlxTween.tween(globalFade, {alpha: 0.90}, duracionSegundos, {ease: FlxEase.sineInOut});
            }

            var hudOverlay = game.variables.get('hudFadeOverlay');
            if (hudOverlay != null) {
                FlxTween.tween(hudOverlay, {alpha: 0.20}, duracionSegundos, {ease: FlxEase.sineInOut});
            }

            FlxTween.tween(game, {defaultCamZoom: 0.52}, duracionSegundos, {ease: FlxEase.sineInOut});
        ]])
    end
end

function onSectionHit()
    if modoTvOscura then
        snapCamaraInstantanea()
    elseif lucesActivas and not modoDueto then
        local cantante = mustHitSection and 'boyfriend' or 'dad'
        apuntarLuz(1, cantante, false)
        apuntarLuz(2, cantante, false)
        actualizarIluminacionPersonajes(cantante)
    end
end

function onTweenCompleted(tag)
    if tag == 'bajarLinterna1' then
        lucesActivas = true
        local cantanteInicial = mustHitSection and 'boyfriend' or 'dad'
        for i = 1, 2 do
            apuntarLuz(i, cantanteInicial, true)
            doTweenAlpha('encenderHaz' .. i, 'hazLuz' .. i, opacidadLuz, 0.25, 'quadOut')
        end
        actualizarIluminacionPersonajes(cantanteInicial)
        toggleShaderCinematico(true)
    end
end