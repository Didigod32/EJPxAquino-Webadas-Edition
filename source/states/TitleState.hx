package states;

import backend.WeekData;

import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.util.FlxDirectionFlags;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;
import states.StoryMenuState;
import states.OutdatedState;
import states.BootScreenState;
import states.MainMenuState;
import pslice.vslice.components.ScreenshotPlugin;
import pslice.vslice.AttractState;

typedef TitleData =
{
    var titlex:Float;
    var titley:Float;
    var startx:Float;
    var starty:Float;
    var gfx:Float;
    var gfy:Float;
    var backgroundSprite:String;
    var bpm:Float;
}

class TitleState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
    public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
    public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var initialized:Bool = false;

    var enterTimer:FlxTimer;

    var credGroup:FlxGroup = new FlxGroup();
    var textGroup:FlxGroup = new FlxGroup();
    var blackScreen:FlxSprite;
    var colorFlash:FlxSprite;
    var francigod:FlxSprite;
    var arielo:FlxSprite;
    var acSpr:FlxSprite;

    var titleColors:Array<FlxColor> = [0xffff6091, 0xffa31bda];
    var titleTextAlphas:Array<Float> = [1, .64];

    var curWacky:Array<String> = [];

    var wackyImage:FlxSprite;
    var mustUpdate:Bool = false;

    // CONTROL DE REBOTE Y EFECTOS
    var doCamZoom:Bool = false;
    var zoomAmount:Float = 0.015;
    var bgParticleGroup:FlxTypedGroup<FlxSprite>;

    public static var updateVersion:String = '';

    override public function create():Void
    {
        Paths.clearStoredMemory();
        super.create();
        Paths.clearUnusedMemory();

        if(!initialized)
        {
            ClientPrefs.loadPrefs();
            Language.reloadPhrases();
        }

        curWacky = FlxG.random.getObject(getIntroTextShit());

        if(!initialized) {
            if (FlxG.save.data != null && FlxG.save.data.fullscreen) {
                FlxG.fullscreen = FlxG.save.data.fullscreen;
            }
            persistentUpdate = true;
            persistentDraw = true;
            #if TOUCH_CONTROLS_ALLOWED
            MobileData.init();
            #end
        }

        if (FlxG.save.data.weekCompleted != null)
        {
            StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
        }

        FlxG.mouse.visible = false;
        #if FREEPLAY
        MusicBeatState.switchState(new FreeplayState());
        #elseif CHARTING
        MusicBeatState.switchState(new ChartingState());
        #else
        if (FlxG.save.data.flashing == null && !FlashingState.leftState) {
            controls.isInSubstate = false;
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;
            MusicBeatState.switchState(new FlashingState());
        } else {
            if (initialized)
                startIntro();
            else
            {
                ScreenshotPlugin.initialize();
                new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    startIntro();
                });
            }
        }
        #end
    }

    var logoBl:FlxSprite;
    var menuaq:FlxSprite;
    var menudux:FlxSprite;
    var danceLeft:Bool = false;
    var titleText:FlxSprite;
    var colorBG:FlxSprite;
    var peakBG:FlxBackdrop;
    var swagShader:ColorSwap = null;

    function startIntro() {
        persistentUpdate = true;
        if (!initialized && FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

        loadJsonData();
        Conductor.bpm = musicBPM;

        peakBG = new FlxBackdrop(FlxGridOverlay.createGrid(100, 100, 200, 200, true, 0xffffffff, 0xffaaaaaa));
        peakBG.velocity.set(-50, 50);
        add(peakBG);

        colorBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        colorBG.scale.set(FlxG.width, FlxG.height);
        colorBG.alpha = 0.75;
        colorBG.updateHitbox();
        colorBG.screenCenter();
        add(colorBG);
        
        menuaq = new FlxSprite(-60, 30);
        menuaq.frames = Paths.getSparrowAtlas('titlescreen/menu-characters');
        menuaq.animation.addByPrefix('tilin', 'aquino y aquino loop', 24, false);
        menuaq.scale.set(0.8, 0.8);
        menuaq.updateHitbox();
        menuaq.animation.play('tilin');
        menuaq.antialiasing = ClientPrefs.data.antialiasing;
        add(menuaq);

        menudux = new FlxSprite(900, -60);
        menudux.frames = Paths.getSparrowAtlas('titlescreen/menu-characters');
        menudux.animation.addByPrefix('tilin', 'duxo y la bot loop', 24, false);
        menudux.animation.play('tilin');
        menudux.scale.set(0.8, 0.8);
        menudux.antialiasing = ClientPrefs.data.antialiasing;
        menudux.updateHitbox();
        add(menudux);

        logoBl = new FlxSprite(logoPosition.x, logoPosition.y);
        logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
        logoBl.scale.set(1.1, 1.1);
        logoBl.antialiasing = ClientPrefs.data.antialiasing;
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
        logoBl.animation.play('bump');
        logoBl.updateHitbox();
        add(logoBl);

        var animFrames:Array<FlxFrame> = [];
        titleText = new FlxSprite(enterPosition.x, enterPosition.y);
        titleText.frames = Paths.getSparrowAtlas('titleEnter');
        
        @:privateAccess {
            titleText.animation.findByPrefix(animFrames, "Press Enter to Begin");
            titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
        }
        
        if (newTitle = animFrames.length > 0) {
            titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
            titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
        } else {
            titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
            titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
        }
        titleText.animation.play('idle');
        titleText.updateHitbox();
        add(titleText);

        if (ClientPrefs.data.shaders) {
            swagShader = new ColorSwap();
            colorBG.shader = swagShader.shader;
            logoBl.shader = swagShader.shader;
            titleText.shader = swagShader.shader;
        }
        
        add(credGroup);

        blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        blackScreen.scale.set(FlxG.width, FlxG.height);
        blackScreen.updateHitbox();
        credGroup.add(blackScreen);

        // Capa de destellos sobre el fondo negro
        colorFlash = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
        colorFlash.scale.set(FlxG.width, FlxG.height);
        colorFlash.updateHitbox();
        colorFlash.alpha = 0;
        credGroup.add(colorFlash);

        // Grupo de partículas sobre el fondo negro
        bgParticleGroup = new FlxTypedGroup<FlxSprite>();
        credGroup.add(bgParticleGroup);

        francigod = new FlxSprite(0, 350).loadGraphic(Paths.image('titlescreen/FranciGOD'));
        francigod.scale.set(0.3, 0.3);
        francigod.updateHitbox();
        francigod.screenCenter(X);
        francigod.visible = false;
        francigod.antialiasing = ClientPrefs.data.antialiasing;
        add(francigod);

        arielo = new FlxSprite(0, 350).loadGraphic(Paths.image('titlescreen/Arielo'));
        arielo.screenCenter(X);
        arielo.visible = false;
        arielo.antialiasing = false;
        add(arielo);

        acSpr = new FlxSprite(0, 400).loadGraphic(Paths.image('titlescreen/acLogo'));
        acSpr.screenCenter(X);
        acSpr.visible = false;
        acSpr.antialiasing = ClientPrefs.data.antialiasing;
        add(acSpr);
        
        if (initialized)
            skipIntro();
        else
            initialized = true;
    }

    var characterImage:String = 'gfDanceTitle';
    var animationName:String = 'gfDance';

    var logoPosition:FlxPoint = FlxPoint.get(-150, -100);
    var enterPosition:FlxPoint = FlxPoint.get(100, 576);
    var musicBPM:Float = 102;

    function loadJsonData()
    {
        if(Paths.fileExists('images/gfDanceTitle.json', TEXT))
        {
            var titleRaw:String = Paths.getTextFromFile('images/gfDanceTitle.json');
            if(titleRaw != null && titleRaw.length > 0)
            {
                try
                {
                    var titleJSON:TitleData = tjson.TJSON.parse(titleRaw);
                    logoPosition.set(titleJSON.titlex, titleJSON.titley);
                    enterPosition.set(titleJSON.startx, titleJSON.starty);
                    musicBPM = titleJSON.bpm;
    
                    if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.trim().length > 0)
                    {
                        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(titleJSON.backgroundSprite));
                        bg.antialiasing = ClientPrefs.data.antialiasing;
                        add(bg);
                    }
                }
                catch(e:haxe.Exception) {
                    trace('[WARN] Title JSON might broken, ignoring issue...\n${e.details()}');
                }
            }
            else trace('[WARN] No Title JSON detected, using default values.');
        }
    }

    function getIntroTextShit():Array<Array<String>>
    {
        #if MODS_ALLOWED
        var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt');
        #else
        var fullText:String = Assets.getText(Paths.txt('introText'));
        var firstArray:Array<String> = fullText.split('\n');
        #end
        var swagGoodArray:Array<Array<String>> = [];

        for (i in firstArray)
        {
            swagGoodArray.push(i.split('--'));
        }

        return swagGoodArray;
    }

    var transitioning:Bool = false;

    private static var playJingle:Bool = false;

    var newTitle:Bool = false;
    var titleTimer:Float = 0;

    override function update(elapsed:Float)
    {
        #if debug
        if (controls.FAVORITE)
            moveToAttract();
        #end

        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        // RETORNO SUAVE DEL ZOOM
        if (doCamZoom)
        {
            FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, FlxMath.bound(elapsed * 3.125, 0, 1));
        }

        // DESVANECIMIENTO SUAVE DEL DESTELLO DE COLOR
        if (colorFlash != null && colorFlash.alpha > 0)
        {
            colorFlash.alpha = FlxMath.lerp(colorFlash.alpha, 0, FlxMath.bound(elapsed * 5, 0, 1));
        }

        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT || (TouchUtil.justReleased && !SwipeUtil.swipeAny);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (gamepad != null)
        {
            if (gamepad.justPressed.START)
                pressedEnter = true;

            #if switch
            if (gamepad.justPressed.B)
                pressedEnter = true;
            #end
        }

        if(enterTimer != null && pressedEnter){
            enterTimer.cancel();
            enterTimer.onComplete(enterTimer);
            enterTimer = null;
        }

        if (newTitle)
        {
            titleTimer += FlxMath.bound(elapsed, 0, 1);
            if (titleTimer > 2)
                titleTimer -= 2;
        }

        if (initialized && !transitioning && skippedIntro)
        {
            if (newTitle && !pressedEnter)
            {
                var timer:Float = titleTimer;
                if (timer >= 1)
                    timer = (-timer) + 2;

                timer = FlxEase.quadInOut(timer);

                colorBG.color = FlxColor.interpolate(titleColors[0], titleColors[1], timer);
            }

            if (pressedEnter)
            {
                titleText.color = FlxColor.WHITE;
                titleText.alpha = 1;

                if (titleText != null)
                    titleText.animation.play('press');

                FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

                transitioning = true;

                enterTimer = new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    if (mustUpdate)
                    {
                        MusicBeatState.switchState(new OutdatedState());
                    }
                    else
                    {
                        if (cheatActive)
                        {
                            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
                            FlxG.sound.music.fadeIn(4, 0, 0.7);
                        }
                        FlxTransitionableState.skipNextTransIn = true;
                        MusicBeatState.switchState(new BootScreenState());                  }

                    closedState = true;
                });
            }
            #if TITLE_SCREEN_EASTER_EGG
            else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
            {
                var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
                var keyName:String = Std.string(keyPressed);
                if (allowedKeys.contains(keyName))
                {
                    easterEggKeysBuffer += keyName;
                    if (easterEggKeysBuffer.length >= 32)
                        easterEggKeysBuffer = easterEggKeysBuffer.substring(1);

                    for (wordRaw in easterEggKeys)
                    {
                        var word:String = wordRaw.toUpperCase();
                        if (easterEggKeysBuffer.contains(word))
                        {
                            if (FlxG.save.data.psychDevsEasterEgg == word)
                                FlxG.save.data.psychDevsEasterEgg = '';
                            else
                                FlxG.save.data.psychDevsEasterEgg = word;
                            FlxG.save.flush();

                            FlxG.sound.play(Paths.sound('secret'));

                            var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
                            black.scale.set(FlxG.width, FlxG.height);
                            black.updateHitbox();
                            black.alpha = 0;
                            add(black);

                            FlxTween.tween(black, {alpha: 1}, 1, {
                                onComplete: function(twn:FlxTween)
                                {
                                    FlxTransitionableState.skipNextTransIn = true;
                                    FlxTransitionableState.skipNextTransOut = true;
                                    MusicBeatState.switchState(new TitleState());
                                }
                            });
                            FlxG.sound.music.fadeOut();
                            closedState = true;
                            transitioning = true;
                            playJingle = true;
                            easterEggKeysBuffer = '';
                            break;
                        }
                    }
                }
            }
            #end
        }

        if (initialized && pressedEnter && !skippedIntro)
        {
            skipIntro();
        }

        if (swagShader != null)
        {
            if (cheatActive && TouchUtil.pressed || controls.UI_LEFT)
                swagShader.hue -= elapsed * 0.1;
            if (controls.UI_RIGHT)
                swagShader.hue += elapsed * 0.1;
        }

        super.update(elapsed);
    }

    function createCoolText(textArray:Array<String>, ?offset:Float = 0)
    {
        for (i in 0...textArray.length)
        {
            if (ClientPrefs.data.vibrating)
                lime.ui.Haptic.vibrate(100, 100);

            var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
            money.screenCenter(X);
            money.y += (i * 60) + 200 + offset;

            if (credGroup != null && textGroup != null)
            {
                credGroup.add(money);
                textGroup.add(money);
            }
        }
    }

    function addMoreText(text:String, ?offset:Float = 0)
    {
        if (textGroup != null && credGroup != null)
        {
            var coolText:Alphabet = new Alphabet(0, 0, text, true);
            coolText.screenCenter(X);
            coolText.y += (textGroup.length * 60) + 200 + offset;
            credGroup.add(coolText);
            textGroup.add(coolText);
        }
    }

    function deleteCoolText()
    {
        while (textGroup.members.length > 0)
        {
            credGroup.remove(textGroup.members[0], true);
            textGroup.remove(textGroup.members[0], true);
        }
    }

    // Generación de Partículas de Colores
    function spawnBgParticles(count:Int = 4):Void
    {
        if (bgParticleGroup == null) return;

        for (i in 0...count)
        {
            var p:FlxSprite = new FlxSprite(FlxG.random.float(50, FlxG.width - 50), FlxG.random.float(FlxG.height * 0.4, FlxG.height * 0.9));
            var pSize:Int = FlxG.random.int(10, 20);
            var pColor:FlxColor = FlxColor.fromHSB(FlxG.random.float(0, 360), 0.85, 1);
            
            p.makeGraphic(pSize, pSize, FlxColor.WHITE);
            p.color = pColor;
            p.alpha = FlxG.random.float(0.7, 1.0);
            p.antialiasing = ClientPrefs.data.antialiasing;

            bgParticleGroup.add(p);

            var targetY:Float = p.y - FlxG.random.float(120, 250);
            var targetX:Float = p.x + FlxG.random.float(-60, 60);

            FlxTween.tween(p, {y: targetY, x: targetX, alpha: 0, "scale.x": 0.1, "scale.y": 0.1}, FlxG.random.float(0.6, 1.2), {
                ease: FlxEase.quadOut,
                onComplete: function(twn:FlxTween) {
                    bgParticleGroup.remove(p, true);
                    p.destroy();
                }
            });
        }
    }

    private var sickBeats:Int = 0;

    public static var closedState:Bool = false;

    override function beatHit()
    {
        super.beatHit();

        if(logoBl != null) logoBl.animation.play('bump', true);

        if(menuaq != null) menuaq.animation.play('tilin', true);
        if(menudux != null) menudux.animation.play('tilin', true);

        // APLICAR REBOTE DE CÁMARA
        if (doCamZoom && !skippedIntro)
        {
            FlxG.camera.zoom += zoomAmount;

            // EL COLOR Y LAS PARTÍCULAS SOLO SE ACTIVAN CUANDO EMPIEZA EL REBOTE FUERTE (zoomAmount > 0.02)
            if (zoomAmount > 0.02)
            {
                if (colorFlash != null)
                {
                    colorFlash.color = FlxColor.fromHSB((sickBeats * 35) % 360, 0.85, 1);
                    colorFlash.alpha = 0.45;
                }

                spawnBgParticles(6);
            }
        }

        if (!closedState) {
            sickBeats++;
            switch (sickBeats) {
                case 1:
                    FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
                    #if VIDEOS_ALLOWED
                        FlxG.sound.music.onComplete = moveToAttract;
                    #end
                    FlxG.sound.music.fadeIn(4, 0, 0.7);

                    // INICIO DEL BOP SUAVE DE CÁMARA (Solo movimiento suave, sin color)
                    doCamZoom = true;
                    zoomAmount = 0.015;

                    createCoolText(['Mod creado por']);
                case 4:
                    addMoreText('El equipo profesional', 15);
                    francigod.visible = true;
                case 5:
                    deleteCoolText();
                    francigod.visible = false;
                case 7:
                    addMoreText('idea original por', -40);
                case 8:
                    addMoreText('arielo_018', -40);
                    arielo.visible = true;
                case 9:
                    deleteCoolText();
                    arielo.visible = false;
                case 12:
                    createCoolText(['Tal vez colaborando', 'con la'], -40);
                case 13:
                    addMoreText('Aquino Community', -40);
                    acSpr.visible = true;
                case 14:
                    deleteCoolText();
                    acSpr.visible = false;
                case 15:
                    addMoreText('Que grandes son', -40);
                case 16:
                    deleteCoolText();
                    // AQUI COMIENZA EL REBOTE POTENTE + DESTELLOS DE COLOR + PARTÍCULAS
                    zoomAmount = 0.035;
                case 17:
                    addMoreText('tilín es grande', -40);
                case 18:
                    addMoreText('of course', -40);
                case 19:
                    deleteCoolText();
                case 20:
                    addMoreText('Aquí somos muy serios', -40);
                case 21:
                    addMoreText('de verdad', -40);
                case 22:
                    deleteCoolText();
                case 23:
                    createCoolText([curWacky[0]]);
                case 24:
                    addMoreText(curWacky[1]);
                case 25:
                    if (curWacky[2] != null) addMoreText(curWacky[2]);
                case 26:
                    deleteCoolText();
                case 28:
                    addMoreText('Esto no sería', -40);
                case 30:
                    addMoreText('posible sin', -40);
                case 31:
                    addMoreText('la hermosa comunidad', -40);
                    new FlxTimer().start(0.2, function(leTimer){
                        deleteCoolText();
                        addMoreText('Hijos de puta');
                    });
                case 32:
                    deleteCoolText();
                case 34:
                    addMoreText('Webadas mod');
                case 36:
                    addMoreText('Versión');
                case 37:
                    addMoreText('tu perra');
                    new FlxTimer().start(0.2, function(leTimer){
                        deleteCoolText();
                        addMoreText('Webadas mod');
                        addMoreText('Versión');
                        addMoreText('???');
                    });
                case 38:
                    deleteCoolText();
                case 39:
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 0.4);
                    addMoreText('El', -40);
                case 41:
                    FlxG.camera.zoom = 1;
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 0.5);
                    addMoreText('Juego', -40);
                case 42:
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 0.6);
                    addMoreText('Popular', -40);
                case 43:
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 0.7);
                    addMoreText('X', -40);
                case 44:
                    doCamZoom = false;
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 0.8);
                    addMoreText('Aquino', -40); 
                case 46:
                    FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0xFFF7F1F1, 2);
                    skipIntro();
            }
        }
    }

    var skippedIntro:Bool = false;

    function skipIntro():Void {
        if (!skippedIntro) {
            doCamZoom = false;
            FlxG.camera.zoom = 1;
            remove(francigod);
            remove(arielo);
            remove(acSpr);
            remove(credGroup);
            FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
            skippedIntro = true;
        }
    }

    // Cheat code
    var cheatArray:Array<Int> = [0x0001, 0x0010, 0x0001, 0x0010, 0x0100, 0x1000, 0x0100, 0x1000];
    var curCheatPos:Int = 0;
    var cheatActive:Bool = false;

    function cheatCodeShit():Void
    {
        if (SwipeUtil.swipeAny || FlxG.keys.justPressed.ANY)
        {
            if (controls.NOTE_DOWN_P || controls.UI_DOWN_P || SwipeUtil.swipeUp)
                codePress(FlxDirectionFlags.DOWN);
            if (controls.NOTE_UP_P || controls.UI_UP_P  || SwipeUtil.swipeDown)
                codePress(FlxDirectionFlags.UP);
            if (controls.NOTE_LEFT_P || controls.UI_LEFT_P || SwipeUtil.swipeRight)
                codePress(FlxDirectionFlags.LEFT);
            if (controls.NOTE_RIGHT_P || controls.UI_RIGHT_P || SwipeUtil.swipeLeft)
                codePress(FlxDirectionFlags.RIGHT);
        }
    }

    function codePress(input:Int)
    {
        if (input == cheatArray[curCheatPos])
        {
            curCheatPos += 1;
            if (curCheatPos >= cheatArray.length)
                startCheat();
        }
        else
            curCheatPos = 0;

        trace(input);
    }

    function startCheat():Void
    {
        cheatActive = true;

        FlxG.sound.playMusic(Paths.music('girlfriendsRingtone'), 0);
        Conductor.bpm = 160;

        FlxG.sound.music.fadeIn(4.0, 0.0, 1.0);

        FlxG.camera.flash(FlxColor.WHITE, 1);
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
    }

    function moveToAttract():Void
    {   
        if(!Std.isOfType(FlxG.state,TitleState)) return;
        FlxG.switchState(() -> new AttractState());
    }
}